import 'package:equatable/equatable.dart';
import 'package:goal_pilot/features/personalization/domain/entities/challenge_area.dart';
import 'package:goal_pilot/features/personalization/domain/entities/coaching_focus_style.dart';
import 'package:goal_pilot/features/personalization/domain/entities/daily_schedule_rhythm.dart';
import 'package:goal_pilot/features/personalization/domain/entities/milestone_granularity.dart';
import 'package:goal_pilot/features/personalization/domain/entities/motivation_driver.dart';
import 'package:goal_pilot/features/personalization/domain/entities/occupation_status.dart';

class UserPersonalization extends Equatable {
  const UserPersonalization({
    this.enabled = false,
    this.displayName,
    this.scheduleRhythm,
    this.coachingStyle,
    this.occupationStatus,
    this.milestoneGranularity,
    this.motivationDriver,
    this.challengeAreas = const {},
    this.userBio,
  });

  final bool enabled;
  final String? displayName;
  final DailyScheduleRhythm? scheduleRhythm;
  final CoachingFocusStyle? coachingStyle;
  final OccupationStatus? occupationStatus;
  final MilestoneGranularity? milestoneGranularity;
  final MotivationDriver? motivationDriver;
  final Set<ChallengeArea> challengeAreas;
  final String? userBio;

  bool get hasDisplayName =>
      displayName != null && displayName!.trim().isNotEmpty;

  bool get hasStructuredData =>
      hasDisplayName ||
      scheduleRhythm != null ||
      coachingStyle != null ||
      occupationStatus != null ||
      milestoneGranularity != null ||
      motivationDriver != null ||
      challengeAreas.isNotEmpty;

  bool get hasBio => userBio != null && userBio!.trim().isNotEmpty;

  bool get hasContent => hasStructuredData || hasBio;

  bool get shouldInject => enabled && hasContent;

  UserPersonalization copyWith({
    bool? enabled,
    String? displayName,
    DailyScheduleRhythm? scheduleRhythm,
    CoachingFocusStyle? coachingStyle,
    OccupationStatus? occupationStatus,
    MilestoneGranularity? milestoneGranularity,
    MotivationDriver? motivationDriver,
    Set<ChallengeArea>? challengeAreas,
    String? userBio,
    bool clearDisplayName = false,
    bool clearScheduleRhythm = false,
    bool clearCoachingStyle = false,
    bool clearOccupationStatus = false,
    bool clearMilestoneGranularity = false,
    bool clearMotivationDriver = false,
    bool clearChallengeAreas = false,
    bool clearUserBio = false,
  }) {
    return UserPersonalization(
      enabled: enabled ?? this.enabled,
      displayName:
          clearDisplayName ? null : (displayName ?? this.displayName),
      scheduleRhythm:
          clearScheduleRhythm ? null : (scheduleRhythm ?? this.scheduleRhythm),
      coachingStyle:
          clearCoachingStyle ? null : (coachingStyle ?? this.coachingStyle),
      occupationStatus: clearOccupationStatus
          ? null
          : (occupationStatus ?? this.occupationStatus),
      milestoneGranularity: clearMilestoneGranularity
          ? null
          : (milestoneGranularity ?? this.milestoneGranularity),
      motivationDriver: clearMotivationDriver
          ? null
          : (motivationDriver ?? this.motivationDriver),
      challengeAreas: clearChallengeAreas
          ? const {}
          : (challengeAreas ?? this.challengeAreas),
      userBio: clearUserBio ? null : (userBio ?? this.userBio),
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        if (hasDisplayName) 'displayName': displayName!.trim(),
        if (scheduleRhythm != null) 'scheduleRhythm': scheduleRhythm!.name,
        if (coachingStyle != null) 'coachingStyle': coachingStyle!.name,
        if (occupationStatus != null)
          'occupationStatus': occupationStatus!.name,
        if (milestoneGranularity != null)
          'milestoneGranularity': milestoneGranularity!.name,
        if (motivationDriver != null)
          'motivationDriver': motivationDriver!.name,
        if (challengeAreas.isNotEmpty)
          'challengeAreas':
              challengeAreas.map((area) => area.name).toList(growable: false),
        if (userBio != null && userBio!.trim().isNotEmpty)
          'userBio': userBio!.trim(),
      };

  factory UserPersonalization.fromJson(Map<String, dynamic> json) {
    final challengeRaw = json['challengeAreas'];
    final challengeAreas = <ChallengeArea>{};
    if (challengeRaw is List) {
      for (final item in challengeRaw) {
        final parsed = _parseEnum(item as String?, ChallengeArea.values);
        if (parsed != null) challengeAreas.add(parsed);
      }
    }

    return UserPersonalization(
      enabled: json['enabled'] as bool? ?? false,
      displayName: json['displayName'] as String?,
      scheduleRhythm: _parseEnum(
        json['scheduleRhythm'] as String?,
        DailyScheduleRhythm.values,
      ),
      coachingStyle: _parseEnum(
        json['coachingStyle'] as String?,
        CoachingFocusStyle.values,
      ),
      occupationStatus: _parseEnum(
        json['occupationStatus'] as String?,
        OccupationStatus.values,
      ),
      milestoneGranularity: _parseEnum(
        json['milestoneGranularity'] as String?,
        MilestoneGranularity.values,
      ),
      motivationDriver: _parseEnum(
        json['motivationDriver'] as String?,
        MotivationDriver.values,
      ),
      challengeAreas: challengeAreas,
      userBio: json['userBio'] as String?,
    );
  }

  static T? _parseEnum<T extends Enum>(String? name, List<T> values) {
    if (name == null || name.isEmpty) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        enabled,
        displayName,
        scheduleRhythm,
        coachingStyle,
        occupationStatus,
        milestoneGranularity,
        motivationDriver,
        challengeAreas,
        userBio,
      ];
}
