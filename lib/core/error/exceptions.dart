/// Thrown when a remote API call fails.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.cause,
    this.isQuotaExceeded = false,
    this.isModelUnavailable = false,
    this.retryAfter,
  });

  final String message;
  final int? statusCode;
  final Object? cause;
  final bool isQuotaExceeded;
  final bool isModelUnavailable;
  final Duration? retryAfter;

  bool get isRetryableWithNextModel =>
      isQuotaExceeded || isModelUnavailable;

  @override
  String toString() => 'ApiException: $message';
}

/// Thrown when Gemini returns malformed or unparseable JSON.
class ParseException implements Exception {
  const ParseException(this.message, {this.rawContent});

  final String message;
  final String? rawContent;

  @override
  String toString() => 'ParseException: $message';
}

/// Thrown when local storage read/write fails.
class CacheException implements Exception {
  const CacheException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when an operation exceeds its time limit.
class TimeoutException implements Exception {
  const TimeoutException(this.message);

  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}
