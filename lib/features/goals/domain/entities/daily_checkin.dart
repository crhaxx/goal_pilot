import 'package:equatable/equatable.dart';

class DailyCheckIn extends Equatable {
  const DailyCheckIn({
    required this.id,
    required this.goalId,
    required this.date,
    required this.mood,
    this.note,
    this.pilotMessage,
    this.tasksCompleted = 0,
    this.tasksTotal = 0,
    this.antiGoalSurrendered,
    this.antiGoalIndex,
  });

  final String id;
  final String goalId;
  final DateTime date;
  final int mood;
  final String? note;
  final String? pilotMessage;
  final int tasksCompleted;
  final int tasksTotal;
  final bool? antiGoalSurrendered;
  final int? antiGoalIndex;

  @override
  List<Object?> get props => [
        id,
        goalId,
        date,
        mood,
        note,
        pilotMessage,
        tasksCompleted,
        tasksTotal,
        antiGoalSurrendered,
        antiGoalIndex,
      ];
}
