import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';

/// Detects when the user needs Dynamic Crisis Mode.
abstract final class CrisisDetector {
  static const _crisisKeywords = [
    'nemám čas',
    'nestíhám',
    'chci s tím seknout',
    'chci to vzdát',
    'kašlu na to',
    'nemám náladu',
    'no time',
    'give up',
    'quit',
    'overwhelmed',
  ];

  static const minHoursWithoutCheckIn = 48;

  static bool shouldSuggestCrisis(Goal goal) {
    if (goal.crisisModeActive || goal.isFullyComplete) return false;
    if (goal.isRestDayToday) return false;

    final today = DateUtils.dateOnly(DateTime.now());
    if (!goal.isActiveDayToday) return false;

    final previousActive = goal.schedule.previousActiveDayBefore(today);
    if (previousActive == null) {
      return _hoursSinceLastCheckIn(goal) >= minHoursWithoutCheckIn;
    }

    if (goal.hasCheckedInOn(previousActive)) {
      return !goal.hasCheckedInToday &&
          DateTime.now().difference(previousActive).inHours >=
              minHoursWithoutCheckIn;
    }

    return today.difference(previousActive).inDays >= 1;
  }

  static bool noteSignalsCrisis(String? note) {
    if (note == null || note.trim().isEmpty) return false;
    final lower = note.toLowerCase();
    return _crisisKeywords.any(lower.contains);
  }

  static bool shouldSuggestCrisisFromCheckIn({
    required Goal goal,
    String? note,
  }) {
    if (goal.crisisModeActive || goal.isFullyComplete) return false;
    if (noteSignalsCrisis(note)) return true;
    return shouldSuggestCrisis(goal);
  }

  static int _hoursSinceLastCheckIn(Goal goal) {
    final last = goal.lastCheckInDate;
    if (last == null) {
      return DateTime.now().difference(goal.createdAt).inHours;
    }
    return DateTime.now().difference(last).inHours;
  }

  static String crisisReason(Goal goal, AppLocalizations l10n, {String? note}) {
    if (noteSignalsCrisis(note)) {
      return l10n.crisisReasonNote;
    }
    final hours = _hoursSinceLastCheckIn(goal);
    final days = (hours / 24).floor();
    return l10n.crisisReasonDays(days, goal.title);
  }

  static bool anyGoalNeedsCrisis(List<Goal> goals) =>
      goals.any(shouldSuggestCrisis);
}
