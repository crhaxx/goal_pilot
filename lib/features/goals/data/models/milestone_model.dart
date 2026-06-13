import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/data/models/roleplay_scenario_model.dart';
import 'package:goal_pilot/features/goals/domain/entities/milestone.dart';

part 'milestone_model.g.dart';

@JsonSerializable()
class MilestoneModel {
  const MilestoneModel({
    required this.id,
    required this.title,
    required this.order,
    this.description,
    this.isCompleted = false,
    this.completedAt,
    this.roleplayScenario,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    final base = _$MilestoneModelFromJson(json);
    final rawRoleplay = json['roleplayScenario'] ?? json['roleplay_scenario'];
    if (rawRoleplay is! Map<String, dynamic>) return base;
    return MilestoneModel(
      id: base.id,
      title: base.title,
      order: base.order,
      description: base.description,
      isCompleted: base.isCompleted,
      completedAt: base.completedAt,
      roleplayScenario: RoleplayScenarioModel.fromJson(rawRoleplay),
    );
  }

  final String id;
  final String title;
  final String? description;
  final int order;
  final bool isCompleted;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? completedAt;

  final RoleplayScenarioModel? roleplayScenario;

  Map<String, dynamic> toJson() {
    final json = _$MilestoneModelToJson(this);
    if (roleplayScenario != null) {
      json['roleplayScenario'] = roleplayScenario!.toJson();
    }
    return json;
  }

  factory MilestoneModel.fromEntity(Milestone entity) {
    return MilestoneModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      order: entity.order,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      roleplayScenario: entity.roleplayScenario == null
          ? null
          : RoleplayScenarioModel.fromEntity(entity.roleplayScenario!),
    );
  }

  Milestone toEntity() {
    return Milestone(
      id: id,
      title: title,
      description: description,
      order: order,
      isCompleted: isCompleted,
      completedAt: completedAt,
      roleplayScenario: roleplayScenario?.toEntity(),
    );
  }

  MilestoneModel copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    RoleplayScenarioModel? roleplayScenario,
    bool clearCompletedAt = false,
    bool clearRoleplayScenario = false,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      roleplayScenario: clearRoleplayScenario
          ? null
          : (roleplayScenario ?? this.roleplayScenario),
    );
  }

  static DateTime? _dateTimeFromJson(Object? value) {
    if (value == null) return null;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) =>
      value?.toIso8601String();
}
