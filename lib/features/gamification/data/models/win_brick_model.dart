import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';

class WinBrickModel {
  const WinBrickModel({
    required this.id,
    required this.goalId,
    required this.label,
    required this.createdAt,
    required this.source,
  });

  final String id;
  final String goalId;
  final String label;
  final DateTime createdAt;
  final String source;

  factory WinBrickModel.fromJson(Map<String, dynamic> json) {
    return WinBrickModel(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      label: json['label'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      source: json['source'] as String? ?? WinBrickSource.task.name,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'goalId': goalId,
        'label': label,
        'createdAt': createdAt.toIso8601String(),
        'source': source,
      };

  WinBrick toEntity() => WinBrick(
        id: id,
        goalId: goalId,
        label: label,
        createdAt: createdAt,
        source: WinBrickSource.values.firstWhere(
          (s) => s.name == source,
          orElse: () => WinBrickSource.task,
        ),
      );

  factory WinBrickModel.fromEntity(WinBrick entity) {
    return WinBrickModel(
      id: entity.id,
      goalId: entity.goalId,
      label: entity.label,
      createdAt: entity.createdAt,
      source: entity.source.name,
    );
  }
}
