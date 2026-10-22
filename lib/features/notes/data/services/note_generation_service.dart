import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/llm_config.dart';
import '../../domain/models/generated_note.dart';
import '../../domain/models/note_generation_exception.dart';
import '../../domain/models/note_generation_request.dart';
import 'note_generation_prompt.dart';
import 'ocr_service.dart';

class NoteGenerationService {
  NoteGenerationService(this._client) : _ocrService = OcrService();

  final http.Client _client;
  final OcrService _ocrService;

  Future<GeneratedNote> generate(NoteGenerationRequest request) async {
    if (!LlmConfig.isConfigured) {
      throw const NoteGenerationException(
        'LLM API anahtarı yapılandırılmamış. AI_KEY değerini .env '
        'dosyasına ekle.',
      );
    }

    final ocrText = await _ocrService.recognizeText(request.imageFile);
    if (ocrText.trim().isEmpty) {
      throw const NoteGenerationException(
        'Görselde okunabilir bir yazı bulunamadı. Daha net bir fotoğraf '
        'çekmeyi dene.',
      );
    }

    final body = jsonEncode({
      'model': LlmConfig.model,
      'max_tokens': LlmConfig.maxOutputTokens,
      'tools': [NoteGenerationPrompt.toolDefinition],
      'tool_choice': {
        'type': 'function',
        'function': {'name': NoteGenerationPrompt.toolName},
      },
      'messages': [
        {'role': 'system', 'content': NoteGenerationPrompt.systemFromOcr},
        {
          'role': 'user',
          'content': NoteGenerationPrompt.userMessageFromOcr(ocrText),
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