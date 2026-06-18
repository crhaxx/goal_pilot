import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';

class PersonalTaskModel {
  const PersonalTaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.createdAt,
    this.completedOn,
    this.reminderAt,
  });

  final String id;
  final String title;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime? completedOn;
  final DateTime? reminderAt;

  factory PersonalTaskModel.fromJson(Map<String, dynamic> json) {
    return PersonalTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedOn: json['completedOn'] == null
          ? null
          : DateTime.parse(json['completedOn'] as String),
      reminderAt: json['reminderAt'] == null
          ? null
          : DateTime.parse(json['reminderAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dueDate': dueDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        if (completedOn != null) 'completedOn': completedOn!.toIso8601String(),
        if (reminderAt != null) 'reminderAt': reminderAt!.toIso8601String(),
      };

  PersonalTask toEntity() => PersonalTask(
        id: id,
        title: title,
        dueDate: DateUtils.dateOnly(dueDate),
        createdAt: createdAt,
        completedOn: completedOn,
        reminderAt: reminderAt,
      );

  factory PersonalTaskModel.fromEntity(PersonalTask entity) {
    return PersonalTaskModel(
      id: entity.id,
      title: entity.title,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
      completedOn: entity.completedOn,
      reminderAt: entity.reminderAt,
    );
  }
}
