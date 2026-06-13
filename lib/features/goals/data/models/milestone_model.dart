import 'package:json_annotation/json_annotation.dart';
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
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) =>
      _$MilestoneModelFromJson(json);

  final String id;
  final String title;
  final String? description;
  final int order;
  final bool isCompleted;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? completedAt;

  Map<String, dynamic> toJson() => _$MilestoneModelToJson(this);

  factory MilestoneModel.fromEntity(Milestone entity) {
    return MilestoneModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      order: entity.order,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
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
    );
  }

  MilestoneModel copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
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
