import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/data/models/anti_goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/friction_point_model.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
import 'package:goal_pilot/features/goals/data/models/roleplay_scenario_model.dart';

part 'goal_decomposition_response.g.dart';

class DecompositionActionStep {
  const DecompositionActionStep({
    required this.title,
    this.activeDayOrder,
  });

  final String title;
  final int? activeDayOrder;
}

@JsonSerializable()
class GoalDecompositionResponse {
  const GoalDecompositionResponse({
    required this.title,
    required this.milestones,
    required this.motivationalTips,
    this.dailyHabit = '',
    this.potentialFrictionPoints = const [],
    this.antiGoals = const [],
  });

  factory GoalDecompositionResponse.fromJson(Map<String, dynamic> json) {
    final rawFriction = json['potentialFrictionPoints'] as List<dynamic>? ??
        json['potential_friction_points'] as List<dynamic>? ??
        [];
    final rawAntiGoals = json['antiGoals'] as List<dynamic>? ??
        json['anti_goals'] as List<dynamic>? ??
        [];
    return GoalDecompositionResponse(
      title: json['title'] as String,
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => DecompositionMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      motivationalTips: json['motivationalTips'] as String,
      dailyHabit: json['dailyHabit'] as String? ?? '',
      potentialFrictionPoints: rawFriction
          .map((e) => FrictionPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      antiGoals: rawAntiGoals
          .map((e) => AntiGoalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String title;
  final List<DecompositionMilestone> milestones;
  final String motivationalTips;
  final String dailyHabit;
  final List<FrictionPointModel> potentialFrictionPoints;
  final List<AntiGoalModel> antiGoals;

  Map<String, dynamic> toJson() => _$GoalDecompositionResponseToJson(this);
}

class DecompositionMilestone {
  const DecompositionMilestone({
    required this.title,
    required this.order,
    this.description,
    this.actionSteps = const [],
    this.roleplayScenario,
  });

  factory DecompositionMilestone.fromJson(Map<String, dynamic> json) {
    final rawRoleplay = json['roleplayScenario'] ?? json['roleplay_scenario'];
    return DecompositionMilestone(
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      description: json['description'] as String?,
      actionSteps: _parseActionSteps(json['actionSteps']),
      roleplayScenario: rawRoleplay is Map<String, dynamic>
          ? RoleplayScenarioModel.fromJson(rawRoleplay)
          : null,
    );
  }

  final String title;
  final String? description;
  final int order;
  final List<DecompositionActionStep> actionSteps;
  final RoleplayScenarioModel? roleplayScenario;

  static List<DecompositionActionStep> _parseActionSteps(Object? value) {
    if (value is! List) return const [];
    return value.map((entry) {
      if (entry is String) {
        return DecompositionActionStep(title: entry);
      }
      if (entry is Map<String, dynamic>) {
        return DecompositionActionStep(
          title: entry['title'] as String? ?? '',
          activeDayOrder: (entry['activeDayOrder'] as num?)?.toInt(),
        );
      }
      return const DecompositionActionStep(title: '');
    }).where((step) => step.title.trim().isNotEmpty).toList();
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'order': order,
        'actionSteps': actionSteps
            .map(
              (step) => {
                'title': step.title,
                if (step.activeDayOrder != null)
                  'activeDayOrder': step.activeDayOrder,
              },
            )
            .toList(),
        if (roleplayScenario != null)
          'roleplayScenario': roleplayScenario!.toJson(),
      };

  MilestoneModel toMilestoneModel({required String id}) {
    return MilestoneModel(
      id: id,
      title: title,
      description: description,
      order: order,
      roleplayScenario: roleplayScenario?.isValid == true ? roleplayScenario : null,
    );
  }
}
