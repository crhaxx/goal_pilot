import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';

Failure mapApiException(ApiException exception) {
  if (exception.isQuotaExceeded) {
    return QuotaFailure(retryAfter: exception.retryAfter);
  }
  if (exception.isModelUnavailable) {
    return const ModelUnavailableFailure();
  }
  return ServerFailure(_shortApiMessage(exception.message));
}

String failureMessage(Object error, AppLocalizations l10n) {
  if (error is QuotaFailure) {
    final retry = error.retryAfter;
    if (retry != null && retry.inSeconds > 0) {
      return l10n.failureRetrySeconds(l10n.failureQuota, retry.inSeconds);
    }
    return l10n.failureQuota;
  }
  if (error is ModelUnavailableFailure) return l10n.failureModelUnavailable;
  if (error is ServerFailure) return error.message;
  if (error is NetworkFailure) return l10n.failureNetwork;
  if (error is ParseFailure) return l10n.failureParse;
  if (error is CacheFailure) return l10n.failureCache;
  if (error is TimeoutFailure) return l10n.failureTimeout;
  if (error is MissingApiKeyFailure) return l10n.failureMissingApiKey;
  if (error is Failure) {
    return error.message.isEmpty ? l10n.failureGeneric : error.message;
  }
  return l10n.failureGeneric;
}

String _shortApiMessage(String raw) {
  if (raw.length <= 180) return raw;
  return '${raw.substring(0, 177)}...';
}
