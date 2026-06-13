/// Date helpers for daily check-ins and streak logic.
abstract final class DateUtils {
  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String dateKey(DateTime value) {
    final date = dateOnly(value);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static bool isYesterday(DateTime value, DateTime reference) {
    final yesterday = dateOnly(reference).subtract(const Duration(days: 1));
    return isSameDay(value, yesterday);
  }
}
