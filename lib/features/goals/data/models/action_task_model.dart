import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';

part 'action_task_model.g.dart';

@JsonSerializable()
class ActionTaskModel {
  const ActionTaskModel({
    required this.id,
    required this.milestoneId,
    required this.title,
    this.type = TaskType.daily,
    this.completedOn,
  });

  factory ActionTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ActionTaskModelFromJson(json);

  final String id;
  final String milestoneId;
  final String title;

  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  final TaskType type;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? completedOn;

  Map<String, dynamic> toJson() => _$ActionTaskModelToJson(this);

  factory ActionTaskModel.fromEntity(ActionTask entity) {
    return ActionTaskModel(
      id: entity.id,
      milestoneId: entity.milestoneId,
      title: entity.title,
      type: entity.type,
      completedOn: entity.completedOn,
    );
  }

  ActionTask toEntity() {
    return ActionTask(
      id: id,
      milestoneId: milestoneId,
      title: title,
      type: type,
      completedOn: completedOn,
    );
  }

  ActionTaskModel copyWith({
    String? id,
    String? milestoneId,
    String? title,
    TaskType? type,
    DateTime? completedOn,
    bool clearCompletedOn = false,
  }) {
    return ActionTaskModel(
      id: id ?? this.id,
      milestoneId: milestoneId ?? this.milestoneId,
      title: title ?? this.title,
      type: type ?? this.type,
      completedOn: clearCompletedOn ? null : (completedOn ?? this.completedOn),
    );
  }

  static TaskType _typeFromJson(Object? value) {
    if (value == null) return TaskType.daily;
    if (value is String) {
      return TaskType.values.firstWhere(
        (type) => type.name == value,
        orElse: () => TaskType.daily,
      );
    }
    return TaskType.daily;
  }

  static String _typeToJson(TaskType type) => type.name;

  static DateTime? _dateTimeFromJson(Object? value) {
    if (value == null) return null;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}
