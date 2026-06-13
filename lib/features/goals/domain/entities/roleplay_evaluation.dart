import 'package:equatable/equatable.dart';

/// Post-roleplay performance feedback from Pilot.
class RoleplayEvaluation extends Equatable {
  const RoleplayEvaluation({
    required this.score,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
  });

  final int score;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> improvements;

  @override
  List<Object?> get props =>
      [score, summary, strengths, weaknesses, improvements];
}
