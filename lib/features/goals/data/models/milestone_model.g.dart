// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilestoneModel _$MilestoneModelFromJson(Map<String, dynamic> json) =>
    MilestoneModel(
      id: json['id'] as String,
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: MilestoneModel._dateTimeFromJson(json['completedAt']),
      roleplayScenario: json['roleplayScenario'] == null
          ? null
          : RoleplayScenarioModel.fromJson(
              json['roleplayScenario'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MilestoneModelToJson(MilestoneModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': ?instance.description,
      'order': instance.order,
      'isCompleted': instance.isCompleted,
      'completedAt': ?MilestoneModel._dateTimeToJson(instance.completedAt),
      'roleplayScenario': ?instance.roleplayScenario?.toJson(),
    };
