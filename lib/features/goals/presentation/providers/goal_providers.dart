import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/di/core_providers.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/features/coach/data/datasources/chat_local_datasource.dart';
import 'package:goal_pilot/features/coach/data/repositories/coach_repository_impl.dart';
import 'package:goal_pilot/features/coach/data/repositories/roleplay_repository_impl.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/repositories/coach_repository.dart';
import 'package:goal_pilot/features/gamification/data/datasources/win_brick_local_datasource.dart';
import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';
import 'package:goal_pilot/features/goals/data/datasources/checkin_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/goal_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/repositories/goal_repository_impl.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_template_id.dart';
import 'package:goal_pilot/features/goals/domain/templates/goal_template_catalog.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/reality_check_report.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_evaluation.dart';
import 'package:goal_pilot/features/goals/domain/repositories/goal_repository.dart';
import 'package:goal_pilot/features/goals/domain/utils/crisis_detector.dart';
import 'package:goal_pilot/features/goals/domain/utils/pivot_detector.dart';
import 'package:goal_pilot/features/goals/domain/utils/reality_check_detector.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/features/home/presentation/providers/motivation_providers.dart';
import 'package:goal_pilot/features/personalization/presentation/providers/personalization_providers.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';

final goalLocalDataSourceProvider = FutureProvider<GoalLocalDataSource>((ref) {
  return openGoalLocalDataSource();
});

final checkInLocalDataSourceProvider =
    FutureProvider<CheckInLocalDataSource>((ref) {
  return openCheckInLocalDataSource();
});

final winBrickLocalDataSourceProvider =
    FutureProvider<WinBrickLocalDataSource>((ref) {
  return openWinBrickLocalDataSource();
});

final chatLocalDataSourceProvider = FutureProvider<ChatLocalDataSource>((ref) {
  return openChatLocalDataSource();
});

