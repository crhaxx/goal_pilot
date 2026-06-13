// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyReviewModel _$WeeklyReviewModelFromJson(Map<String, dynamic> json) =>
    WeeklyReviewModel(
      id: json['id'] as String,
      weekStart: WeeklyReviewModel._dateTimeFromJson(
        json['weekStart'] as Object,
      ),
      generatedAt: WeeklyReviewModel._dateTimeFromJson(
        json['generatedAt'] as Object,
      ),
      summary: json['summary'] as String,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextSteps: (json['nextSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WeeklyReviewModelToJson(WeeklyReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'summary': instance.summary,
      'highlights': instance.highlights,
      'nextSteps': instance.nextSteps,
      'weekStart': WeeklyReviewModel._dateTimeToJson(instance.weekStart),
      'generatedAt': WeeklyReviewModel._dateTimeToJson(instance.generatedAt),
    };
