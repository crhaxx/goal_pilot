import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/utils/crisis_detector.dart';

enum PilotMood { cruising, steady, turbulence, emergency }

class PilotStatus {
  const PilotStatus({
    required this.mood,
    required this.headline,
    required this.subtitle,
    required this.iconName,
  });

  final PilotMood mood;
  final String headline;
  final String subtitle;
  final String iconName;

  bool get isAlert =>
      mood == PilotMood.turbulence || mood == PilotMood.emergency;

  static PilotStatus forGoal(Goal goal, AppLocalizations l10n) {
    if (goal.crisisModeActive) {
      return PilotStatus(
        mood: PilotMood.emergency,
        headline: l10n.pilotEmergencyHeadline,
        subtitle: l10n.pilotEmergencySubtitle(goal.title),
        iconName: 'warning',
      );
    }

    if (goal.isFullyComplete) {
      return PilotStatus(
        mood: PilotMood.cruising,
        headline: l10n.pilotMissionCompleteHeadline,
        subtitle: l10n.pilotMissionCompleteSubtitle(goal.title),
        iconName: 'celebration',
      );
    }

    if (goal.hasCheckedInToday && goal.streak >= 3) {
      return PilotStatus(
        mood: PilotMood.cruising,
        headline: l10n.pilotClearSkiesHeadline,
        subtitle: l10n.pilotClearSkiesSubtitle(goal.streak, goal.title),
        iconName: 'flight',
      );
    }

    if (goal.needsCheckInToday) {
      return PilotStatus(
        mood: PilotMood.turbulence,
        headline: l10n.pilotTurbulenceHeadline,
        subtitle: l10n.pilotTurbulenceSubtitle(goal.title),
        iconName: 'radar',
      );
    }

    return PilotStatus(
      mood: PilotMood.steady,
      headline: l10n.pilotSteadyHeadline,
      subtitle: l10n.pilotSteadySubtitle(goal.title),
      iconName: 'compass',
    );
  }

  static PilotStatus aggregate(List<Goal> goals, AppLocalizations l10n) {
    if (goals.isEmpty) {
      return PilotStatus(
        mood: PilotMood.steady,
        headline: l10n.pilotReadyHeadline,
        subtitle: l10n.pilotReadySubtitle,
        iconName: 'rocket',
      );
    }

    final active = goals.where((g) => g.status.isActive).toList();
    final inCrisis = active.where((g) => g.crisisModeActive).length;
    final needsCrisis = active.where(CrisisDetector.shouldSuggestCrisis).length;
    final pending = active.where((g) => g.needsCheckInToday).length;
    final bestStreak = active.fold(0, (max, g) => g.streak > max ? g.streak : max);

    if (inCrisis > 0) {
      return PilotStatus(
        mood: PilotMood.emergency,
        headline: l10n.pilotEmergencyBoardHeadline,
        subtitle: l10n.pilotEmergencyBoardSubtitle(inCrisis),
        iconName: 'warning',
      );
    }

    if (needsCrisis > 0) {
      return PilotStatus(
        mood: PilotMood.emergency,
        headline: l10n.pilotTurbulenceReportHeadline,
        subtitle: l10n.pilotTurbulenceReportSubtitle(needsCrisis),
        iconName: 'warning',
      );
    }

    if (pending >= 2) {
      return PilotStatus(
        mood: PilotMood.turbulence,
        headline: l10n.pilotTurbulenceBoardHeadline,
        subtitle: l10n.pilotTurbulenceBoardSubtitle(pending),
        iconName: 'warning',
      );
    }

    if (bestStreak >= 5 && pending == 0) {
      return PilotStatus(
        mood: PilotMood.cruising,
        headline: l10n.pilotAllCheckInsHeadline,
        subtitle: l10n.pilotAllCheckInsSubtitle,
        iconName: 'flight',
      );
    }

    if (pending == 1) {
      return PilotStatus(
        mood: PilotMood.turbulence,
        headline: l10n.pilotOneCheckInHeadline,
        subtitle: l10n.pilotOneCheckInSubtitle,
        iconName: 'radar',
      );
    }

    return PilotStatus(
      mood: PilotMood.steady,
      headline: l10n.pilotSteadyHeadline,
      subtitle: l10n.pilotActiveGoalsSubtitle(active.length),
      iconName: 'compass',
    );
  }
}
