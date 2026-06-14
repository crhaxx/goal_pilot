// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => GoalModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  milestones: (json['milestones'] as List<dynamic>)
      .map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  motivationalTips: json['motivationalTips'] as String,
  createdAt: GoalModel._dateTimeFromJson(json['createdAt'] as Object),
  updatedAt: GoalModel._dateTimeFromJson(json['updatedAt'] as Object),
  status: json['status'] == null
      ? GoalStatus.active
      : GoalModel._statusFromJson(json['status']),
  priority: json['priority'] == null
      ? GoalPriority.medium
      : GoalModel._priorityFromJson(json['priority']),
  tasks:
      (json['tasks'] as List<dynamic>?)
          ?.map((e) => ActionTaskModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  dailyHabit: json['dailyHabit'] as String? ?? '',
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  lastCheckInDate: GoalModel._dateTimeFromJsonNullable(json['lastCheckInDate']),
  frictionPoints: json['frictionPoints'] == null
      ? const []
      : GoalModel._frictionFromJson(json['frictionPoints']),
  antiGoals:
      (json['antiGoals'] as List<dynamic>?)
          ?.map((e) => AntiGoalModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crisisModeActive: json['crisisModeActive'] as bool? ?? false,
  crisisStartedAt: GoalModel._dateTimeFromJsonNullable(json['crisisStartedAt']),
  crisisTasks:
      (json['crisisTasks'] as List<dynamic>?)
          ?.map((e) => ActionTaskModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crisisMessage: json['crisisMessage'] as String?,
  realityCheckReport: json['realityCheckReport'] == null
      ? null
      : RealityCheckReportModel.fromJson(
          json['realityCheckReport'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GoalModelToJson(GoalModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'milestones': instance.milestones.map((e) => e.toJson()).toList(),
  'motivationalTips': instance.motivationalTips,
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
  'dailyHabit': instance.dailyHabit,
  'streak': instance.streak,
  'createdAt': GoalModel._dateTimeToJson(instance.createdAt),
  'updatedAt': GoalModel._dateTimeToJson(instance.updatedAt),
  'lastCheckInDate': ?GoalModel._dateTimeToJsonNullable(
    instance.lastCheckInDate,
  ),
  'status': GoalModel._statusToJson(instance.status),
  'priority': GoalModel._priorityToJson(instance.priority),
  'frictionPoints': GoalModel._frictionToJson(instance.frictionPoints),
  'antiGoals': instance.antiGoals.map((e) => e.toJson()).toList(),
  'crisisModeActive': instance.crisisModeActive,
  'crisisStartedAt': ?GoalModel._dateTimeToJsonNullable(
    instance.crisisStartedAt,
  ),
  'crisisTasks': instance.crisisTasks.map((e) => e.toJson()).toList(),
  'crisisMessage': ?instance.crisisMessage,
  'realityCheckReport': ?instance.realityCheckReport?.toJson(),
};
