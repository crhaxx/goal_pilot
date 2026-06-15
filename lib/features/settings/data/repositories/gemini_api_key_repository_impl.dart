import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/services/gemini_api_key_storage_service.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/settings/domain/repositories/gemini_api_key_repository.dart';

class GeminiApiKeyRepositoryImpl implements GeminiApiKeyRepository {
  GeminiApiKeyRepositoryImpl({
    required GeminiApiKeyStorageService storageService,
    required GeminiRemoteDataSource geminiDataSource,
  })  : _storage = storageService,
        _gemini = geminiDataSource;

  final GeminiApiKeyStorageService _storage;
  final GeminiRemoteDataSource _gemini;

  @override
  Future<bool> hasApiKey() => _storage.hasApiKey();

  @override
  Future<String?> getApiKey() => _storage.readApiKey();

  @override
  Future<void> saveApiKey(String apiKey) => _storage.saveApiKey(apiKey);

  @override
  Future<void> deleteApiKey() => _storage.deleteApiKey();

  @override
  Future<void> validateAndSave(String apiKey) async {
    final trimmed = apiKey.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('API key cannot be empty.');
    }

    try {
      await _gemini.validateApiKey(trimmed);
    } on ApiException catch (e) {
      throw ValidationFailure(
        e.message.isNotEmpty
            ? e.message
            : 'Could not validate the API key. Check the key and try again.',
      );
    } on TimeoutException {
      throw const TimeoutFailure();
    }

    await _storage.saveApiKey(trimmed);
  }
}

/// Resolves the user's API key for repository-layer Gemini calls.
class GeminiApiKeyResolver {
  const GeminiApiKeyResolver(this._repository);

  final GeminiApiKeyRepository _repository;

  Future<String> requireApiKey() async {
    final key = await _repository.getApiKey();
    if (key == null || key.trim().isEmpty) {
      throw const MissingApiKeyException();
    }
    return key.trim();
  }
}
