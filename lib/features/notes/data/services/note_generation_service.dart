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
        'LLM API anahtarı yapılandırılmamış. AI_KEY değerini .env '
        'dosyasına ekle.',
      );
    }

    final sourceBytes = await request.imageFile.readAsBytes();
    final image = await compute(_prepareImage, sourceBytes);

    final body = jsonEncode({
      'models': LlmConfig.models,
      'max_tokens': LlmConfig.maxOutputTokens,
      'tools': [NoteGenerationPrompt.toolDefinition],
      'tool_choice': {
        'type': 'function',
        'function': {'name': NoteGenerationPrompt.toolName},
      },
      'messages': [
        {'role': 'system', 'content': NoteGenerationPrompt.system},
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text': NoteGenerationPrompt.userMessage(
                detections: request.detections,
                imageWidth: image.width,
                imageHeight: image.height,
              ),
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:image/jpeg;base64,${base64Encode(image.bytes)}',
              },
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
              'authorization': 'Bearer ${LlmConfig.apiKey}',
              'x-title': 'Dersai',
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
      402 => 'LLM hesabında yeterli kredi yok.',
      429 =>
        'İstek limiti aşıldı. Biraz bekleyip tekrar dene.'
            '${detail == null ? '' : '\n\n$detail'}',
      >= 500 => 'LLM servisi şu an yanıt veremiyor. Tekrar dene.',
      _ => detail ?? 'Not oluşturulamadı (hata kodu $statusCode).',
    };
  }

  GeneratedNote _parseNote(Map<String, dynamic> body) {
    final arguments = _toolArguments(body);
    if (arguments != null) {
      final note = GeneratedNote.fromJson(arguments);
      if (note.title.isNotEmpty && note.sections.isNotEmpty) return note;
    }
    throw const NoteGenerationException(
      'Model beklenen formatta bir not üretemedi. Tekrar dene.',
    );
  }

  Map<String, dynamic>? _toolArguments(Map<String, dynamic> body) {
    final choices = body['choices'];
    if (choices is! List<dynamic> || choices.isEmpty) return null;
    final first = choices.first;
    if (first is! Map<String, dynamic>) return null;
    final message = first['message'];
    if (message is! Map<String, dynamic>) return null;

    final toolCalls = message['tool_calls'];
    if (toolCalls is! List<dynamic>) return null;
    for (final call in toolCalls) {
      if (call is! Map<String, dynamic>) continue;
      final function = call['function'];
      if (function is! Map<String, dynamic>) continue;
      if (function['name'] != NoteGenerationPrompt.toolName) continue;
      final arguments = function['arguments'];
      if (arguments is! String) continue;
      try {
        final decoded = jsonDecode(arguments);
        if (decoded is Map<String, dynamic>) return decoded;
      } on FormatException {
        return null;
      }
    }
    return null;
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
