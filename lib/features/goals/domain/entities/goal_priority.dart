enum GoalPriority {
  low,
  medium,
  high,
  critical;

  /// Lower value = higher importance when sorting.
  int get sortWeight => switch (this) {
        critical => 0,
        high => 1,
        medium => 2,
        low => 3,
      };
}
