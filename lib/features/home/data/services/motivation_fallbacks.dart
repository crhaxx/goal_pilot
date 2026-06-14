import 'package:goal_pilot/features/home/domain/entities/motivation_snapshot.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

abstract final class MotivationFallbacks {
  static String contextualSlogan(
    MotivationSnapshot snapshot,
    AppLocalizations l10n,
  ) {
    final focusTitle = snapshot.focusGoal?.title;

    return switch (snapshot.scenario) {
      MotivationScenario.streakMilestone => l10n.motivationFallbackStreak(
          snapshot.bestStreak,
        ),
      MotivationScenario.missedCheckIn => l10n.motivationFallbackMissedCheckIn,
      MotivationScenario.lowMood => l10n.motivationFallbackLowMood,
      MotivationScenario.pendingCheckIns => l10n.motivationFallbackPending(
          snapshot.pendingCheckIns,
        ),
      MotivationScenario.allDone => l10n.motivationFallbackAllDone,
      MotivationScenario.steady => focusTitle == null
          ? l10n.motivationFallbackDefault
          : l10n.motivationFallbackSteady(focusTitle),
    };
  }

  static String dailyFuel(MotivationSnapshot snapshot, AppLocalizations l10n) {
    final goal = snapshot.focusGoal;
    if (goal == null) return l10n.motivationFallbackDailyFuelDefault;

    final milestone = goal.currentMilestone?.title ?? goal.title;
    final dayCount = goal.streak > 0 ? goal.streak : goal.daysSinceCreation + 1;

    return l10n.motivationFallbackDailyFuel(
      goal.title,
      dayCount,
      milestone,
    );
  }
}
