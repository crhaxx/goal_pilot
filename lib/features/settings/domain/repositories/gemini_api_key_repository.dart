/// Domain contract for managing the user's Gemini API key (BYOK).
abstract class GeminiApiKeyRepository {
  Future<bool> hasApiKey();

  Future<String?> getApiKey();

  Future<void> saveApiKey(String apiKey);

  Future<void> deleteApiKey();

  /// Validates the key against Gemini, then persists it on success.
  Future<void> validateAndSave(String apiKey);
}
