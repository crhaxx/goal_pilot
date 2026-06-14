import 'package:equatable/equatable.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';

enum MotivationScenario {
  streakMilestone,
  missedCheckIn,
  lowMood,
  pendingCheckIns,
  allDone,
  steady,
}

class MotivationSnapshot extends Equatable {
  const MotivationSnapshot({
    required this.goals,
    required this.recentCheckIns,
    required this.bestStreak,
    required this.pendingCheckIns,
    required this.missedYesterday,
    required this.latestMood,
    required this.focusGoal,
    required this.scenario,
  });

  final List<Goal> goals;
  final List<DailyCheckIn> recentCheckIns;
  final int bestStreak;
  final int pendingCheckIns;
  final bool missedYesterday;
  final int? latestMood;
  final Goal? focusGoal;
  final MotivationScenario scenario;

  @override
  List<Object?> get props => [
        goals,
        recentCheckIns,
        bestStreak,
        pendingCheckIns,
        missedYesterday,
        latestMood,
        focusGoal,
        scenario,
      ];
}
