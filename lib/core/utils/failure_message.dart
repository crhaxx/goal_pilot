import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/error/failures.dart';

/// Maps API errors to user-facing [Failure] types.
Failure mapApiException(ApiException exception) {
  if (exception.isQuotaExceeded) {
    return QuotaFailure(retryAfter: exception.retryAfter);
  }
  if (exception.isModelUnavailable) {
    return ServerFailure(
      'Gemini model unavailable. Update GEMINI_MODEL in .env '
      '(try gemini-3.1-flash-lite or gemini-3.5-flash).',
    );
  }
  return ServerFailure(_shortApiMessage(exception.message));
}

String failureMessage(Object error) {
  if (error is QuotaFailure) {
    final retry = error.retryAfter;
    if (retry != null && retry.inSeconds > 0) {
      final seconds = retry.inSeconds;
      return '${error.message}\nTry again in about $seconds seconds.';
    }
    return error.message;
  }
  if (error is Failure) return error.message;
  return 'Something went wrong. Please try again.';
}

String _shortApiMessage(String raw) {
  if (raw.length <= 180) return raw;
  return '${raw.substring(0, 177)}...';
}
