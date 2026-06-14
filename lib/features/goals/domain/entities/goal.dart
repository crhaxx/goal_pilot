import 'package:equatable/equatable.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';
import 'package:goal_pilot/features/goals/domain/entities/anti_goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/friction_point.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';
import 'package:goal_pilot/features/goals/domain/entities/milestone.dart';
import 'package:goal_pilot/features/goals/domain/entities/reality_check_report.dart';

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
    this.priority = GoalPriority.medium,
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
    this.schedule = GoalSchedule.everyDay,
  });

  final String id;
  final String title;
  final String description;
  final List<Milestone> milestones;
  final String motivationalTips;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GoalStatus status;
  final GoalPriority priority;
  final List<ActionTask> tasks;
  final String dailyHabit;
  final int streak;
  final DateTime? lastCheckInDate;
  final List<FrictionPoint> frictionPoints;
  final List<AntiGoal> antiGoals;
  final bool crisisModeActive;
  final DateTime? crisisStartedAt;
  final List<ActionTask> crisisTasks;
  final String? crisisMessage;
  final RealityCheckReport? realityCheckReport;
  final GoalSchedule schedule;

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
    if (crisisModeActive && crisisTasks.isNotEmpty) return crisisTasks;
    final milestone = currentMilestone;
    if (milestone == null) return const [];
    return tasksForMilestone(milestone.id);
  }

  int get daysSinceCreation =>
      DateTime.now().difference(createdAt).inDays;

  Milestone? get roleplayMilestone {
    final current = currentMilestone;
    if (current != null && current.hasRoleplay) return current;
    return null;
  }

  int todayTasksCompleted([DateTime? day]) {
    final reference = day ?? DateTime.now();
    return todayTasks.where((task) => task.isDoneOn(reference)).length;
  }

  int get todayTasksTotal => todayTasks.length;

  bool hasCheckedInOn(DateTime day) =>
      lastCheckInDate != null && DateUtils.isSameDay(lastCheckInDate!, day);

  bool get hasCheckedInToday => hasCheckedInOn(DateTime.now());

  bool get isActiveDayToday => schedule.isActiveToday;

  bool get needsCheckInToday =>
      !isFullyComplete && isActiveDayToday && !hasCheckedInToday;

  bool get isRestDayToday =>
      status.isActive && !isFullyComplete && !isActiveDayToday;

  DateTime? get nextActiveDay => schedule.nextActiveDayAfter(DateTime.now());

  FrictionPoint? get activeFrictionPoint {
    final milestone = currentMilestone;
    if (milestone == null || frictionPoints.isEmpty) return null;
    for (final point in frictionPoints) {
      if (point.milestoneOrder == milestone.order) return point;
    }
    return null;
  }

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    List<Milestone>? milestones,
    String? motivationalTips,
    DateTime? createdAt,
    DateTime? updatedAt,
    GoalStatus? status,
    GoalPriority? priority,
    List<ActionTask>? tasks,
    String? dailyHabit,
    int? streak,
    DateTime? lastCheckInDate,
    List<FrictionPoint>? frictionPoints,
    List<AntiGoal>? antiGoals,
    bool? crisisModeActive,
    DateTime? crisisStartedAt,
    List<ActionTask>? crisisTasks,
    String? crisisMessage,
    RealityCheckReport? realityCheckReport,
    GoalSchedule? schedule,
    bool clearLastCheckInDate = false,
    bool clearCrisisStartedAt = false,
    bool clearCrisisMessage = false,
    bool clearRealityCheckReport = false,
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
      priority: priority ?? this.priority,
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
      schedule: schedule ?? this.schedule,
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
        priority,
        tasks,
        dailyHabit,
        streak,
        lastCheckInDate,
        frictionPoints,
        antiGoals,
        crisisModeActive,
        crisisStartedAt,
        crisisTasks,
        crisisMessage,
        realityCheckReport,
        schedule,
      ];
}
