import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../../../../core/config/llm_config.dart';
import '../../domain/models/generated_note.dart';
import '../../domain/models/note_generation_exception.dart';
import '../../domain/models/note_generation_request.dart';
import 'note_generation_prompt.dart';

typedef _PreparedImage = ({Uint8List bytes, int width, int height});

class NoteGenerationService {
  NoteGenerationService(this._client);

  final http.Client _client;

  static const int _maxImageSide = 1568;
  static const int _jpegQuality = 85;

  Future<GeneratedNote> generate(NoteGenerationRequest request) async {
    if (!LlmConfig.isConfigured) {
      throw const NoteGenerationException(
        'LLM API anahtarı yapılandırılmamış. ANTHROPIC_API_KEY değerini '
        '.env dosyasına ekle.',
      );
    }

    final sourceBytes = await request.imageFile.readAsBytes();
    final image = await compute(_prepareImage, sourceBytes);

    final body = jsonEncode({
      'model': LlmConfig.model,
      'max_tokens': LlmConfig.maxOutputTokens,
      'system': NoteGenerationPrompt.system,
      'tools': [NoteGenerationPrompt.toolDefinition],
      'tool_choice': {'type': 'tool', 'name': NoteGenerationPrompt.toolName},
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': base64Encode(image.bytes),
              },
            },
            {
              'type': 'text',
              'text': NoteGenerationPrompt.userMessage(
                detections: request.detections,
                imageWidth: image.width,
                imageHeight: image.height,
              ),
            },
          ],
        },
      ],
    });

    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(LlmConfig.baseUrl),
            headers: {
              'content-type': 'application/json',
              'x-api-key': LlmConfig.apiKey,
              'anthropic-version': LlmConfig.apiVersion,
            },
            body: body,
          )
          .timeout(LlmConfig.requestTimeout);
    } on Exception {
      throw const NoteGenerationException(
        'Sunucuya ulaşılamadı. Bağlantını kontrol edip tekrar dene.',
      );
    }

    final decoded = _decodeBody(response);
    if (response.statusCode != 200) {
      throw NoteGenerationException(_errorMessage(response.statusCode, decoded));
    }

    return _parseNote(decoded);
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      return const {};
    }
    return const {};
  }

  String _errorMessage(int statusCode, Map<String, dynamic> body) {
    final error = body['error'];
    final detail = error is Map<String, dynamic>
        ? error['message'] as String?
        : null;

    return switch (statusCode) {
      401 => 'LLM API anahtarı geçersiz.',
      429 => 'İstek limiti aşıldı. Biraz bekleyip tekrar dene.',
      >= 500 => 'LLM servisi şu an yanıt veremiyor. Tekrar dene.',
      _ => detail ?? 'Not oluşturulamadı (hata kodu $statusCode).',
    };
  }

  GeneratedNote _parseNote(Map<String, dynamic> body) {
    final content = body['content'];
    if (content is List<dynamic>) {
      for (final block in content) {
        if (block is Map<String, dynamic> &&
            block['type'] == 'tool_use' &&
            block['name'] == NoteGenerationPrompt.toolName &&
            block['input'] is Map<String, dynamic>) {
          final note = GeneratedNote.fromJson(
            block['input'] as Map<String, dynamic>,
          );
          if (note.title.isNotEmpty && note.sections.isNotEmpty) return note;
        }
      }
    }
    throw const NoteGenerationException(
      'Model beklenen formatta bir not üretemedi. Tekrar dene.',
    );
  }
}

_PreparedImage _prepareImage(Uint8List sourceBytes) {
  final decoded = img.decodeImage(sourceBytes);
  if (decoded == null) {
    throw const NoteGenerationException('Görsel çözümlenemedi.');
  }

  final oriented = img.bakeOrientation(decoded);
  final longestSide = oriented.width > oriented.height
      ? oriented.width
      : oriented.height;
  final resized = longestSide > NoteGenerationService._maxImageSide
      ? img.copyResize(
          oriented,
          width: oriented.width >= oriented.height
              ? NoteGenerationService._maxImageSide
              : null,
          height: oriented.height > oriented.width
              ? NoteGenerationService._maxImageSide
              : null,
          interpolation: img.Interpolation.average,
        )
      : oriented;

  final bytes = Uint8List.fromList(
    img.encodeJpg(resized, quality: NoteGenerationService._jpegQuality),
  );
  return (bytes: bytes, width: resized.width, height: resized.height);
}
