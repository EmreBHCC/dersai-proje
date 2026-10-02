class LlmConfig {
  const LlmConfig._();

  static const String apiKey = String.fromEnvironment('AI_KEY');

  static const String baseUrl = String.fromEnvironment(
    'AI_BASE_URL',
    defaultValue: 'https://api.groq.com/openai/v1/chat/completions',
  );

  static const String model = String.fromEnvironment(
    'AI_MODEL',
    defaultValue: 'qwen/qwen3.8-27b',
  );

  static const int maxOutputTokens = 4096;

  static const Duration requestTimeout = Duration(seconds: 90);

  static bool get isConfigured => apiKey.isNotEmpty;
}
