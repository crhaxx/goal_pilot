import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/review/domain/entities/weekly_review.dart';

part 'weekly_review_model.g.dart';

@JsonSerializable()
class WeeklyReviewModel {
  const WeeklyReviewModel({
    required this.id,
    required this.weekStart,
    required this.generatedAt,
    required this.summary,
    required this.highlights,
    required this.nextSteps,
  });

  factory WeeklyReviewModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReviewModelFromJson(json);

  final String id;
  final String summary;
  final List<String> highlights;
  final List<String> nextSteps;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime weekStart;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime generatedAt;

  Map<String, dynamic> toJson() => _$WeeklyReviewModelToJson(this);

  WeeklyReview toEntity() => WeeklyReview(
        id: id,
        weekStart: weekStart,
        generatedAt: generatedAt,
        summary: summary,
        highlights: highlights,
        nextSteps: nextSteps,
      );

  static DateTime _dateTimeFromJson(Object value) {
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw FormatException('Invalid DateTime value: $value');
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();
}

@JsonSerializable()
class WeeklyReviewResponse {
  const WeeklyReviewResponse({
    required this.summary,
    required this.highlights,
    required this.nextSteps,
  });

  factory WeeklyReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReviewResponseFromJson(json);

  final String summary;
  final List<String> highlights;
  final List<String> nextSteps;

  Map<String, dynamic> toJson() => _$WeeklyReviewResponseToJson(this);
}
