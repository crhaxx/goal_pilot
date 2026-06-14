import 'package:equatable/equatable.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';

enum GoalScheduleType {
  everyDay,
  timesPerWeek,
  weekendsOnly;

  bool get isEveryDay => this == GoalScheduleType.everyDay;
  bool get isTimesPerWeek => this == GoalScheduleType.timesPerWeek;
  bool get isWeekendsOnly => this == GoalScheduleType.weekendsOnly;
}

/// When the user works on a goal. Weekdays use [DateTime.weekday] (1 = Mon … 7 = Sun).
class GoalSchedule extends Equatable {
  const GoalSchedule({
    this.type = GoalScheduleType.everyDay,
    this.timesPerWeek = 3,
    this.activeWeekdays = const {1, 2, 3, 4, 5, 6, 7},
  });

  final GoalScheduleType type;
  final int timesPerWeek;
  final Set<int> activeWeekdays;

  static const everyDay = GoalSchedule();

  static const weekendsOnly = GoalSchedule(
    type: GoalScheduleType.weekendsOnly,
    activeWeekdays: {6, 7},
  );

  factory GoalSchedule.timesPerWeek(
    int count, {
    Set<int>? weekdays,
  }) {
    final clamped = count.clamp(1, 7);
    return GoalSchedule(
      type: GoalScheduleType.timesPerWeek,
      timesPerWeek: clamped,
      activeWeekdays: weekdays ?? defaultWeekdaysForCount(clamped),
    );
  }

  bool isActiveOn(DateTime day) =>
      activeWeekdays.contains(DateUtils.dateOnly(day).weekday);

  bool get isActiveToday => isActiveOn(DateTime.now());

  /// Most recent scheduled day strictly before [day].
  DateTime? previousActiveDayBefore(DateTime day) {
    var cursor = DateUtils.dateOnly(day).subtract(const Duration(days: 1));
    for (var i = 0; i < 7; i++) {
      if (activeWeekdays.contains(cursor.weekday)) return cursor;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return null;
  }

  /// Next scheduled day strictly after [day].
  DateTime? nextActiveDayAfter(DateTime day) {
    var cursor = DateUtils.dateOnly(day).add(const Duration(days: 1));
    for (var i = 0; i < 7; i++) {
      if (activeWeekdays.contains(cursor.weekday)) return cursor;
      cursor = cursor.add(const Duration(days: 1));
    }
    return null;
  }

  int calculateStreak({
    required int currentStreak,
    required DateTime? lastCheckInDate,
    required DateTime checkInDate,
  }) {
    final today = DateUtils.dateOnly(checkInDate);
    if (lastCheckInDate == null) return 1;
    if (DateUtils.isSameDay(lastCheckInDate, today)) return currentStreak;

    final previousActive = previousActiveDayBefore(today);
    if (previousActive != null &&
        DateUtils.isSameDay(lastCheckInDate, previousActive)) {
      return currentStreak + 1;
    }
    return 1;
  }

  static Set<int> defaultWeekdaysForCount(int count) {
    const ordered = [1, 2, 3, 4, 5, 6, 7];
    if (count >= 7) return ordered.toSet();
    if (count <= 0) return {1};

    final result = <int>{};
    final step = 7 / count;
    for (var i = 0; i < count; i++) {
      result.add(ordered[(i * step).round().clamp(0, 6)]);
    }
    for (final day in ordered) {
      if (result.length >= count) break;
      result.add(day);
    }
    return result;
  }

  List<int> get sortedActiveWeekdays =>
      activeWeekdays.toList()..sort();

  GoalSchedule copyWith({
    GoalScheduleType? type,
    int? timesPerWeek,
    Set<int>? activeWeekdays,
  }) {
    return GoalSchedule(
      type: type ?? this.type,
      timesPerWeek: timesPerWeek ?? this.timesPerWeek,
      activeWeekdays: activeWeekdays ?? this.activeWeekdays,
    );
  }

  @override
  List<Object?> get props => [type, timesPerWeek, activeWeekdays];
}
