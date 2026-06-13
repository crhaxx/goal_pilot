/// Application-wide configuration constants.
abstract final class AppConfig {
  static const appName = 'GoalPilot';
  static const appTagline = 'Navigate your goals with AI';
  static const version = '0.1.0';

  /// Models tried in order. Gemini 2.x and 1.5 were shut down June 2026.
  /// See https://ai.google.dev/gemini-api/docs/changelog
  static const geminiModels = [
    'gemini-3.1-flash-lite',
    'gemini-3.5-flash',
  ];

  /// Network timeout for Gemini API calls.
  static const apiTimeout = Duration(seconds: 30);

  /// Expected milestone count range from AI decomposition.
  static const minMilestones = 4;
  static const maxMilestones = 6;
}
