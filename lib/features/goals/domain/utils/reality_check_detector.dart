import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';

/// Unlocks AI Shadowing / Reality Check after sufficient usage data.
abstract final class RealityCheckDetector {
  static const minDays = 14;
  static const minCheckIns = 7;

  static bool isUnlocked(Goal goal, List<DailyCheckIn> checkIns) {
    if (goal.isFullyComplete) return false;
    final hasEnoughDays = goal.daysSinceCreation >= minDays;
    final hasEnoughCheckIns = checkIns.length >= minCheckIns;
    return hasEnoughDays || hasEnoughCheckIns;
  }

  static bool needsRefresh(Goal goal) {
    final report = goal.realityCheckReport;
    if (report == null) return true;
    return DateTime.now().difference(report.generatedAt).inDays >= 7;
  }
}
