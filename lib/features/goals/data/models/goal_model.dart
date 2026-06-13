import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/data/models/action_task_model.dart';
import 'package:goal_pilot/features/goals/data/models/anti_goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/friction_point_model.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
import 'package:goal_pilot/features/goals/data/models/reality_check_report_model.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';

part 'goal_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GoalModel {
  const GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.milestones,
    required this.motivationalTips,
    required this.createdAt,
    required this.updatedAt,
    this.status = GoalStatus.active,
    this.tasks = const [],
    this.dailyHabit = '',
    this.streak = 0,
    this.lastCheckInDate,
    this.frictionPoints = const [],
    this.antiGoals = const [],
    this.crisisModeActive = false,
    this.crisisStartedAt,
    this.crisisTasks = const [],
    this.crisisMessage,
    this.realityCheckReport,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final base = _$GoalModelFromJson(json);
    return GoalModel(
      id: base.id,
      title: base.title,
      description: base.description,
      milestones: base.milestones,
      motivationalTips: base.motivationalTips,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      status: base.status,
      tasks: base.tasks,
      dailyHabit: base.dailyHabit,
      streak: base.streak,
      lastCheckInDate: base.lastCheckInDate,
      frictionPoints: _frictionFromJson(json['frictionPoints']),
      antiGoals: _antiGoalsFromJson(json['antiGoals']),
      crisisModeActive: json['crisisModeActive'] as bool? ?? false,
      crisisStartedAt: _dateTimeFromJsonNullable(json['crisisStartedAt']),
      crisisTasks: json['crisisTasks'] == null
          ? const []
          : (json['crisisTasks'] as List<dynamic>)
              .map((e) => ActionTaskModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      crisisMessage: json['crisisMessage'] as String?,
      realityCheckReport: _realityCheckFromJson(json['realityCheckReport']),
    );
  }

  final String id;
  final String title;
  final String description;
  final List<MilestoneModel> milestones;
  final String motivationalTips;
  final List<ActionTaskModel> tasks;
  final String dailyHabit;
  final int streak;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? lastCheckInDate;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final GoalStatus status;

  @JsonKey(fromJson: _frictionFromJson, toJson: _frictionToJson)
  final List<FrictionPointModel> frictionPoints;

  final List<AntiGoalModel> antiGoals;
  final bool crisisModeActive;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? crisisStartedAt;

  final List<ActionTaskModel> crisisTasks;
  final String? crisisMessage;
  final RealityCheckReportModel? realityCheckReport;

  Map<String, dynamic> toJson() {
    final json = _$GoalModelToJson(this);
    json['frictionPoints'] = _frictionToJson(frictionPoints);
    json['antiGoals'] = antiGoals.map((a) => a.toJson()).toList();
    json['crisisModeActive'] = crisisModeActive;
    if (crisisStartedAt != null) {
      json['crisisStartedAt'] = _dateTimeToJsonNullable(crisisStartedAt);
    }
    json['crisisTasks'] = crisisTasks.map((t) => t.toJson()).toList();
    if (crisisMessage != null) json['crisisMessage'] = crisisMessage;
    if (realityCheckReport != null) {
      json['realityCheckReport'] = realityCheckReport!.toJson();
    }
    return json;
  }

  factory GoalModel.fromEntity(Goal entity) {
    return GoalModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      milestones: entity.milestones
          .map(MilestoneModel.fromEntity)
          .toList(growable: false),
      motivationalTips: entity.motivationalTips,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      status: entity.status,
      tasks: entity.tasks.map(ActionTaskModel.fromEntity).toList(growable: false),
      dailyHabit: entity.dailyHabit,
      streak: entity.streak,
      lastCheckInDate: entity.lastCheckInDate,
      frictionPoints: entity.frictionPoints
          .map(FrictionPointModel.fromEntity)
          .toList(growable: false),
      antiGoals: entity.antiGoals
          .map(AntiGoalModel.fromEntity)
          .toList(growable: false),
      crisisModeActive: entity.crisisModeActive,
      crisisStartedAt: entity.crisisStartedAt,
      crisisTasks: entity.crisisTasks
          .map(ActionTaskModel.fromEntity)
          .toList(growable: false),
      crisisMessage: entity.crisisMessage,
      realityCheckReport: entity.realityCheckReport == null
          ? null
          : RealityCheckReportModel.fromEntity(entity.realityCheckReport!),
    );
  }

  Goal toEntity() {
    return Goal(
      id: id,
      title: title,
      description: description,
      milestones: milestones.map((m) => m.toEntity()).toList(growable: false),
      motivationalTips: motivationalTips,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      tasks: tasks.map((t) => t.toEntity()).toList(growable: false),
      dailyHabit: dailyHabit,
      streak: streak,
      lastCheckInDate: lastCheckInDate,
      frictionPoints: frictionPoints.map((p) => p.toEntity()).toList(growable: false),
      antiGoals: antiGoals.map((a) => a.toEntity()).toList(growable: false),
      crisisModeActive: crisisModeActive,
      crisisStartedAt: crisisStartedAt,
      crisisTasks: crisisTasks.map((t) => t.toEntity()).toList(growable: false),
      crisisMessage: crisisMessage,
      realityCheckReport: realityCheckReport?.toEntity(),
    );
  }

  GoalModel copyWith({
    String? id,
    String? title,
    String? description,
    List<MilestoneModel>? milestones,
    String? motivationalTips,
    DateTime? createdAt,
    DateTime? updatedAt,
    GoalStatus? status,
    List<ActionTaskModel>? tasks,
    String? dailyHabit,
    int? streak,
    DateTime? lastCheckInDate,
    List<FrictionPointModel>? frictionPoints,
    List<AntiGoalModel>? antiGoals,
    bool? crisisModeActive,
    DateTime? crisisStartedAt,
    List<ActionTaskModel>? crisisTasks,
    String? crisisMessage,
    RealityCheckReportModel? realityCheckReport,
    bool clearLastCheckInDate = false,
    bool clearCrisisStartedAt = false,
    bool clearCrisisMessage = false,
    bool clearRealityCheckReport = false,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      milestones: milestones ?? this.milestones,
      motivationalTips: motivationalTips ?? this.motivationalTips,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      dailyHabit: dailyHabit ?? this.dailyHabit,
      streak: streak ?? this.streak,
      lastCheckInDate:
          clearLastCheckInDate ? null : (lastCheckInDate ?? this.lastCheckInDate),
      frictionPoints: frictionPoints ?? this.frictionPoints,
      antiGoals: antiGoals ?? this.antiGoals,
      crisisModeActive: crisisModeActive ?? this.crisisModeActive,
      crisisStartedAt: clearCrisisStartedAt
          ? null
          : (crisisStartedAt ?? this.crisisStartedAt),
      crisisTasks: crisisTasks ?? this.crisisTasks,
      crisisMessage:
          clearCrisisMessage ? null : (crisisMessage ?? this.crisisMessage),
      realityCheckReport: clearRealityCheckReport
          ? null
          : (realityCheckReport ?? this.realityCheckReport),
    );
  }

  static DateTime _dateTimeFromJson(Object value) {
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw FormatException('Invalid DateTime value: $value');
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();

  static DateTime? _dateTimeFromJsonNullable(Object? value) {
    if (value == null) return null;
    return _dateTimeFromJson(value);
  }

  static String? _dateTimeToJsonNullable(DateTime? value) =>
      value?.toIso8601String();

  static GoalStatus _statusFromJson(Object? value) {
    if (value == null) return GoalStatus.active;
    if (value is String) {
      return GoalStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => GoalStatus.active,
      );
    }
    return GoalStatus.active;
  }

  static String _statusToJson(GoalStatus status) => status.name;

  static List<FrictionPointModel> _frictionFromJson(Object? value) {
    if (value is! List) return const [];
    return value
        .map((e) => FrictionPointModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> _frictionToJson(
    List<FrictionPointModel> points,
  ) =>
      points.map((p) => p.toJson()).toList();

  static List<AntiGoalModel> _antiGoalsFromJson(Object? value) {
    if (value is! List) return const [];
    return value
        .map((e) => AntiGoalModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static RealityCheckReportModel? _realityCheckFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    return RealityCheckReportModel.fromJson(value);
  }
}
