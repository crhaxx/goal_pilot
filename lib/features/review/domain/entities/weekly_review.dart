import 'package:equatable/equatable.dart';

class WeeklyReview extends Equatable {
  const WeeklyReview({
    required this.id,
    required this.weekStart,
    required this.generatedAt,
    required this.summary,
    required this.highlights,
    required this.nextSteps,
  });

  final String id;
  final DateTime weekStart;
  final DateTime generatedAt;
  final String summary;
  final List<String> highlights;
  final List<String> nextSteps;

  @override
  List<Object?> get props => [
        id,
        weekStart,
        generatedAt,
        summary,
        highlights,
        nextSteps,
      ];
}
