import 'package:equatable/equatable.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';

enum TaskType {
  daily,
  once;

  bool get isDaily => this == TaskType.daily;
}

class ActionTask extends Equatable {
  const ActionTask({
    required this.id,
    required this.milestoneId,
    required this.title,
    this.type = TaskType.daily,
    this.completedOn,
    this.isUserCreated = false,
  });

  final String id;
  final String milestoneId;
  final String title;
  final TaskType type;
  final DateTime? completedOn;
  final bool isUserCreated;

  bool isDoneOn(DateTime day) {
    if (completedOn == null) return false;
    if (type.isDaily) {
      return DateUtils.isSameDay(completedOn!, day);
    }
    return true;
  }

  ActionTask copyWith({
    String? id,
    String? milestoneId,
    String? title,
    TaskType? type,
    DateTime? completedOn,
    bool? isUserCreated,
    bool clearCompletedOn = false,
  }) {
    return ActionTask(
      id: id ?? this.id,
      milestoneId: milestoneId ?? this.milestoneId,
      title: title ?? this.title,
      type: type ?? this.type,
      completedOn: clearCompletedOn ? null : (completedOn ?? this.completedOn),
      isUserCreated: isUserCreated ?? this.isUserCreated,
    );
  }

  @override
  List<Object?> get props =>
      [id, milestoneId, title, type, completedOn, isUserCreated];
}
