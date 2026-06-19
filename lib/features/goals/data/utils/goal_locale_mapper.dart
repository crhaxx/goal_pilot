import 'package:goal_pilot/features/gamification/data/models/win_brick_model.dart';
import 'package:goal_pilot/features/goals/data/models/anti_goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/friction_point_model.dart';
import 'package:goal_pilot/features/goals/data/models/goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
import 'package:goal_pilot/features/goals/data/models/reality_check_report_model.dart';
import 'package:goal_pilot/features/goals/data/models/roleplay_scenario_model.dart';

abstract final class GoalLocaleMapper {
  static Map<String, dynamic> toTranslationPayload(
    GoalModel goal,
    List<WinBrickModel> winBricks,
  ) {
    return {
      'title': goal.title,
      'motivationalTips': goal.motivationalTips,
      'dailyHabit': goal.dailyHabit,
      'milestones': goal.milestones.map(_milestonePayload).toList(),
      'tasks': goal.tasks
          .where((task) => !task.isUserCreated)
          .map((task) => {'id': task.id, 'title': task.title})
          .toList(),
      'frictionPoints': goal.frictionPoints.map((point) => point.toJson()).toList(),
      'antiGoals': goal.antiGoals.map((anti) => anti.toJson()).toList(),
      if (goal.crisisMessage != null && goal.crisisMessage!.trim().isNotEmpty)
        'crisisMessage': goal.crisisMessage,
      'crisisTasks': goal.crisisTasks
          .map((task) => {'id': task.id, 'title': task.title})
          .toList(),
      if (goal.realityCheckReport != null)
        'realityCheckReport': {
          'insight': goal.realityCheckReport!.insight,
          'recommendations': goal.realityCheckReport!.recommendations,
        },
      'winBricks': winBricks
          .map((brick) => {'id': brick.id, 'label': brick.label})
          .toList(),
    };
  }

  static GoalModel applyTranslation(
    GoalModel goal,
    Map<String, dynamic> translated,
    String targetLocaleCode,
  ) {
    final translatedMilestones = translated['milestones'];
    final milestones = goal.milestones.map((milestone) {
      if (translatedMilestones is! List) return milestone;
      final match = _findById(translatedMilestones, milestone.id);
      if (match == null) return milestone;
      return milestone.copyWith(
        title: match['title'] as String? ?? milestone.title,
        description: match.containsKey('description')
            ? match['description'] as String?
            : milestone.description,
        roleplayScenario: _roleplayFromJson(
          match['roleplayScenario'],
          fallback: milestone.roleplayScenario,
        ),
      );
    }).toList();

    final translatedTasks = translated['tasks'];
    final tasks = goal.tasks.map((task) {
      if (task.isUserCreated || translatedTasks is! List) return task;
      final match = _findById(translatedTasks, task.id);
      if (match == null) return task;
      return task.copyWith(title: match['title'] as String? ?? task.title);
    }).toList();

    final translatedFriction = translated['frictionPoints'];
    final frictionPoints = goal.frictionPoints.asMap().entries.map((entry) {
      final point = entry.value;
      if (translatedFriction is! List) return point;
      final match = entry.key < translatedFriction.length
          ? translatedFriction[entry.key] as Map<String, dynamic>?
          : null;
      if (match == null) return point;
      return FrictionPointModel(
        milestoneOrder: point.milestoneOrder,
        title: match['title'] as String? ?? point.title,
        warning: match['warning'] as String? ?? point.warning,
        tip: match['tip'] as String? ?? point.tip,
      );
    }).toList();

    final translatedAntiGoals = translated['antiGoals'];
    final antiGoals = goal.antiGoals.asMap().entries.map((entry) {
      final anti = entry.value;
      if (translatedAntiGoals is! List) return anti;
      final match = entry.key < translatedAntiGoals.length
          ? translatedAntiGoals[entry.key] as Map<String, dynamic>?
          : null;
      if (match == null) return anti;
      return AntiGoalModel(
        title: match['title'] as String? ?? anti.title,
        trigger: match['trigger'] as String? ?? anti.trigger,
        consequence: match['consequence'] as String? ?? anti.consequence,
      );
    }).toList();

    final translatedCrisisTasks = translated['crisisTasks'];
    final crisisTasks = goal.crisisTasks.map((task) {
      if (translatedCrisisTasks is! List) return task;
      final match = _findById(translatedCrisisTasks, task.id);
      if (match == null) return task;
      return task.copyWith(title: match['title'] as String? ?? task.title);
    }).toList();

    RealityCheckReportModel? realityCheckReport = goal.realityCheckReport;
    final translatedReport = translated['realityCheckReport'];
    if (realityCheckReport != null && translatedReport is Map<String, dynamic>) {
      realityCheckReport = RealityCheckReportModel(
        insight: translatedReport['insight'] as String? ?? realityCheckReport.insight,
        recommendations: translatedReport['recommendations'] is List
            ? (translatedReport['recommendations'] as List)
                .map((item) => item as String)
                .toList()
            : realityCheckReport.recommendations,
        generatedAt: realityCheckReport.generatedAt,
      );
    }

    return goal.copyWith(
      title: translated['title'] as String? ?? goal.title,
      motivationalTips:
          translated['motivationalTips'] as String? ?? goal.motivationalTips,
      dailyHabit: translated['dailyHabit'] as String? ?? goal.dailyHabit,
      milestones: milestones,
      tasks: tasks,
      frictionPoints: frictionPoints,
      antiGoals: antiGoals,
      crisisMessage: translated.containsKey('crisisMessage')
          ? translated['crisisMessage'] as String?
          : goal.crisisMessage,
      crisisTasks: crisisTasks,
      realityCheckReport: realityCheckReport,
      contentLocaleCode: targetLocaleCode,
      updatedAt: DateTime.now(),
    );
  }

  static List<WinBrickModel> applyWinBrickTranslations(
    List<WinBrickModel> bricks,
    Map<String, dynamic> translated,
  ) {
    final translatedBricks = translated['winBricks'];
    if (translatedBricks is! List) return bricks;

    return bricks.map((brick) {
      final match = _findById(translatedBricks, brick.id);
      if (match == null) return brick;
      return WinBrickModel(
        id: brick.id,
        goalId: brick.goalId,
        label: match['label'] as String? ?? brick.label,
        createdAt: brick.createdAt,
        source: brick.source,
      );
    }).toList();
  }

  static Map<String, dynamic>? _findById(List<dynamic> items, String id) {
    for (final item in items) {
      if (item is Map<String, dynamic> && item['id'] == id) {
        return item;
      }
    }
    return null;
  }

  static Map<String, dynamic> _milestonePayload(MilestoneModel milestone) {
    return {
      'id': milestone.id,
      'title': milestone.title,
      if (milestone.description != null) 'description': milestone.description,
      if (milestone.roleplayScenario != null)
        'roleplayScenario': milestone.roleplayScenario!.toJson(),
    };
  }

  static RoleplayScenarioModel? _roleplayFromJson(
    Object? value, {
    required RoleplayScenarioModel? fallback,
  }) {
    if (value is! Map<String, dynamic>) return fallback;
    final parsed = RoleplayScenarioModel.fromJson(value);
    if (!parsed.isValid) return fallback;
    return parsed;
  }
}
