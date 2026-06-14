import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/config/env_config.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';

/// Exposes whether the Gemini API key is configured (for startup validation).
final geminiApiKeyConfiguredProvider = Provider<bool>((ref) {
  return EnvConfig.hasGeminiApiKey;
});

final geminiRemoteDataSourceProvider = Provider<GeminiRemoteDataSource>((ref) {
  return GeminiRemoteDataSource(apiKey: EnvConfig.geminiApiKey);
});
