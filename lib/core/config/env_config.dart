import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goal_pilot/core/config/app_config.dart';

/// Loads and exposes environment variables for the app.
abstract final class EnvConfig {
  static const _geminiApiKeyKey = 'GEMINI_API_KEY';
  static const _geminiModelKey = 'GEMINI_MODEL';

  /// Gemini API key from `.env` or `--dart-define=GEMINI_API_KEY=...`.
  static String get geminiApiKey {
    const fromDefine = String.fromEnvironment(_geminiApiKeyKey);
    if (fromDefine.isNotEmpty) return fromDefine;

    final fromDotEnv = dotenv.env[_geminiApiKeyKey];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) return fromDotEnv;

    throw StateError(
      'Missing $_geminiApiKeyKey. Add it to .env or pass '
      '--dart-define=$_geminiApiKeyKey=your_key',
    );
  }

  static bool get hasGeminiApiKey {
    const fromDefine = String.fromEnvironment(_geminiApiKeyKey);
    if (fromDefine.isNotEmpty) return true;
    final fromDotEnv = dotenv.env[_geminiApiKeyKey];
    return fromDotEnv != null && fromDotEnv.isNotEmpty;
  }

  /// Optional single-model override from `.env` or `--dart-define=GEMINI_MODEL=...`.
  static List<String> get geminiModels {
    const fromDefine = String.fromEnvironment(_geminiModelKey);
    if (fromDefine.isNotEmpty) return [fromDefine];

    final fromDotEnv = dotenv.env[_geminiModelKey];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) return [fromDotEnv];

    return AppConfig.geminiModels;
  }
}
