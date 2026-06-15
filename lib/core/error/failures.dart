import 'package:equatable/equatable.dart';

/// Domain-layer representation of errors (UI maps these to user messages).
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Check your connection and try again.']);
}

final class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Could not understand the AI response.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not save or load your data.']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out. Please try again.']);
}

final class QuotaFailure extends Failure {
  const QuotaFailure({this.retryAfter}) : super('');

  final Duration? retryAfter;

  @override
  List<Object?> get props => [message, retryAfter];
}

final class ModelUnavailableFailure extends Failure {
  const ModelUnavailableFailure() : super('');
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class MissingApiKeyFailure extends Failure {
  const MissingApiKeyFailure([
    super.message = 'Add your Gemini API key in Settings to use AI features.',
  ]);
}
