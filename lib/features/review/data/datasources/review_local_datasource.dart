import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/review/data/models/weekly_review_model.dart';

class ReviewLocalDataSource {
  ReviewLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<WeeklyReviewModel>> watchReviews() async* {
    yield await getReviews();
    yield* _changes.stream.asyncMap((_) => getReviews());
  }

  Future<List<WeeklyReviewModel>> getReviews() async {
    try {
      final reviews = _box.values
          .map(
            (raw) => WeeklyReviewModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
      return reviews;
    } catch (e) {
      throw CacheException('Could not read reviews.', cause: e);
    }
  }

  Future<WeeklyReviewModel?> getLatestReview() async {
    final reviews = await getReviews();
    if (reviews.isEmpty) return null;
    return reviews.first;
  }

  Future<WeeklyReviewModel> saveReview(WeeklyReviewModel review) async {
    try {
      await _box.put(review.id, jsonEncode(review.toJson()));
      _changes.add(null);
      return review;
    } catch (e) {
      throw CacheException('Could not save review.', cause: e);
    }
  }
}

Future<ReviewLocalDataSource> openReviewLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.reviewsBox)) {
    await Hive.openBox<String>(StorageConstants.reviewsBox);
  }
  return ReviewLocalDataSource(Hive.box<String>(StorageConstants.reviewsBox));
}
