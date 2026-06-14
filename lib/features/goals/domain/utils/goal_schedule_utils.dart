import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

abstract final class GoalScheduleUtils {
  static const weekdayKeys = [1, 2, 3, 4, 5, 6, 7];

  static String weekdayShort(int weekday, AppLocalizations l10n) =>
      switch (weekday) {
        1 => l10n.scheduleWeekdayMon,
        2 => l10n.scheduleWeekdayTue,
        3 => l10n.scheduleWeekdayWed,
        4 => l10n.scheduleWeekdayThu,
        5 => l10n.scheduleWeekdayFri,
        6 => l10n.scheduleWeekdaySat,
        7 => l10n.scheduleWeekdaySun,
        _ => '',
      };

  static String formatActiveDays(GoalSchedule schedule, AppLocalizations l10n) {
    final days = schedule.sortedActiveWeekdays
        .map((d) => weekdayShort(d, l10n))
        .toList();
    return days.join(', ');
  }

  static String decompositionPromptLine(
    GoalSchedule schedule,
    AppLocalizations l10n,
  ) {
    final days = formatActiveDays(schedule, l10n);
    return 'User has time for this goal only on [$days]. '
        'Distribute all actionSteps across these days only. '
        'Each actionStep must include activeDayOrder — a 1-based index '
        'within the active-week cycle (1 = first active day, 2 = second, etc.).';
  }

  static bool anyGoalActiveOn(DateTime day, List<Goal> goals) {
    return goals.any(
      (goal) =>
          goal.status.isActive &&
          !goal.isFullyComplete &&
          goal.schedule.isActiveOn(day),
    );
  }

  static bool goalNeedsNotificationOn(Goal goal, DateTime day) {
    return goal.status.isActive &&
        !goal.isFullyComplete &&
        goal.schedule.isActiveOn(day);
  }
}
