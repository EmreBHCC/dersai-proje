class LlmConfig {
  const LlmConfig._();

  static const String apiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

  static const String baseUrl = String.fromEnvironment(
    'ANTHROPIC_BASE_URL',
    defaultValue: 'https://api.anthropic.com/v1/messages',
  );

  static const String model = String.fromEnvironment(
    'ANTHROPIC_MODEL',
    defaultValue: 'claude-sonnet-5-5',
  );

  static const String apiVersion = '2023-06-01';

  static const int maxOutputTokens = 4096;

  static const Duration requestTimeout = Duration(seconds: 90);

  static bool get isConfigured => apiKey.isNotEmpty;
}
