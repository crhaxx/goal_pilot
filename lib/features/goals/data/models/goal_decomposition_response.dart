import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';

part 'goal_decomposition_response.g.dart';

@JsonSerializable()
class GoalDecompositionResponse {
  const GoalDecompositionResponse({
    required this.title,
    required this.milestones,
    required this.motivationalTips,
    this.dailyHabit = '',
  });

  factory GoalDecompositionResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalDecompositionResponseFromJson(json);

  final String title;
  final List<DecompositionMilestone> milestones;
  final String motivationalTips;
  final String dailyHabit;

  Map<String, dynamic> toJson() => _$GoalDecompositionResponseToJson(this);
}

@JsonSerializable()
class DecompositionMilestone {
  const DecompositionMilestone({
    required this.title,
    required this.order,
    this.description,
    this.actionSteps = const [],
  });

  factory DecompositionMilestone.fromJson(Map<String, dynamic> json) =>
      _$DecompositionMilestoneFromJson(json);

  final String title;
  final String? description;
  final int order;
  final List<String> actionSteps;

  Map<String, dynamic> toJson() => _$DecompositionMilestoneToJson(this);

  MilestoneModel toMilestoneModel({required String id}) {
    return MilestoneModel(
      id: id,
      title: title,
      description: description,
      order: order,
    );
  }
}
