import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';

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

  Future<Goal> submitCheckIn({
    required String goalId,
    required int mood,
    String? note,
  });

  Future<List<DailyCheckIn>> getCheckIns(String goalId);

  Stream<List<DailyCheckIn>> watchCheckIns(String goalId);

  Future<void> deleteGoal(String id);

  Stream<List<Goal>> watchGoals();
}
