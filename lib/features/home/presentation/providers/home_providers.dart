import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

class HomeStats extends Equatable {
  const HomeStats({
    required this.activeGoals,
    required this.pendingCheckIns,
    required this.bestStreak,
    required this.checkInsThisWeek,
    required this.averageProgress,
  });

  final int activeGoals;
  final int pendingCheckIns;
  final int bestStreak;
  final int checkInsThisWeek;
  final int averageProgress;

  @override
  List<Object?> get props => [
        activeGoals,
        pendingCheckIns,
        bestStreak,
        checkInsThisWeek,
        averageProgress,
      ];
}

String homeGreeting(AppLocalizations l10n) {
  final hour = DateTime.now().hour;
  if (hour < 12) return l10n.greetingMorning;
  if (hour < 17) return l10n.greetingAfternoon;
  return l10n.greetingEvening;
}

final homeStatsProvider = FutureProvider<HomeStats>((ref) async {
  final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
  final activeGoals = goals
      .where((goal) => goal.status.isActive && !goal.isFullyComplete)
      .length;
  final pendingCheckIns = goals
      .where((goal) => goal.needsCheckInToday && goal.status.isActive)
      .length;
  final bestStreak = goals.isEmpty
      ? 0
      : goals.map((goal) => goal.streak).reduce((a, b) => a > b ? a : b);
  final averageProgress = goals.isEmpty
      ? 0
      : (goals.map((goal) => goal.progressPercent).reduce((a, b) => a + b) /
              goals.length)
          .round();

  final checkInsDs = await ref.watch(checkInLocalDataSourceProvider.future);
  final since = DateTime.now().subtract(const Duration(days: 7));
  final checkIns = await checkInsDs.getAllCheckInsSince(since);

  return HomeStats(
    activeGoals: activeGoals,
    pendingCheckIns: pendingCheckIns,
    bestStreak: bestStreak,
    checkInsThisWeek: checkIns.length,
    averageProgress: averageProgress,
  );
});
