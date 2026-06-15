import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goal_pilot/core/config/app_config.dart';

/// Loads optional environment overrides (model list only).
///
/// Gemini API keys are user-provided at runtime via secure storage (BYOK).
abstract final class EnvConfig {
  static const _geminiModelKey = 'GEMINI_MODEL';

  /// Optional single-model override from `.env` or `--dart-define=GEMINI_MODEL=...`.
  static List<String> get geminiModels {
    const fromDefine = String.fromEnvironment(_geminiModelKey);
    if (fromDefine.isNotEmpty) return [fromDefine];

    final fromDotEnv = dotenv.env[_geminiModelKey];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) return [fromDotEnv];

    return AppConfig.geminiModels;
  }
}
