import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/gamification/data/datasources/win_brick_local_datasource.dart';
import 'package:goal_pilot/features/gamification/data/models/win_brick_model.dart';
import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';
import 'package:goal_pilot/features/goals/data/datasources/checkin_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/goal_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/models/action_task_model.dart';
import 'package:goal_pilot/features/goals/data/models/daily_checkin_model.dart';
import 'package:goal_pilot/features/goals/data/models/goal_model.dart';
import 'package:goal_pilot/features/goals/data/models/goal_decomposition_response.dart';
import 'package:goal_pilot/features/goals/data/models/milestone_model.dart';
import 'package:goal_pilot/features/goals/data/models/reality_check_report_model.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_status.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/reality_check_report.dart';
import 'package:goal_pilot/features/goals/domain/repositories/goal_repository.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/features/home/data/repositories/motivation_repository.dart';
import 'package:goal_pilot/features/personalization/data/repositories/personalization_resolver.dart';
import 'package:goal_pilot/features/settings/data/repositories/gemini_api_key_repository_impl.dart';
import 'package:uuid/uuid.dart';

class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl({
    required GoalLocalDataSource localDataSource,
    required CheckInLocalDataSource checkInDataSource,
    required GeminiRemoteDataSource geminiDataSource,
    required GeminiApiKeyResolver apiKeyResolver,
    required PersonalizationResolver personalizationResolver,
    required WinBrickLocalDataSource winBrickDataSource,
    MotivationRepository? motivationRepository,
    this.localeCode = 'en',
    Uuid? uuid,
  })  : _local = localDataSource,
        _checkIns = checkInDataSource,
        _gemini = geminiDataSource,
        _apiKeys = apiKeyResolver,
        _personalization = personalizationResolver,
        _winBricks = winBrickDataSource,
        _motivation = motivationRepository,
        _uuid = uuid ?? const Uuid();

  final GoalLocalDataSource _local;
  final CheckInLocalDataSource _checkIns;
  final GeminiRemoteDataSource _gemini;
  final GeminiApiKeyResolver _apiKeys;
  final PersonalizationResolver _personalization;
  final WinBrickLocalDataSource _winBricks;
  final MotivationRepository? _motivation;
  final String localeCode;
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
  Future<Goal> createGoalFromPrompt(
    String userPrompt, {
    GoalPriority priority = GoalPriority.medium,
    GoalSchedule schedule = GoalSchedule.everyDay,
    String? schedulePromptLine,
  }) async {
    final prompt = userPrompt.trim();
    if (prompt.length < 5) {
      throw const ValidationFailure('Describe your goal in at least 5 characters.');
    }

    try {
      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final decomposition = await _gemini.decomposeGoal(
        prompt,
        apiKey: apiKey,
        schedulePromptLine: schedulePromptLine,
        personalizationBlock: personalizationBlock,
      );
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
          final title = step.title.trim();
          if (title.isEmpty) continue;
          tasks.add(
            ActionTaskModel(
              id: _uuid.v4(),
              milestoneId: pair.model.id,
              title: title,
              activeDayOrder: step.activeDayOrder,
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
        frictionPoints: decomposition.potentialFrictionPoints,
        antiGoals: decomposition.antiGoals,
        priority: priority,
        scheduleType: schedule.type,
        timesPerWeek: schedule.timesPerWeek,
        activeWeekdays: schedule.sortedActiveWeekdays,
        createdAt: now,
        updatedAt: now,
      );

      final saved = await _local.saveGoal(goal);
      await _rescheduleGoalNotifications();
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
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
  Future<Goal> updateSchedule({
    required String goalId,
    required GoalSchedule schedule,
  }) async {
    try {
      final existing = await _requireGoal(goalId);
      final updated = existing.copyWith(
        scheduleType: schedule.type,
        timesPerWeek: schedule.timesPerWeek,
        activeWeekdays: schedule.sortedActiveWeekdays,
        updatedAt: DateTime.now(),
      );
      final saved = await _local.saveGoal(updated);
      await _rescheduleGoalNotifications();
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

      if (isCompleted) {
        final milestone = existing.milestones.firstWhere((m) => m.id == milestoneId);
        await _tryAddWinBrick(
          goalId: goalId,
          goalTitle: existing.title,
          context: 'Dokončen milník: ${milestone.title}',
          source: WinBrickSource.task,
        );
      }

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

      ActionTaskModel? completedTask;
      final isCrisisTask = existing.crisisModeActive &&
          existing.crisisTasks.any((t) => t.id == taskId);

      if (isCrisisTask) {
        final updatedCrisisTasks = existing.crisisTasks.map((task) {
          if (task.id != taskId) return task;
          completedTask = task;
          return task.copyWith(
            completedOn: isCompleted ? today : null,
            clearCompletedOn: !isCompleted,
          );
        }).toList();

        final allCrisisDone = updatedCrisisTasks.every(
          (t) => t.completedOn != null &&
              DateUtils.isSameDay(t.completedOn!, today),
        );

        final updated = existing.copyWith(
          crisisTasks: updatedCrisisTasks,
          updatedAt: DateTime.now(),
          crisisModeActive: allCrisisDone ? false : existing.crisisModeActive,
          clearCrisisStartedAt: allCrisisDone,
          clearCrisisMessage: allCrisisDone,
        );

        final saved = await _local.saveGoal(updated);
        return saved.toEntity();
      }

      final updatedTasks = existing.tasks.map((task) {
        if (task.id != taskId) return task;
        completedTask = task;
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

      if (isCompleted && completedTask != null) {
        await _tryAddWinBrick(
          goalId: goalId,
          goalTitle: existing.title,
          context: 'Splněný micro-úkol: ${completedTask!.title}',
          source: WinBrickSource.task,
        );
      }

      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> addTask({
    required String goalId,
    required String milestoneId,
    required String title,
    TaskType type = TaskType.once,
  }) async {
    final trimmed = title.trim();
    if (trimmed.length < 2) {
      throw const ValidationFailure('Task title must be at least 2 characters.');
    }

    try {
      final existing = await _requireGoal(goalId);
      final milestoneExists =
          existing.milestones.any((m) => m.id == milestoneId);
      if (!milestoneExists) {
        throw const ValidationFailure('Milestone not found.');
      }

      final newTask = ActionTaskModel(
        id: _uuid.v4(),
        milestoneId: milestoneId,
        title: trimmed,
        type: type,
        isUserCreated: true,
      );

      final updated = existing.copyWith(
        tasks: [...existing.tasks, newTask],
        updatedAt: DateTime.now(),
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> removeTask({
    required String goalId,
    required String taskId,
  }) async {
    try {
      final existing = await _requireGoal(goalId);
      ActionTaskModel? task;
      for (final candidate in existing.tasks) {
        if (candidate.id == taskId) {
          task = candidate;
          break;
        }
      }
      if (task == null) {
        throw const ValidationFailure('Task not found.');
      }
      if (!task.isUserCreated) {
        throw const ValidationFailure('Only custom tasks can be removed.');
      }

      final updated = existing.copyWith(
        tasks: existing.tasks.where((t) => t.id != taskId).toList(),
        updatedAt: DateTime.now(),
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> submitCheckIn({
    required String goalId,
    required int mood,
    String? note,
    bool? antiGoalSurrendered,
    int? antiGoalIndex,
  }) async {
    if (mood < 1 || mood > 5) {
      throw const ValidationFailure('Mood must be between 1 and 5.');
    }

    try {
      final existing = await _requireGoal(goalId);
      final today = DateUtils.dateOnly(DateTime.now());

      if (!existing.schedule.isActiveOn(today)) {
        throw const ValidationFailure(
          'Today is a rest day for this goal — no check-in needed.',
        );
      }

      if (existing.lastCheckInDate != null &&
          DateUtils.isSameDay(existing.lastCheckInDate!, today)) {
        throw const ValidationFailure('You already checked in today.');
      }

      final entity = existing.toEntity();
      final tasksCompleted = entity.todayTasksCompleted(today);
      final tasksTotal = entity.todayTasksTotal;

      String? antiGoalTitle;
      if (antiGoalIndex != null &&
          antiGoalIndex >= 0 &&
          antiGoalIndex < entity.antiGoals.length) {
        antiGoalTitle = entity.antiGoals[antiGoalIndex].title;
      }

      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final aiResponse = await _gemini.generateCheckInMessage(
        apiKey: apiKey,
        goal: entity,
        mood: mood,
        note: note,
        tasksCompleted: tasksCompleted,
        tasksTotal: tasksTotal,
        antiGoalSurrendered: antiGoalSurrendered,
        antiGoalTitle: antiGoalTitle,
        personalizationBlock: personalizationBlock,
      );

      final streak = _calculateStreak(existing, today);

      final checkIn = DailyCheckInModel(
        id: _uuid.v4(),
        goalId: goalId,
        date: today,
        mood: mood,
        note: note?.trim(),
        pilotMessage: aiResponse.pilotMessage.trim(),
        tasksCompleted: tasksCompleted,
        tasksTotal: tasksTotal,
        antiGoalSurrendered: antiGoalSurrendered,
        antiGoalIndex: antiGoalIndex,
      );
      await _checkIns.saveCheckIn(checkIn);

      final updated = existing.copyWith(
        streak: streak,
        lastCheckInDate: today,
        updatedAt: DateTime.now(),
      );
      final saved = await _local.saveGoal(updated);

      await _scheduleSmartAlertIfNeeded(
        aiResponse.smartAlertText,
        goal: existing.toEntity(),
      );

      final motivation = _motivation;
      if (motivation != null) {
        final allGoals = (await _local.getAllGoals())
            .map((model) => model.toEntity())
            .toList();
        final since = DateTime.now().subtract(const Duration(days: 14));
        final recentCheckIns = (await _checkIns.getAllCheckInsSince(since))
            .map((model) => model.toEntity())
            .toList();

        await motivation.applyCheckInMotivation(
          goals: allGoals,
          recentCheckIns: recentCheckIns,
          l10n: l10nForLocale(localeCode),
          contextualSlogan: aiResponse.contextualSlogan,
          dailyFuelText: aiResponse.dailyFuelText,
        );
      }

      await _rescheduleGoalNotifications();

      if (mood >= 4 || tasksCompleted == tasksTotal && tasksTotal > 0) {
        await _tryAddWinBrick(
          goalId: goalId,
          goalTitle: existing.title,
          context: note?.trim().isNotEmpty == true
              ? note!.trim()
              : 'Check-in: nálada $mood/5, úkoly $tasksCompleted/$tasksTotal',
          source: WinBrickSource.checkIn,
        );
      }

      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> pivotGoal({
    required String goalId,
    required String reason,
  }) async {
    try {
      final existing = await _requireGoal(goalId);
      final entity = existing.toEntity();
      final checkInModels = await _checkIns.getCheckIns(goalId);
      final checkIns = checkInModels.map((m) => m.toEntity()).toList();

      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final pivot = await _gemini.pivotGoal(
        apiKey: apiKey,
        goal: entity,
        checkIns: checkIns,
        reason: reason,
        personalizationBlock: personalizationBlock,
      );

      final sortedPivot = List.of(pivot.milestones)
        ..sort((a, b) => a.order.compareTo(b.order));

      final existingByOrder = {
        for (final m in existing.milestones) m.order: m,
      };

      final newMilestones = <MilestoneModel>[];
      final newTasks = <ActionTaskModel>[];

      for (final pivotMilestone in sortedPivot) {
        final existingMilestone = existingByOrder[pivotMilestone.order];
        final keepExisting = pivotMilestone.preserveExisting &&
            existingMilestone != null &&
            existingMilestone.isCompleted;

        if (keepExisting) {
          newMilestones.add(existingMilestone);
          newTasks.addAll(
            existing.tasks.where((t) => t.milestoneId == existingMilestone.id),
          );
          continue;
        }

        final milestoneId = _uuid.v4();
        newMilestones.add(
          MilestoneModel(
            id: milestoneId,
            title: pivotMilestone.title.trim(),
            description: pivotMilestone.description?.trim(),
            order: pivotMilestone.order,
          ),
        );

        for (final step in pivotMilestone.actionSteps) {
          final title = step.trim();
          if (title.isEmpty) continue;
          newTasks.add(
            ActionTaskModel(
              id: _uuid.v4(),
              milestoneId: milestoneId,
              title: title,
            ),
          );
        }
      }

      final updated = existing.copyWith(
        milestones: newMilestones,
        tasks: newTasks,
        dailyHabit: pivot.dailyHabit.trim().isEmpty
            ? existing.dailyHabit
            : pivot.dailyHabit.trim(),
        motivationalTips: pivot.motivationalTips.trim().isEmpty
            ? existing.motivationalTips
            : '${pivot.summary.trim()}\n\n${pivot.motivationalTips.trim()}',
        updatedAt: DateTime.now(),
        status: GoalStatus.active,
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> extendMilestones({required String goalId}) async {
    try {
      final existing = await _requireGoal(goalId);
      final entity = existing.toEntity();
      if (!entity.isFullyComplete) {
        throw const ValidationFailure(
          'All milestones must be completed before adding more.',
        );
      }

      final checkInModels = await _checkIns.getCheckIns(goalId);
      final checkIns = checkInModels.map((m) => m.toEntity()).toList();

      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final response = await _gemini.generateMoreMilestones(
        apiKey: apiKey,
        goal: entity,
        checkIns: checkIns,
        personalizationBlock: personalizationBlock,
      );

      final milestoneCount = response.milestones.length;
      if (milestoneCount < AppConfig.minExtendMilestones ||
          milestoneCount > AppConfig.maxExtendMilestones) {
        throw ParseFailure(
          'AI returned $milestoneCount milestones. Expected '
          '${AppConfig.minExtendMilestones}-${AppConfig.maxExtendMilestones}.',
        );
      }

      final sortedNew = List.of(response.milestones)
        ..sort((a, b) => a.order.compareTo(b.order));

      final startOrder = existing.milestones
              .map((m) => m.order)
              .fold(0, (max, order) => order > max ? order : max) +
          1;

      final newMilestoneModels = <MilestoneModel>[];
      final newTasks = <ActionTaskModel>[];

      for (var i = 0; i < sortedNew.length; i++) {
        final milestone = sortedNew[i];
        final milestoneId = _uuid.v4();
        newMilestoneModels.add(
          milestone.toMilestoneModel(
            id: milestoneId,
          ).copyWith(order: startOrder + i),
        );

        for (final step in milestone.actionSteps) {
          final title = step.title.trim();
          if (title.isEmpty) continue;
          newTasks.add(
            ActionTaskModel(
              id: _uuid.v4(),
              milestoneId: milestoneId,
              title: title,
              activeDayOrder: step.activeDayOrder,
            ),
          );
        }
      }

      final tips = response.motivationalTips?.trim();
      final updated = existing.copyWith(
        milestones: [...existing.milestones, ...newMilestoneModels],
        tasks: [...existing.tasks, ...newTasks],
        motivationalTips: tips != null && tips.isNotEmpty
            ? tips
            : existing.motivationalTips,
        updatedAt: DateTime.now(),
        status: GoalStatus.active,
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on ValidationFailure {
      rethrow;
    } on ParseException catch (e) {
      throw ParseFailure(e.message);
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> activateCrisisMode({required String goalId}) async {
    try {
      final existing = await _requireGoal(goalId);
      final entity = existing.toEntity();
      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final response = await _gemini.activateCrisisMode(
        apiKey: apiKey,
        goal: entity,
        personalizationBlock: personalizationBlock,
      );
      final milestone = entity.currentMilestone;
      final milestoneId = milestone?.id ?? 'crisis';

      final crisisTasks = <ActionTaskModel>[];
      for (final step in response.atomicTasks) {
        final title = step.trim();
        if (title.isEmpty) continue;
        crisisTasks.add(
          ActionTaskModel(
            id: _uuid.v4(),
            milestoneId: milestoneId,
            title: title,
          ),
        );
      }

      if (crisisTasks.isEmpty) {
        crisisTasks.add(
          ActionTaskModel(
            id: _uuid.v4(),
            milestoneId: milestoneId,
            title: 'Otevři aplikaci a podívej se na svůj cíl (30 sekund)',
          ),
        );
      }

      final updated = existing.copyWith(
        crisisModeActive: true,
        crisisStartedAt: DateTime.now(),
        crisisTasks: crisisTasks,
        crisisMessage: response.crisisMessage.trim(),
        updatedAt: DateTime.now(),
      );

      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Goal> exitCrisisMode({required String goalId}) async {
    try {
      final existing = await _requireGoal(goalId);
      final updated = existing.copyWith(
        crisisModeActive: false,
        crisisTasks: const [],
        clearCrisisStartedAt: true,
        clearCrisisMessage: true,
        updatedAt: DateTime.now(),
      );
      final saved = await _local.saveGoal(updated);
      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<RealityCheckReport> generateRealityCheck({
    required String goalId,
  }) async {
    try {
      final existing = await _requireGoal(goalId);
      final entity = existing.toEntity();
      final checkInModels = await _checkIns.getCheckIns(goalId);
      final checkIns = checkInModels.map((m) => m.toEntity()).toList();

      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final response = await _gemini.generateRealityCheck(
        apiKey: apiKey,
        goal: entity,
        checkIns: checkIns,
        personalizationBlock: personalizationBlock,
      );

      final report = RealityCheckReportModel(
        insight: response.insight.trim(),
        recommendations: response.recommendations,
        generatedAt: DateTime.now(),
      );

      final updated = existing.copyWith(
        realityCheckReport: report,
        updatedAt: DateTime.now(),
      );
      await _local.saveGoal(updated);

      return report.toEntity();
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  Future<void> _tryAddWinBrick({
    required String goalId,
    required String goalTitle,
    required String context,
    required WinBrickSource source,
  }) async {
    try {
      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final label = await _gemini.extractWinLabel(
        apiKey: apiKey,
        goalTitle: goalTitle,
        context: context,
        personalizationBlock: personalizationBlock,
      );
      await _winBricks.saveBrick(
        WinBrickModel(
          id: _uuid.v4(),
          goalId: goalId,
          label: label,
          createdAt: DateTime.now(),
          source: source.name,
        ),
      );
    } catch (_) {
      // Win bricks are a delight feature — never block core flows.
    }
  }

  Future<void> _scheduleSmartAlertIfNeeded(
    String? text, {
    required Goal goal,
  }) async {
    final message = text?.trim();
    if (message == null || message.isEmpty) return;

    final tomorrow = DateUtils.dateOnly(
      DateTime.now().add(const Duration(days: 1)),
    );
    if (!GoalScheduleUtils.goalNeedsNotificationOn(goal, tomorrow)) return;

    await NotificationService.instance.scheduleSmartAlert(
      message: message.length > 120 ? message.substring(0, 120) : message,
      hour: 20,
      minute: 0,
    );
  }

  int _calculateStreak(GoalModel goal, DateTime today) {
    return goal.schedule.calculateStreak(
      currentStreak: goal.streak,
      lastCheckInDate: goal.lastCheckInDate,
      checkInDate: today,
    );
  }

  Future<void> _rescheduleGoalNotifications() async {
    try {
      final goals = (await _local.getAllGoals())
          .map((model) => model.toEntity())
          .toList();
      await NotificationService.instance.rescheduleDailyRemindersForGoals(
        goals: goals,
        l10n: l10nForLocale(localeCode),
      );
    } catch (_) {
      // Notification rescheduling is best-effort.
    }
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
  Future<List<WinBrick>> getWinBricks({String? goalId}) async {
    try {
      final models = await _winBricks.getBricks(goalId: goalId);
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<WinBrick>> watchWinBricks({String? goalId}) {
    return _winBricks.watchBricks(goalId: goalId).map(
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
  final List<DecompositionActionStep> actionSteps;
}
