import 'package:equatable/equatable.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_scenario.dart';

class Milestone extends Equatable {
  const Milestone({
    required this.id,
    required this.title,
    required this.order,
    this.description,
    this.isCompleted = false,
    this.completedAt,
    this.roleplayScenario,
  });

  final String id;
  final String title;
  final String? description;
  final int order;
  final bool isCompleted;
  final DateTime? completedAt;
  final RoleplayScenario? roleplayScenario;

  bool get hasRoleplay => roleplayScenario != null;

  Milestone copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    RoleplayScenario? roleplayScenario,
    bool clearCompletedAt = false,
    bool clearRoleplayScenario = false,
  }) {
    return Milestone(
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        order,
        isCompleted,
        completedAt,
        roleplayScenario,
      ];
}
