enum GoalStatus {
  active,
  completed,
  archived;

  bool get isActive => this == GoalStatus.active;
  bool get isCompleted => this == GoalStatus.completed;
}
