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

  static const minDaysWithoutCheckIn = 7;

  static bool shouldSuggestCrisis(Goal goal) {
    if (goal.crisisModeActive || goal.isFullyComplete) return false;
    if (goal.isRestDayToday) return false;
    if (!goal.isActiveDayToday) return false;

    return daysSinceLastCheckIn(goal) >= minDaysWithoutCheckIn;
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

  static int daysSinceLastCheckIn(Goal goal) {
    final last = goal.lastCheckInDate ?? goal.createdAt;
    final today = DateUtils.dateOnly(DateTime.now());
    final lastDay = DateUtils.dateOnly(last);
    return today.difference(lastDay).inDays;
  }

  static String crisisReason(Goal goal, AppLocalizations l10n, {String? note}) {
    if (noteSignalsCrisis(note)) {
      return l10n.crisisReasonNote;
    }
    return l10n.crisisReasonDays(daysSinceLastCheckIn(goal), goal.title);
  }

  static bool anyGoalNeedsCrisis(List<Goal> goals) =>
      goals.any(shouldSuggestCrisis);
}
