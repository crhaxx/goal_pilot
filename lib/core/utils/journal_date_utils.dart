import 'package:goal_pilot/core/utils/date_utils.dart';

/// Journal days roll over at a configurable time (not at midnight).
abstract final class JournalDateUtils {
  static DateTime currentJournalDate({
    required DateTime now,
    required int dayStartHour,
    required int dayStartMinute,
  }) {
    final today = DateUtils.dateOnly(now);
    final dayStart = DateTime(
      now.year,
      now.month,
      now.day,
      dayStartHour,
      dayStartMinute,
    );
    if (now.isBefore(dayStart)) {
      return today.subtract(const Duration(days: 1));
    }
    return today;
  }

  static bool canEditJournalDate({
    required DateTime journalDate,
    required DateTime now,
    required int dayStartHour,
    required int dayStartMinute,
  }) {
    final current = currentJournalDate(
      now: now,
      dayStartHour: dayStartHour,
      dayStartMinute: dayStartMinute,
    );
    return !journalDate.isAfter(current);
  }

  static DateTime? nextJournalDateUnlock({
    required DateTime now,
    required int dayStartHour,
    required int dayStartMinute,
  }) {
    final current = currentJournalDate(
      now: now,
      dayStartHour: dayStartHour,
      dayStartMinute: dayStartMinute,
    );
    final calendarToday = DateUtils.dateOnly(now);
    if (!current.isBefore(calendarToday)) return null;

    return DateTime(
      now.year,
      now.month,
      now.day,
      dayStartHour,
      dayStartMinute,
    );
  }
}