final goalRepositoryProvider = FutureProvider<GoalRepository>((ref) async {
  final local = await ref.watch(goalLocalDataSourceProvider.future);
  final checkIns = await ref.watch(checkInLocalDataSourceProvider.future);
  final winBricks = await ref.watch(winBrickLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  final apiKeys = ref.watch(geminiApiKeyResolverProvider);
  final motivation = await ref.watch(motivationRepositoryProvider.future);
  final personalization =
      await ref.watch(personalizationResolverProvider.future);
  final localeCode = ref.watch(appSettingsProvider).localeCode ?? 'en';
  return GoalRepositoryImpl(
    localDataSource: local,
    checkInDataSource: checkIns,
    geminiDataSource: gemini,
    apiKeyResolver: apiKeys,
    personalizationResolver: personalization,
    winBrickDataSource: winBricks,
    motivationRepository: motivation,
    localeCode: localeCode,
  );
});

final coachRepositoryProvider = FutureProvider<CoachRepository>((ref) async {
  final chat = await ref.watch(chatLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  final apiKeys = ref.watch(geminiApiKeyResolverProvider);
  final personalization =
      await ref.watch(personalizationResolverProvider.future);
  final localeCode = ref.watch(appSettingsProvider).localeCode ?? 'en';
  return CoachRepositoryImpl(
    chatDataSource: chat,
    geminiDataSource: gemini,
    apiKeyResolver: apiKeys,
    personalizationResolver: personalization,
    localeCode: localeCode,
  );
});

final roleplayRepositoryProvider =
    FutureProvider<RoleplayRepository>((ref) async {
  final chat = await ref.watch(chatLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  final apiKeys = ref.watch(geminiApiKeyResolverProvider);
  final personalization =
      await ref.watch(personalizationResolverProvider.future);
  final localeCode = ref.watch(appSettingsProvider).localeCode ?? 'en';
  return RoleplayRepositoryImpl(
    chatDataSource: chat,
    geminiDataSource: gemini,
    apiKeyResolver: apiKeys,
    personalizationResolver: personalization,
    localeCode: localeCode,
  );
});

final goalsStreamProvider = StreamProvider<List<Goal>>((ref) async* {
  final repository = await ref.watch(goalRepositoryProvider.future);
  yield* repository.watchGoals();
});

/// Derived from [goalsStreamProvider] so detail screens stay in sync with the
/// goals list after milestone/task toggles (FutureProvider cached stale snapshots).
final goalByIdProvider = Provider.family<AsyncValue<Goal?>, String>((ref, id) {
  ref.watch(todayProvider);
  final goalsAsync = ref.watch(goalsStreamProvider);
  return goalsAsync.when(
    data: (goals) {
      for (final goal in goals) {
        if (goal.id == id) return AsyncData(goal);
      }
      return const AsyncData(null);
    },
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
});

final checkInsProvider = StreamProvider.family<List<DailyCheckIn>, String>(
  (ref, goalId) async* {
    final repository = await ref.watch(goalRepositoryProvider.future);
    yield* repository.watchCheckIns(goalId);
  },
);

final winBricksProvider = StreamProvider.family<List<WinBrick>, String?>(
  (ref, goalId) async* {
    final repository = await ref.watch(goalRepositoryProvider.future);
    yield* repository.watchWinBricks(goalId: goalId);
  },
);

final allWinBricksProvider = StreamProvider<List<WinBrick>>((ref) async* {
  final repository = await ref.watch(goalRepositoryProvider.future);
  yield* repository.watchWinBricks();
});

final chatHistoryProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, goalId) async {
  final repository = await ref.watch(coachRepositoryProvider.future);
  return repository.getChatHistory(goalId);
});

class CreateGoalController extends StateNotifier<AsyncValue<void>> {
  CreateGoalController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> submit(
    String prompt, {
    GoalPriority priority = GoalPriority.medium,
    GoalSchedule schedule = GoalSchedule.everyDay,
    String? schedulePromptLine,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.createGoalFromPrompt(
        prompt,
        priority: priority,
        schedule: schedule,
        schedulePromptLine: schedulePromptLine ??
            GoalScheduleUtils.decompositionPromptLine(
              schedule,
              l10nForLocale('en'),
            ),
      );
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Goal?> submitFromTemplate(
    GoalTemplateId templateId, {
    GoalPriority priority = GoalPriority.medium,
    GoalSchedule schedule = GoalSchedule.everyDay,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.createGoalFromTemplate(
        templateId,
        priority: priority,
        schedule: schedule,
      );
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  String templatePrompt(GoalTemplateId templateId, String localeCode) {
    return GoalTemplateCatalog.get(templateId, localeCode).aiPrompt;
  }

  void reset() => state = const AsyncData(null);
}

final createGoalControllerProvider =
    StateNotifierProvider<CreateGoalController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return CreateGoalController(repositoryAsync.valueOrNull);
});

class CheckInController extends StateNotifier<AsyncValue<void>> {
  CheckInController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> setWorkedToday({
    required String goalId,
    required bool worked,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.setWorkedToday(
        goalId: goalId,
        worked: worked,
      );
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final checkInControllerProvider =
    StateNotifierProvider<CheckInController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return CheckInController(repositoryAsync.valueOrNull);
});

class PivotController extends StateNotifier<AsyncValue<void>> {
  PivotController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> apply({
    required String goalId,
    required String reason,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.pivotGoal(goalId: goalId, reason: reason);
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final pivotControllerProvider =
    StateNotifierProvider<PivotController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return PivotController(repositoryAsync.valueOrNull);
});

class ExtendMilestonesController extends StateNotifier<AsyncValue<void>> {
  ExtendMilestonesController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> apply({required String goalId}) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.extendMilestones(goalId: goalId);
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final extendMilestonesControllerProvider =
    StateNotifierProvider<ExtendMilestonesController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return ExtendMilestonesController(repositoryAsync.valueOrNull);
});

class CoachChatController extends StateNotifier<AsyncValue<void>> {
  CoachChatController(this._repository) : super(const AsyncData(null));

  final CoachRepository? _repository;

  Future<ChatMessage?> send({
    required String message,
    required Goal goal,
    required List<ChatMessage> history,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final reply = await repository.sendMessage(
        message: message,
        goal: goal,
        history: history,
      );
      state = const AsyncData(null);
      return reply;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final coachChatControllerProvider =
    StateNotifierProvider<CoachChatController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(coachRepositoryProvider);
  return CoachChatController(repositoryAsync.valueOrNull);
});

/// Active goals that still need a check-in today.
final pendingCheckInGoalsProvider = Provider<List<Goal>>((ref) {
  ref.watch(todayProvider);
  final goalsAsync = ref.watch(goalsStreamProvider);
  return goalsAsync.maybeWhen(
    data: (goals) =>
        goals.where((g) => g.needsCheckInToday && g.status.isActive).toList(),
    orElse: () => const [],
  );
});

/// Active goals on a rest day today (no check-in required).
final restDayGoalsProvider = Provider<List<Goal>>((ref) {
  ref.watch(todayProvider);
  final goalsAsync = ref.watch(goalsStreamProvider);
  return goalsAsync.maybeWhen(
    data: (goals) =>
        goals.where((g) => g.isRestDayToday).toList(),
    orElse: () => const [],
  );
});

/// Goals where Pilot suggests a plan pivot based on recent check-ins.
final pivotSuggestionProvider = Provider.family<PivotSuggestion?, String>(
  (ref, goalId) {
    final checkInsAsync = ref.watch(checkInsProvider(goalId));
    return checkInsAsync.maybeWhen(
      data: (checkIns) {
        if (!PivotDetector.shouldSuggestPivot(checkIns)) return null;
        final locale = ref.watch(appSettingsProvider).localeCode ?? 'en';
        final l10n = l10nForLocale(locale);
        return PivotSuggestion(
          goalId: goalId,
          reason: PivotDetector.pivotReason(checkIns, l10n),
        );
      },
      orElse: () => null,
    );
  },
);

class PivotSuggestion {
  const PivotSuggestion({required this.goalId, required this.reason});

  final String goalId;
  final String reason;
}

class CrisisSuggestion {
  const CrisisSuggestion({required this.goalId, required this.reason});

  final String goalId;
  final String reason;
}

/// Goals where Pilot suggests crisis mode (7+ days without check-in or distress signal).
final crisisSuggestionProvider = Provider.family<CrisisSuggestion?, String>(
  (ref, goalId) {
    ref.watch(todayProvider);
    final goalAsync = ref.watch(goalByIdProvider(goalId));
    return goalAsync.maybeWhen(
      data: (goal) {
        if (goal == null || !CrisisDetector.shouldSuggestCrisis(goal)) {
          return null;
        }
        final locale = ref.watch(appSettingsProvider).localeCode ?? 'en';
        final l10n = l10nForLocale(locale);
        return CrisisSuggestion(
          goalId: goalId,
          reason: CrisisDetector.crisisReason(goal, l10n),
        );
      },
      orElse: () => null,
    );
  },
);

/// Goals needing crisis intervention on home dashboard.
final crisisGoalsProvider = Provider<List<Goal>>((ref) {
  ref.watch(todayProvider);
  final goalsAsync = ref.watch(goalsStreamProvider);
  return goalsAsync.maybeWhen(
    data: (goals) => goals
        .where((g) => g.status.isActive && CrisisDetector.shouldSuggestCrisis(g))
        .toList(),
    orElse: () => const [],
  );
});

/// Whether Reality Check is unlocked for a goal.
final realityCheckUnlockedProvider = Provider.family<bool, String>(
  (ref, goalId) {
    final goalAsync = ref.watch(goalByIdProvider(goalId));
    final checkInsAsync = ref.watch(checkInsProvider(goalId));
    return goalAsync.maybeWhen(
      data: (goal) {
        if (goal == null) return false;
        return checkInsAsync.maybeWhen(
          data: (checkIns) => RealityCheckDetector.isUnlocked(goal, checkIns),
          orElse: () => false,
        );
      },
      orElse: () => false,
    );
  },
);

class CrisisModeController extends StateNotifier<AsyncValue<void>> {
  CrisisModeController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> activate(String goalId) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.activateCrisisMode(goalId: goalId);
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Goal?> exit(String goalId) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.exitCrisisMode(goalId: goalId);
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final crisisModeControllerProvider =
    StateNotifierProvider<CrisisModeController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return CrisisModeController(repositoryAsync.valueOrNull);
});

class RealityCheckController extends StateNotifier<AsyncValue<void>> {
  RealityCheckController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<RealityCheckReport?> generate(String goalId) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final report = await repository.generateRealityCheck(goalId: goalId);
      state = const AsyncData(null);
      return report;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final realityCheckControllerProvider =
    StateNotifierProvider<RealityCheckController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(goalRepositoryProvider);
  return RealityCheckController(repositoryAsync.valueOrNull);
});

class RoleplayController extends StateNotifier<AsyncValue<void>> {
  RoleplayController(this._repository) : super(const AsyncData(null));

  final RoleplayRepository? _repository;

  Future<ChatMessage?> send({
    required String message,
    required Goal goal,
    required List<ChatMessage> history,
  }) async {
    final repository = _repository;
    final scenario = goal.roleplayMilestone?.roleplayScenario;
    if (repository == null || scenario == null) return null;

    state = const AsyncLoading();
    try {
      final reply = await repository.sendMessage(
        message: message,
        goal: goal,
        scenario: scenario,
        history: history,
      );
      state = const AsyncData(null);
      return reply;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<RoleplayEvaluation?> evaluate({
    required Goal goal,
    required List<ChatMessage> history,
  }) async {
    final repository = _repository;
    final scenario = goal.roleplayMilestone?.roleplayScenario;
    if (repository == null || scenario == null) return null;

    state = const AsyncLoading();
    try {
      final evaluation = await repository.evaluateIfReady(
        goal: goal,
        scenario: scenario,
        history: history,
      );
      state = const AsyncData(null);
      return evaluation;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final roleplayControllerProvider =
    StateNotifierProvider<RoleplayController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(roleplayRepositoryProvider);
  return RoleplayController(repositoryAsync.valueOrNull);
});

final roleplayHistoryProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, sessionKey) async {
  final repository = await ref.watch(roleplayRepositoryProvider.future);
  return repository.getHistory(sessionKey);
});

Future<void> updateGoalPriority(
  WidgetRef ref, {
  required String goalId,
  required GoalPriority priority,
}) async {
  final repository = ref.read(goalRepositoryProvider).requireValue;
  final goal = await repository.getGoalById(goalId);
  if (goal == null) return;
  await repository.saveGoal(
    goal.copyWith(
      priority: priority,
      updatedAt: DateTime.now(),
    ),
  );
  ref.invalidate(goalByIdProvider(goalId));
}

Future<void> updateGoalSchedule(
  WidgetRef ref, {
  required String goalId,
  required GoalSchedule schedule,
}) async {
  final repository = ref.read(goalRepositoryProvider).requireValue;
  await repository.updateSchedule(goalId: goalId, schedule: schedule);
  ref.invalidate(goalByIdProvider(goalId));
}

Future<void> deleteGoal(
  WidgetRef ref, {
  required String goalId,
}) async {
  final repository = ref.read(goalRepositoryProvider).requireValue;
  await repository.deleteGoal(goalId);
  ref.invalidate(goalByIdProvider(goalId));
}

Future<void> toggleGoalTask(
  WidgetRef ref, {
  required String goalId,
  required String taskId,
  required bool isCompleted,
}) async {
  final repository = ref.read(goalRepositoryProvider).requireValue;
  await repository.toggleTask(
    goalId: goalId,
    taskId: taskId,
    isCompleted: isCompleted,
  );
  ref.invalidate(goalByIdProvider(goalId));
  if (isCompleted) {
    ref.invalidate(winBricksProvider(goalId));
  }
}

/// Keeps stored AI goal content aligned with the selected app language.
final goalLocaleAutoSyncProvider = FutureProvider<void>((ref) async {
  final settings = ref.watch(appSettingsProvider);
  if (!settings.hasLocale) return;

  final repository = await ref.watch(goalRepositoryProvider.future);
  await repository.syncGoalsToLocale();
});

