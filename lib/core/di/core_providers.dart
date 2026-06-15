import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/services/gemini_api_key_storage_service.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/settings/data/repositories/gemini_api_key_repository_impl.dart';
import 'package:goal_pilot/features/settings/domain/repositories/gemini_api_key_repository.dart';

/// Whether the user has saved a Gemini API key (overridden at startup from main.dart).
final geminiApiKeyConfiguredProvider = StateProvider<bool>((ref) => false);

final geminiApiKeyStorageServiceProvider =
    Provider<GeminiApiKeyStorageService>((ref) {
  return GeminiApiKeyStorageService();
});

final geminiRemoteDataSourceProvider = Provider<GeminiRemoteDataSource>((ref) {
  return GeminiRemoteDataSource();
});

final geminiApiKeyRepositoryProvider = Provider<GeminiApiKeyRepository>((ref) {
  return GeminiApiKeyRepositoryImpl(
    storageService: ref.watch(geminiApiKeyStorageServiceProvider),
    geminiDataSource: ref.watch(geminiRemoteDataSourceProvider),
  );
});

final geminiApiKeyResolverProvider = Provider<GeminiApiKeyResolver>((ref) {
  return GeminiApiKeyResolver(ref.watch(geminiApiKeyRepositoryProvider));
});
