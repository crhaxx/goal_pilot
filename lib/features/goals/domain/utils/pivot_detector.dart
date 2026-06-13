import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';

/// Detects when Pilot should suggest a goal pivot.
abstract final class PivotDetector {
  static const consecutiveLowMoodThreshold = 3;
  static const lowMoodMax = 2;

  static bool shouldSuggestPivot(List<DailyCheckIn> checkIns) {
    if (checkIns.length < consecutiveLowMoodThreshold) return false;

    final sorted = List<DailyCheckIn>.from(checkIns)
      ..sort((a, b) => b.date.compareTo(a.date));

    var consecutive = 0;
    DateTime? previousDate;

    for (final checkIn in sorted) {
      if (checkIn.mood > lowMoodMax) break;

      if (previousDate != null &&
          !DateUtils.isYesterday(previousDate, checkIn.date)) {
        break;
      }

      consecutive++;
      previousDate = checkIn.date;

      if (consecutive >= consecutiveLowMoodThreshold) return true;
    }

    return false;
  }

  static String pivotReason(List<DailyCheckIn> checkIns, AppLocalizations l10n) {
    final recent = checkIns.take(3).toList();
    final moods = recent.map((c) => c.mood).join(', ');
    final notes = recent
        .where((c) => c.note != null && c.note!.trim().isNotEmpty)
        .map((c) => c.note!.trim())
        .take(2)
        .join('; ');
    final notesSuffix =
        notes.isEmpty ? '' : l10n.pivotReasonNotes(notes);
    return l10n.pivotReason(moods, notesSuffix);
  }
}
