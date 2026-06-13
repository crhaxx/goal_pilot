/// Helpers for interpreting Gemini / Generative AI SDK errors.
abstract final class GeminiErrorUtils {
  static bool isQuotaError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('quota') ||
        lower.contains('rate limit') ||
        lower.contains('rate-limit') ||
        lower.contains('resource_exhausted') ||
        lower.contains('exceeded your current quota');
  }

  /// Model ID invalid, deprecated, or not enabled for this API key.
  static bool isModelUnavailableError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('is not found') ||
        lower.contains('not found for api version') ||
        lower.contains('not supported for generatecontent') ||
        lower.contains('model not found') ||
        lower.contains('was not found') ||
        lower.contains('does not exist');
  }

  static bool isRetryableWithNextModel(String message) {
    return isQuotaError(message) || isModelUnavailableError(message);
  }

  /// Parses "Please retry in 42.267597672s." from Gemini quota responses.
  static Duration? parseRetryAfter(String message) {
    final match = RegExp(
      r'retry in (\d+(?:\.\d+)?)s',
      caseSensitive: false,
    ).firstMatch(message);
    if (match == null) return null;

    final seconds = double.tryParse(match.group(1)!);
    if (seconds == null) return null;
    return Duration(milliseconds: (seconds * 1000).round());
  }
}
