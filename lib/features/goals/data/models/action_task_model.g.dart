// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionTaskModel _$ActionTaskModelFromJson(Map<String, dynamic> json) =>
    ActionTaskModel(
      id: json['id'] as String,
      milestoneId: json['milestoneId'] as String,
      title: json['title'] as String,
      type: json['type'] == null
          ? TaskType.daily
          : ActionTaskModel._typeFromJson(json['type']),
      completedOn: ActionTaskModel._dateTimeFromJson(json['completedOn']),
      isUserCreated: json['isUserCreated'] as bool? ?? false,
    );

Map<String, dynamic> _$ActionTaskModelToJson(ActionTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'milestoneId': instance.milestoneId,
      'title': instance.title,
      'type': ActionTaskModel._typeToJson(instance.type),
      'completedOn': ActionTaskModel._dateTimeToJson(instance.completedOn),
      'isUserCreated': instance.isUserCreated,
    };
