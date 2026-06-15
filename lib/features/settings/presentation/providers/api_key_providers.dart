import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/di/core_providers.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/features/settings/domain/repositories/gemini_api_key_repository.dart';

class ApiKeySetupController extends StateNotifier<AsyncValue<void>> {
  ApiKeySetupController(this._repository) : super(const AsyncData(null));

  final GeminiApiKeyRepository _repository;

  Future<bool> validateAndSave(String apiKey) async {
    state = const AsyncLoading();
    try {
      await _repository.validateAndSave(apiKey);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> clearKey() async {
    state = const AsyncLoading();
    try {
      await _repository.deleteApiKey();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  void resetError() => state = const AsyncData(null);
}

final apiKeySetupControllerProvider =
    StateNotifierProvider<ApiKeySetupController, AsyncValue<void>>((ref) {
  return ApiKeySetupController(ref.watch(geminiApiKeyRepositoryProvider));
});

final hasSavedGeminiApiKeyProvider = FutureProvider<bool>((ref) async {
  return ref.watch(geminiApiKeyRepositoryProvider).hasApiKey();
});

String apiKeySetupErrorMessage(Object error) {
  if (error is ValidationFailure) return error.message;
  if (error is TimeoutFailure) {
    return 'Request timed out. Check your connection and try again.';
  }
  if (error is Failure && error.message.isNotEmpty) return error.message;
  return error.toString();
}
