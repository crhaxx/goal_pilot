import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/data/datasources/checkin_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/goal_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/models/action_task_model.dart';
import 'package:goal_pilot/features/goals/data/models/daily_checkin_model.dart';
import 'package:goal_pilot/features/goals/data/models/goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';
import 'package:goal_pilot/features/goals/domain/repositories/goal_repository.dart';
import 'package:uuid/uuid.dart';

class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl({
    required GoalLocalDataSource localDataSource,
    required CheckInLocalDataSource checkInDataSource,
    required GeminiRemoteDataSource geminiDataSource,
    Uuid? uuid,
  })  : _local = localDataSource,
        _checkIns = checkInDataSource,
        _gemini = geminiDataSource,
        _uuid = uuid ?? const Uuid();

  final GoalLocalDataSource _local;
  final CheckInLocalDataSource _checkIns;
  final GeminiRemoteDataSource _gemini;
  final Uuid _uuid;

  @override
  Future<List<Goal>> getGoals() async {
    try {
      final models = await _local.getAllGoals();
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      final model = await _local.getGoalById(id);
      return model?.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> createGoalFromPrompt(String userPrompt) async {
    final prompt = userPrompt.trim();
    if (prompt.length < 5) {
      throw const ValidationFailure('Describe your goal in at least 5 characters.');
    }

    try {
      final decomposition = await _gemini.decomposeGoal(prompt);
      final milestoneCount = decomposition.milestones.length;
      if (milestoneCount < AppConfig.minMilestones ||
          milestoneCount > AppConfig.maxMilestones) {
        throw ParseFailure(
          'AI returned $milestoneCount milestones. Expected '
          '${AppConfig.minMilestones}-${AppConfig.maxMilestones}.',
        );
      }

      final now = DateTime.now();
      final sortedMilestones = List.of(decomposition.milestones)
        ..sort((a, b) => a.order.compareTo(b.order));

      final milestoneModels = <MilestonePair>[];
      for (final milestone in sortedMilestones) {
        milestoneModels.add(
          MilestonePair(
            model: milestone.toMilestoneModel(id: _uuid.v4()),
            actionSteps: milestone.actionSteps,
          ),
        );
      }

      final tasks = <ActionTaskModel>[];
      for (final pair in milestoneModels) {
        for (final step in pair.actionSteps) {
          final title = step.trim();
          if (title.isEmpty) continue;
          tasks.add(
            ActionTaskModel(
              id: _uuid.v4(),
              milestoneId: pair.model.id,
              title: title,
            ),
          );
        }
      }

      final goal = GoalModel(
        id: _uuid.v4(),
        title: decomposition.title.trim(),
        description: prompt,
        milestones: milestoneModels.map((p) => p.model).toList(growable: false),
        motivationalTips: decomposition.motivationalTips.trim(),
        dailyHabit: decomposition.dailyHabit.trim(),
        tasks: tasks,
        createdAt: now,
        updatedAt: now,
      );

      final saved = await _local.saveGoal(goal);
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ParseException catch (e) {
      throw ParseFailure(e.message);
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }

  @override
  Future<Goal> saveGoal(Goal goal) async {
    try {
      final saved = await _local.saveGoal(GoalModel.fromEntity(goal));
      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> toggleMilestone({
    required String goalId,
    required String milestoneId,
    required bool isCompleted,
  }) async {
    try {
      final existing = await _requireGoal(goalId);

      final updatedMilestones = existing.milestones.map((m) {
        if (m.id != milestoneId) return m;
        return m.copyWith(
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
          clearCompletedAt: !isCompleted,
        );
      }).toList();

      final allComplete = updatedMilestones.every((m) => m.isCompleted);
      final updated = existing.copyWith(
        milestones: updatedMilestones,
        updatedAt: DateTime.now(),
        status: allComplete ? GoalStatus.completed : GoalStatus.active,
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> toggleTask({
    required String goalId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      final existing = await _requireGoal(goalId);
      final today = DateUtils.dateOnly(DateTime.now());

      final updatedTasks = existing.tasks.map((task) {
        if (task.id != taskId) return task;
        return task.copyWith(
          completedOn: isCompleted ? today : null,
          clearCompletedOn: !isCompleted,
        );
      }).toList();

      final updated = existing.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> submitCheckIn({
    required String goalId,
    required int mood,
    String? note,
  }) async {
    if (mood < 1 || mood > 5) {
      throw const ValidationFailure('Mood must be between 1 and 5.');
    }

    try {
      final existing = await _requireGoal(goalId);
      final today = DateUtils.dateOnly(DateTime.now());

      if (existing.lastCheckInDate != null &&
          DateUtils.isSameDay(existing.lastCheckInDate!, today)) {
        throw const ValidationFailure('You already checked in today.');
      }

      final entity = existing.toEntity();
      final tasksCompleted = entity.todayTasksCompleted(today);
      final tasksTotal = entity.todayTasksTotal;

      final pilotMessage = await _gemini.generateCheckInMessage(
        goal: entity,
        mood: mood,
        note: note,
        tasksCompleted: tasksCompleted,
        tasksTotal: tasksTotal,
      );

      final streak = _calculateStreak(existing, today);

      final checkIn = DailyCheckInModel(
        id: _uuid.v4(),
        goalId: goalId,
        date: today,
        mood: mood,
        note: note?.trim(),
        pilotMessage: pilotMessage.trim(),
        tasksCompleted: tasksCompleted,
        tasksTotal: tasksTotal,
      );
      await _checkIns.saveCheckIn(checkIn);

      final updated = existing.copyWith(
        streak: streak,
        lastCheckInDate: today,
        updatedAt: DateTime.now(),
      );
      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  int _calculateStreak(GoalModel goal, DateTime today) {
    final last = goal.lastCheckInDate;
    if (last == null) return 1;
    if (DateUtils.isSameDay(last, today)) return goal.streak;
    if (DateUtils.isYesterday(last, today)) return goal.streak + 1;
    return 1;
  }

  @override
  Future<List<DailyCheckIn>> getCheckIns(String goalId) async {
    try {
      final models = await _checkIns.getCheckIns(goalId);
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<DailyCheckIn>> watchCheckIns(String goalId) {
    return _checkIns.watchCheckIns(goalId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      await _local.deleteGoal(id);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<Goal>> watchGoals() {
    return _local.watchGoals().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  Future<GoalModel> _requireGoal(String goalId) async {
    final existing = await _local.getGoalById(goalId);
    if (existing == null) {
      throw const CacheFailure('Goal not found.');
    }
    return existing;
  }
}

class MilestonePair {
  MilestonePair({required this.model, required this.actionSteps});

  final MilestoneModel model;
  final List<String> actionSteps;
}
