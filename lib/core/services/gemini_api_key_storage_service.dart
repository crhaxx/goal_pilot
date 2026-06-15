import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goal_pilot/core/constants/secure_storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';

/// Persists the user's Gemini API key in platform secure storage.
class GeminiApiKeyStorageService {
  GeminiApiKeyStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<String?> readApiKey() async {
    try {
      final value =
          await _storage.read(key: SecureStorageConstants.geminiApiKey);
      if (value == null || value.trim().isEmpty) return null;
      return value.trim();
    } catch (e) {
      throw CacheException('Could not read the Gemini API key.', cause: e);
    }
  }

  Future<bool> hasApiKey() async {
    final key = await readApiKey();
    return key != null;
  }

  Future<void> saveApiKey(String apiKey) async {
    final trimmed = apiKey.trim();
    if (trimmed.isEmpty) {
      throw const CacheException('API key cannot be empty.');
    }
    try {
      await _storage.write(
        key: SecureStorageConstants.geminiApiKey,
        value: trimmed,
      );
    } catch (e) {
      throw CacheException('Could not save the Gemini API key.', cause: e);
    }
  }

  Future<void> deleteApiKey() async {
    try {
      await _storage.delete(key: SecureStorageConstants.geminiApiKey);
    } catch (e) {
      throw CacheException('Could not delete the Gemini API key.', cause: e);
    }
  }
}
