// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_decomposition_response.dart';

GoalDecompositionResponse _$GoalDecompositionResponseFromJson(
  Map<String, dynamic> json,
) =>
    GoalDecompositionResponse(
      title: json['title'] as String,
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => DecompositionMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      motivationalTips: json['motivationalTips'] as String,
      dailyHabit: json['dailyHabit'] as String? ?? '',
    );

Map<String, dynamic> _$GoalDecompositionResponseToJson(
  GoalDecompositionResponse instance,
) =>
    <String, dynamic>{
      'title': instance.title,
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'motivationalTips': instance.motivationalTips,
      'dailyHabit': instance.dailyHabit,
    };

DecompositionMilestone _$DecompositionMilestoneFromJson(
  Map<String, dynamic> json,
) =>
    DecompositionMilestone(
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      description: json['description'] as String?,
      actionSteps: (json['actionSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DecompositionMilestoneToJson(
  DecompositionMilestone instance,
) =>
    <String, dynamic>{
      'title': instance.title,
      'order': instance.order,
      if (instance.description case final value?) 'description': value,
      'actionSteps': instance.actionSteps,
    };
