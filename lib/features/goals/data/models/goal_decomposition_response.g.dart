// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_decomposition_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalDecompositionResponse _$GoalDecompositionResponseFromJson(
  Map<String, dynamic> json,
) => GoalDecompositionResponse(
  title: json['title'] as String,
  milestones: (json['milestones'] as List<dynamic>)
      .map((e) => DecompositionMilestone.fromJson(e as Map<String, dynamic>))
      .toList(),
  motivationalTips: json['motivationalTips'] as String,
  dailyHabit: json['dailyHabit'] as String? ?? '',
  potentialFrictionPoints:
      (json['potentialFrictionPoints'] as List<dynamic>?)
          ?.map((e) => FrictionPointModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  antiGoals:
      (json['antiGoals'] as List<dynamic>?)
          ?.map((e) => AntiGoalModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GoalDecompositionResponseToJson(
  GoalDecompositionResponse instance,
) => <String, dynamic>{
  'title': instance.title,
  'milestones': instance.milestones.map((e) => e.toJson()).toList(),
  'motivationalTips': instance.motivationalTips,
  'dailyHabit': instance.dailyHabit,
  'potentialFrictionPoints': instance.potentialFrictionPoints
      .map((e) => e.toJson())
      .toList(),
  'antiGoals': instance.antiGoals.map((e) => e.toJson()).toList(),
};

DecompositionMilestone _$DecompositionMilestoneFromJson(
  Map<String, dynamic> json,
) => DecompositionMilestone(
  title: json['title'] as String,
  order: (json['order'] as num).toInt(),
  description: json['description'] as String?,
  actionSteps:
      (json['actionSteps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  roleplayScenario: json['roleplayScenario'] == null
      ? null
      : RoleplayScenarioModel.fromJson(
          json['roleplayScenario'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$DecompositionMilestoneToJson(
  DecompositionMilestone instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': ?instance.description,
  'order': instance.order,
  'actionSteps': instance.actionSteps,
  'roleplayScenario': ?instance.roleplayScenario?.toJson(),
};
