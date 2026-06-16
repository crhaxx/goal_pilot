import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';

/// Builds the injectable personalization block for Gemini prompts.
abstract final class PersonalizationPromptBuilder {
  static String? build(UserPersonalization personalization) {
    if (!personalization.shouldInject) return null;

    final lines = <String>[
      'The user has voluntarily shared the following lifestyle and coaching preferences.',
      'Adapt your tone, milestone granularity, and motivation style accordingly.',
      'Do NOT alter the required JSON output schema or response format.',
    ];

    if (personalization.hasDisplayName) {
      lines.add(
        'Preferred name: ${personalization.displayName!.trim()}',
      );
    }
    if (personalization.scheduleRhythm != null) {
      lines.add(
        'Daily schedule rhythm: ${personalization.scheduleRhythm!.promptLabel}',
      );
    }
    if (personalization.coachingStyle != null) {
      lines.add(
        'Preferred coaching style: ${personalization.coachingStyle!.promptLabel}',
      );
    }
    if (personalization.occupationStatus != null) {
      lines.add(
        'Current occupation: ${personalization.occupationStatus!.promptLabel}',
      );
    }
    if (personalization.milestoneGranularity != null) {
      lines.add(
        'Milestone sizing preference: ${personalization.milestoneGranularity!.promptLabel}',
      );
    }
    if (personalization.motivationDriver != null) {
      lines.add(
        'What motivates them best: ${personalization.motivationDriver!.promptLabel}',
      );
    }
    if (personalization.challengeAreas.isNotEmpty) {
      final areas = personalization.challengeAreas
          .map((area) => area.promptLabel)
          .join(', ');
      lines.add('Known challenge areas: $areas');
    }
    if (personalization.hasBio) {
      lines.add('User bio: ${personalization.userBio!.trim()}');
    }

    return '[USER CONTEXT]\n${lines.join('\n')}\n[/USER CONTEXT]';
  }
}
