import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/data/datasources/checkin_local_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/data/datasources/goal_local_datasource.dart';
import 'package:goal_pilot/features/review/data/datasources/review_local_datasource.dart';
import 'package:goal_pilot/features/review/data/models/weekly_review_model.dart';
import 'package:goal_pilot/features/review/domain/entities/weekly_review.dart';
import 'package:goal_pilot/features/review/domain/repositories/review_repository.dart';
import 'package:uuid/uuid.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required ReviewLocalDataSource reviewDataSource,
    required GoalLocalDataSource goalDataSource,
    required CheckInLocalDataSource checkInDataSource,
    required GeminiRemoteDataSource geminiDataSource,
    Uuid? uuid,
  })  : _reviews = reviewDataSource,
        _goals = goalDataSource,
        _checkIns = checkInDataSource,
        _gemini = geminiDataSource,
        _uuid = uuid ?? const Uuid();

  final ReviewLocalDataSource _reviews;
  final GoalLocalDataSource _goals;
  final CheckInLocalDataSource _checkIns;
  final GeminiRemoteDataSource _gemini;
  final Uuid _uuid;

  @override
  Future<List<WeeklyReview>> getReviews() async {
    try {
      final models = await _reviews.getReviews();
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<WeeklyReview?> getLatestReview() async {
    try {
      final model = await _reviews.getLatestReview();
      return model?.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<WeeklyReview>> watchReviews() {
    return _reviews.watchReviews().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  bool canGenerateReview(DateTime? lastGeneratedAt) {
    if (lastGeneratedAt == null) return true;
    final daysSince = DateTime.now().difference(lastGeneratedAt).inDays;
    return daysSince >= 7;
  }

  @override
  Future<WeeklyReview> generateWeeklyReview() async {
    try {
      final goalModels = await _goals.getAllGoals();
      if (goalModels.isEmpty) {
        throw const ValidationFailure('Create a goal before generating a review.');
      }

      final goals = goalModels.map((m) => m.toEntity()).toList();
      final since = DateTime.now().subtract(const Duration(days: 7));
      final checkInModels = await _checkIns.getAllCheckInsSince(since);
      final checkIns = checkInModels.map((m) => m.toEntity()).toList();

      final latest = await _reviews.getLatestReview();
      if (latest != null && !canGenerateReview(latest.generatedAt)) {
        throw ValidationFailure(
          'Your next review unlocks in '
          '${7 - DateTime.now().difference(latest.generatedAt).inDays} days.',
        );
      }

      final response = await _gemini.generateWeeklyReview(
        goals: goals,
        checkIns: checkIns,
      );

      final now = DateTime.now();
      final weekStart = DateUtils.dateOnly(
        now.subtract(Duration(days: now.weekday - 1)),
      );

      final model = WeeklyReviewModel(
        id: _uuid.v4(),
        weekStart: weekStart,
        generatedAt: now,
        summary: response.summary.trim(),
        highlights: response.highlights,
        nextSteps: response.nextSteps,
      );

      final saved = await _reviews.saveReview(model);
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
    }
  }
}
