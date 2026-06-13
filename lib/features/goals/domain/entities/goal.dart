import 'package:equatable/equatable.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';
import 'package:goal_pilot/features/goals/domain/entities/milestone.dart';

class Goal extends Equatable {
  const Goal({
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

  final String id;
  final String title;
  final String description;
  final List<Milestone> milestones;
  final String motivationalTips;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GoalStatus status;
  final List<ActionTask> tasks;
  final String dailyHabit;
  final int streak;
  final DateTime? lastCheckInDate;

  int get completedMilestoneCount =>
      milestones.where((m) => m.isCompleted).length;

  int get totalMilestones => milestones.length;

  double get progress {
    if (milestones.isEmpty) return 0;
    return completedMilestoneCount / milestones.length;
  }

  int get progressPercent => (progress * 100).round();

  bool get isFullyComplete =>
      milestones.isNotEmpty && completedMilestoneCount == milestones.length;

  List<Milestone> get sortedMilestones =>
      List<Milestone>.from(milestones)..sort((a, b) => a.order.compareTo(b.order));

  Milestone? get currentMilestone {
    for (final milestone in sortedMilestones) {
      if (!milestone.isCompleted) return milestone;
    }
    return null;
  }

  List<ActionTask> tasksForMilestone(String milestoneId) =>
      tasks.where((task) => task.milestoneId == milestoneId).toList();

  List<ActionTask> get todayTasks {
    final milestone = currentMilestone;
    if (milestone == null) return const [];
    return tasksForMilestone(milestone.id);
  }

  int todayTasksCompleted([DateTime? day]) {
    final reference = day ?? DateTime.now();
    return todayTasks.where((task) => task.isDoneOn(reference)).length;
  }

  int get todayTasksTotal => todayTasks.length;

  bool hasCheckedInOn(DateTime day) =>
      lastCheckInDate != null && DateUtils.isSameDay(lastCheckInDate!, day);

  bool get hasCheckedInToday => hasCheckedInOn(DateTime.now());

  bool get needsCheckInToday => !isFullyComplete && !hasCheckedInToday;

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    List<Milestone>? milestones,
    String? motivationalTips,
    DateTime? createdAt,
    DateTime? updatedAt,
    GoalStatus? status,
    List<ActionTask>? tasks,
    String? dailyHabit,
    int? streak,
    DateTime? lastCheckInDate,
    bool clearLastCheckInDate = false,
  }) {
    return Goal(
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        milestones,
        motivationalTips,
        createdAt,
        updatedAt,
        status,
        tasks,
        dailyHabit,
        streak,
        lastCheckInDate,
      ];
}
