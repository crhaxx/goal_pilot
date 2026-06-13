import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/reality_check_report.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_evaluation.dart';

/// Contract for goal persistence, AI decomposition, and daily engagement.
abstract class GoalRepository {
  Future<List<Goal>> getGoals();

  Future<Goal?> getGoalById(String id);

  Future<Goal> createGoalFromPrompt(String userPrompt);

  Future<Goal> saveGoal(Goal goal);

  Future<Goal> toggleMilestone({
    required String goalId,
    required String milestoneId,
    required bool isCompleted,
  });

  Future<Goal> toggleTask({
    required String goalId,
    required String taskId,
    required bool isCompleted,
  });

  Future<Goal> addTask({
    required String goalId,
    required String milestoneId,
    required String title,
    TaskType type = TaskType.once,
  });

  Future<Goal> removeTask({
    required String goalId,
    required String taskId,
  });

  Future<Goal> submitCheckIn({
    required String goalId,
    required int mood,
    String? note,
    bool? antiGoalSurrendered,
    int? antiGoalIndex,
  });

  Future<Goal> pivotGoal({
    required String goalId,
    required String reason,
  });

  Future<Goal> activateCrisisMode({required String goalId});

  Future<Goal> exitCrisisMode({required String goalId});

  Future<RealityCheckReport> generateRealityCheck({required String goalId});

  Future<List<DailyCheckIn>> getCheckIns(String goalId);

  Stream<List<DailyCheckIn>> watchCheckIns(String goalId);

  Future<List<WinBrick>> getWinBricks({String? goalId});

  Stream<List<WinBrick>> watchWinBricks({String? goalId});

  Future<void> deleteGoal(String id);

  Stream<List<Goal>> watchGoals();
}
