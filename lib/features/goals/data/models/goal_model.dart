import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/data/models/action_task_model.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
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
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

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

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);

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
    bool clearLastCheckInDate = false,
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
}
