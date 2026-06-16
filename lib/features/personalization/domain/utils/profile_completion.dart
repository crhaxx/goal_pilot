import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';

abstract final class ProfileCompletion {
  static const _fieldCount = 8;

  static int percent(UserPersonalization profile) {
    return ((filledCount(profile) / _fieldCount) * 100).round().clamp(0, 100);
  }

  static int filledCount(UserPersonalization profile) {
    var filled = 0;
    if (profile.hasDisplayName) filled++;
    if (profile.scheduleRhythm != null) filled++;
    if (profile.coachingStyle != null) filled++;
    if (profile.occupationStatus != null) filled++;
    if (profile.milestoneGranularity != null) filled++;
    if (profile.motivationDriver != null) filled++;
    if (profile.challengeAreas.isNotEmpty) filled++;
    if (profile.hasBio) filled++;
    return filled;
  }
}
