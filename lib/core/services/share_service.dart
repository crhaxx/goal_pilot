import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareService {
  static Future<void> shareGoal(Goal goal, AppLocalizations l10n) {
    final milestone = goal.currentMilestone;
    final buffer = StringBuffer()
      ..writeln('🎯 ${goal.title}')
      ..writeln(l10n.shareProgressLabel(goal.progressPercent))
      ..writeln(l10n.shareStreak(goal.streak))
      ..writeln(l10n.shareMilestones(
        goal.completedMilestoneCount,
        goal.totalMilestones,
      ));

    if (milestone != null) {
      buffer.writeln(l10n.shareCurrentFocus(milestone.title));
    }

    if (goal.dailyHabit.isNotEmpty) {
      buffer.writeln(l10n.shareDailyHabit(goal.dailyHabit));
    }

    buffer.writeln('\n${l10n.shareTrackedWith}');

    return Share.share(buffer.toString());
  }

  static Future<void> shareAllGoals(List<Goal> goals, AppLocalizations l10n) {
    if (goals.isEmpty) {
      return Share.share(l10n.shareGettingStarted);
    }

    final buffer = StringBuffer('${l10n.shareMyProgress}\n\n');

    for (final goal in goals) {
      buffer.writeln('🎯 ${goal.title}');
      buffer.writeln(
        '   ${goal.progressPercent}% · ${l10n.shareStreak(goal.streak)}',
      );
      buffer.writeln(
        '   ${l10n.shareMilestones(goal.completedMilestoneCount, goal.totalMilestones)}',
      );
      buffer.writeln();
    }

    final avgProgress = goals.isEmpty
        ? 0
        : (goals.map((g) => g.progressPercent).reduce((a, b) => a + b) /
                goals.length)
            .round();
    buffer.writeln(l10n.shareAvgProgress(avgProgress));

    return Share.share(buffer.toString().trim());
  }

  static Future<void> shareWeeklyReview({
    required String reviewText,
    required List<Goal> goals,
    required AppLocalizations l10n,
  }) {
    final buffer = StringBuffer('${l10n.shareWeeklyReviewHeader}\n\n')
      ..writeln(reviewText.trim())
      ..writeln('\n---')
      ..writeln(l10n.shareActiveGoals(
        goals.where((g) => g.status.isActive).length,
      ));

    return Share.share(buffer.toString().trim());
  }
}
