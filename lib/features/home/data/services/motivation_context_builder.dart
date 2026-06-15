import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';
import 'package:goal_pilot/features/home/domain/entities/motivation_snapshot.dart';

abstract final class MotivationContextBuilder {
  static MotivationSnapshot build({
    required List<Goal> goals,
    required List<DailyCheckIn> recentCheckIns,
  }) {
    final activeGoals = goals
        .where((goal) => goal.status.isActive && !goal.isFullyComplete)
        .toList();
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    final pendingCheckIns =
        activeGoals.where((goal) => goal.needsCheckInToday).length;
    final bestStreak = activeGoals.isEmpty
        ? 0
        : activeGoals.map((g) => g.streak).reduce((a, b) => a > b ? a : b);

    final missedYesterday = activeGoals.any((goal) {
      final last = goal.lastCheckInDate;
      if (last == null) return goal.streak > 0;
      return !DateUtils.isSameDay(last, today) &&
          !DateUtils.isSameDay(last, yesterday);
    });

    DailyCheckIn? latestCheckIn;
    for (final checkIn in recentCheckIns) {
      if (latestCheckIn == null ||
          checkIn.date.isAfter(latestCheckIn.date)) {
        latestCheckIn = checkIn;
      }
    }

    final latestMood = latestCheckIn?.mood;
    final focusGoal = _focusGoal(activeGoals);

    final scenario = _resolveScenario(
      bestStreak: bestStreak,
      missedYesterday: missedYesterday,
      latestMood: latestMood,
      pendingCheckIns: pendingCheckIns,
    );

    return MotivationSnapshot(
      goals: activeGoals,
      recentCheckIns: recentCheckIns,
      bestStreak: bestStreak,
      pendingCheckIns: pendingCheckIns,
      missedYesterday: missedYesterday,
      latestMood: latestMood,
      focusGoal: focusGoal,
      scenario: scenario,
    );
  }

  static Goal? _focusGoal(List<Goal> activeGoals) {
    if (activeGoals.isEmpty) return null;

    final pending =
        activeGoals.where((goal) => goal.needsCheckInToday).toList();
    if (pending.isNotEmpty) {
      pending.sort((a, b) {
        final priorityCompare =
            a.priority.sortWeight.compareTo(b.priority.sortWeight);
        if (priorityCompare != 0) return priorityCompare;
        return b.streak.compareTo(a.streak);
      });
      return pending.first;
    }

    activeGoals.sort((a, b) {
      final priorityCompare =
          a.priority.sortWeight.compareTo(b.priority.sortWeight);
      if (priorityCompare != 0) return priorityCompare;
      return b.streak.compareTo(a.streak);
    });
    return activeGoals.first;
  }

  static MotivationScenario _resolveScenario({
    required int bestStreak,
    required bool missedYesterday,
    required int? latestMood,
    required int pendingCheckIns,
  }) {
    if (pendingCheckIns > 0) return MotivationScenario.pendingCheckIns;
    if (bestStreak >= 10) return MotivationScenario.streakMilestone;
    if (missedYesterday) return MotivationScenario.missedCheckIn;
    if (latestMood != null && latestMood <= 2) {
      return MotivationScenario.lowMood;
    }
    if (pendingCheckIns == 0) return MotivationScenario.allDone;
    return MotivationScenario.steady;
  }
}
