import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/review/data/datasources/review_local_datasource.dart';
import 'package:goal_pilot/features/review/data/repositories/review_repository_impl.dart';
import 'package:goal_pilot/features/review/domain/entities/weekly_review.dart';
import 'package:goal_pilot/features/review/domain/repositories/review_repository.dart';

final reviewLocalDataSourceProvider =
    FutureProvider<ReviewLocalDataSource>((ref) {
  return openReviewLocalDataSource();
});

final reviewRepositoryProvider = FutureProvider<ReviewRepository>((ref) async {
  final reviews = await ref.watch(reviewLocalDataSourceProvider.future);
  final goals = await ref.watch(goalLocalDataSourceProvider.future);
  final checkIns = await ref.watch(checkInLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  return ReviewRepositoryImpl(
    reviewDataSource: reviews,
    goalDataSource: goals,
    checkInDataSource: checkIns,
    geminiDataSource: gemini,
  );
});

final reviewsStreamProvider = StreamProvider<List<WeeklyReview>>((ref) async* {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  yield* repository.watchReviews();
});

final latestReviewProvider = FutureProvider<WeeklyReview?>((ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return repository.getLatestReview();
});

class WeeklyReviewController extends StateNotifier<AsyncValue<void>> {
  WeeklyReviewController(this._repository) : super(const AsyncData(null));

  final ReviewRepository? _repository;

  Future<WeeklyReview?> generate() async {
    final repository = _repository;
    if (repository == null) return null;

    state = const AsyncLoading();
    try {
      final review = await repository.generateWeeklyReview();
      state = const AsyncData(null);
      return review;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final weeklyReviewControllerProvider =
    StateNotifierProvider<WeeklyReviewController, AsyncValue<void>>((ref) {
  final repositoryAsync = ref.watch(reviewRepositoryProvider);
  return WeeklyReviewController(repositoryAsync.valueOrNull);
});
