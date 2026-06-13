// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => GoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      motivationalTips: json['motivationalTips'] as String,
      createdAt: GoalModel._dateTimeFromJson(json['createdAt']),
      updatedAt: GoalModel._dateTimeFromJson(json['updatedAt']),
      status: GoalModel._statusFromJson(json['status']),
      tasks: json['tasks'] == null
          ? const []
          : (json['tasks'] as List<dynamic>)
              .map((e) => ActionTaskModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      dailyHabit: json['dailyHabit'] as String? ?? '',
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      lastCheckInDate:
          GoalModel._dateTimeFromJsonNullable(json['lastCheckInDate']),
    );

Map<String, dynamic> _$GoalModelToJson(GoalModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'motivationalTips': instance.motivationalTips,
      'createdAt': GoalModel._dateTimeToJson(instance.createdAt),
      'updatedAt': GoalModel._dateTimeToJson(instance.updatedAt),
      'status': GoalModel._statusToJson(instance.status),
      'tasks': instance.tasks.map((e) => e.toJson()).toList(),
      'dailyHabit': instance.dailyHabit,
      'streak': instance.streak,
      if (GoalModel._dateTimeToJsonNullable(instance.lastCheckInDate)
          case final value?)
        'lastCheckInDate': value,
    };
