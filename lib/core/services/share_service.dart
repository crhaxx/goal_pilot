import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareService {
  static Future<void> shareGoal(Goal goal) {
    final milestone = goal.currentMilestone;
    final buffer = StringBuffer()
      ..writeln('🎯 ${goal.title}')
      ..writeln('Progress: ${goal.progressPercent}%')
      ..writeln('Streak: ${goal.streak} day${goal.streak == 1 ? '' : 's'}')
      ..writeln(
        'Milestones: ${goal.completedMilestoneCount}/${goal.totalMilestones}',
      );

    if (milestone != null) {
      buffer.writeln('Current focus: ${milestone.title}');
    }

    if (goal.dailyHabit.isNotEmpty) {
      buffer.writeln('Daily habit: ${goal.dailyHabit}');
    }

    buffer.writeln('\nTracked with GoalPilot ✈️');

    return Share.share(buffer.toString());
  }

  static Future<void> shareAllGoals(List<Goal> goals) {
    if (goals.isEmpty) {
      return Share.share('I am getting started with GoalPilot! ✈️');
    }

    final buffer = StringBuffer('My GoalPilot Progress ✈️\n\n');

    for (final goal in goals) {
      buffer.writeln('🎯 ${goal.title}');
      buffer.writeln('   ${goal.progressPercent}% · ${goal.streak}-day streak');
      buffer.writeln(
        '   ${goal.completedMilestoneCount}/${goal.totalMilestones} milestones',
      );
      buffer.writeln();
    }

    final avgProgress = goals.isEmpty
        ? 0
        : (goals.map((g) => g.progressPercent).reduce((a, b) => a + b) /
                goals.length)
            .round();
    buffer.writeln('Average progress: $avgProgress%');

    return Share.share(buffer.toString().trim());
  }

  static Future<void> shareWeeklyReview({
    required String reviewText,
    required List<Goal> goals,
  }) {
    final buffer = StringBuffer('GoalPilot Weekly Review ✈️\n\n')
      ..writeln(reviewText.trim())
      ..writeln('\n---')
      ..writeln('Active goals: ${goals.where((g) => g.status.isActive).length}');

    return Share.share(buffer.toString().trim());
  }
}
