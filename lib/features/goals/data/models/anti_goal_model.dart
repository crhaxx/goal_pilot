import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/domain/entities/anti_goal.dart';

class AntiGoalModel {
  const AntiGoalModel({
    required this.title,
    required this.trigger,
    required this.consequence,
  });

  factory AntiGoalModel.fromJson(Map<String, dynamic> json) {
    return AntiGoalModel(
      title: json['title'] as String,
      trigger: json['trigger'] as String? ?? '',
      consequence: json['consequence'] as String? ?? '',
    );
  }

  final String title;
  final String trigger;
  final String consequence;

  Map<String, dynamic> toJson() => {
        'title': title,
        'trigger': trigger,
        'consequence': consequence,
      };

  factory AntiGoalModel.fromEntity(AntiGoal entity) {
    return AntiGoalModel(
      title: entity.title,
      trigger: entity.trigger,
      consequence: entity.consequence,
    );
  }

  AntiGoal toEntity() {
    return AntiGoal(
      title: title,
      trigger: trigger,
      consequence: consequence,
    );
  }
}
