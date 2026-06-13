import 'package:goal_pilot/features/review/domain/entities/weekly_review.dart';

abstract class ReviewRepository {
  Future<List<WeeklyReview>> getReviews();

  Future<WeeklyReview?> getLatestReview();

  Stream<List<WeeklyReview>> watchReviews();

  Future<WeeklyReview> generateWeeklyReview();

  bool canGenerateReview(DateTime? lastGeneratedAt);
}
