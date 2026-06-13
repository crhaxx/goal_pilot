import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/config/env_config.dart';
import 'package:goal_pilot/features/coach/data/datasources/chat_local_datasource.dart';
import 'package:goal_pilot/features/coach/data/repositories/coach_repository_impl.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/repositories/coach_repository.dart';
import 'package:goal_pilot/features/goals/data/datasources/checkin_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/goal_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/repositories/goal_repository_impl.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/repositories/goal_repository.dart';

final goalLocalDataSourceProvider = FutureProvider<GoalLocalDataSource>((ref) {
  return openGoalLocalDataSource();
});

final checkInLocalDataSourceProvider =
    FutureProvider<CheckInLocalDataSource>((ref) {
  return openCheckInLocalDataSource();
});

final chatLocalDataSourceProvider = FutureProvider<ChatLocalDataSource>((ref) {
  return openChatLocalDataSource();
});

final geminiRemoteDataSourceProvider = Provider<GeminiRemoteDataSource>((ref) {
  return GeminiRemoteDataSource(apiKey: EnvConfig.geminiApiKey);
});

final goalRepositoryProvider = FutureProvider<GoalRepository>((ref) async {
  final local = await ref.watch(goalLocalDataSourceProvider.future);
  final checkIns = await ref.watch(checkInLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  return GoalRepositoryImpl(
    localDataSource: local,
    checkInDataSource: checkIns,
    geminiDataSource: gemini,
  );
});

final coachRepositoryProvider = FutureProvider<CoachRepository>((ref) async {
  final chat = await ref.watch(chatLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  return CoachRepositoryImpl(
    chatDataSource: chat,
    geminiDataSource: gemini,
  );
});

final goalsStreamProvider = StreamProvider<List<Goal>>((ref) async* {
  final repository = await ref.watch(goalRepositoryProvider.future);
  yield* repository.watchGoals();
});

final goalByIdProvider = FutureProvider.family<Goal?, String>((ref, id) async {
  final repository = await ref.watch(goalRepositoryProvider.future);
  return repository.getGoalById(id);
});

final checkInsProvider = StreamProvider.family<List<DailyCheckIn>, String>(
  (ref, goalId) async* {
    final repository = await ref.watch(goalRepositoryProvider.future);
    yield* repository.watchCheckIns(goalId);
  },
);

final chatHistoryProvider =
    FutureProvider.family<List<ChatMessage>, String>((ref, goalId) async {
  final repository = await ref.watch(coachRepositoryProvider.future);
  return repository.getChatHistory(goalId);
});

class CreateGoalController extends StateNotifier<AsyncValue<void>> {
  CreateGoalController(this._repository) : super(const AsyncData(null));

  final GoalRepository? _repository;

  Future<Goal?> submit(String prompt) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.createGoalFromPrompt(prompt);
      state = const AsyncData(null);
      return goal;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
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

  Future<Goal?> submit({
    required String goalId,
    required int mood,
    String? note,
  }) async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final goal = await repository.submitCheckIn(
        goalId: goalId,
        mood: mood,
        note: note,
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
  final goalsAsync = ref.watch(goalsStreamProvider);
  return goalsAsync.maybeWhen(
    data: (goals) =>
        goals.where((g) => g.needsCheckInToday && g.status.isActive).toList(),
    orElse: () => const [],
  );
});
