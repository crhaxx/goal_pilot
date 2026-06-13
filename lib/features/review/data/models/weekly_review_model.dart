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

class WeeklyReviewResponse {
  const WeeklyReviewResponse({
    required this.summary,
    required this.highlights,
    required this.nextSteps,
    this.smartAlertText,
  });

  factory WeeklyReviewResponse.fromJson(Map<String, dynamic> json) {
    return WeeklyReviewResponse(
      summary: json['summary'] as String,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextSteps: (json['nextSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      smartAlertText: json['smartAlertText'] as String? ??
          json['smart_alert_text'] as String?,
    );
  }

  final String summary;
  final List<String> highlights;
  final List<String> nextSteps;
  final String? smartAlertText;

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'highlights': highlights,
        'nextSteps': nextSteps,
        if (smartAlertText != null) 'smartAlertText': smartAlertText,
      };
}
