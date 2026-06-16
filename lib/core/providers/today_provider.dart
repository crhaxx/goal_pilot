import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';

/// Current calendar day (local midnight boundary).
///
/// Updates automatically at 00:00 so check-in state, tasks, and slogans roll
/// over without restarting the app.
final todayProvider = StateNotifierProvider<TodayNotifier, DateTime>((ref) {
  return TodayNotifier();
});

class TodayNotifier extends StateNotifier<DateTime> {
  TodayNotifier() : super(DateUtils.dateOnly(DateTime.now())) {
    _scheduleNextMidnight();
  }

  Timer? _timer;

  void _scheduleNextMidnight() {
    _timer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateUtils.dateOnly(now).add(const Duration(days: 1));
    _timer = Timer(nextMidnight.difference(now), _advanceToNewDay);
  }

  void _advanceToNewDay() {
    state = DateUtils.dateOnly(DateTime.now());
    _scheduleNextMidnight();
  }

  /// Call when the app returns to foreground in case midnight passed while away.
  void syncWithClock() {
    final today = DateUtils.dateOnly(DateTime.now());
    if (!DateUtils.isSameDay(state, today)) {
      state = today;
      _scheduleNextMidnight();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
