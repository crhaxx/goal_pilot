// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_review_model.dart';

WeeklyReviewModel _$WeeklyReviewModelFromJson(Map<String, dynamic> json) =>
    WeeklyReviewModel(
      id: json['id'] as String,
      weekStart: WeeklyReviewModel._dateTimeFromJson(json['weekStart']),
      generatedAt: WeeklyReviewModel._dateTimeFromJson(json['generatedAt']),
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
      'weekStart': WeeklyReviewModel._dateTimeToJson(instance.weekStart),
      'generatedAt': WeeklyReviewModel._dateTimeToJson(instance.generatedAt),
      'summary': instance.summary,
      'highlights': instance.highlights,
      'nextSteps': instance.nextSteps,
    };

WeeklyReviewResponse _$WeeklyReviewResponseFromJson(Map<String, dynamic> json) =>
    WeeklyReviewResponse(
      summary: json['summary'] as String,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextSteps: (json['nextSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WeeklyReviewResponseToJson(
  WeeklyReviewResponse instance,
) =>
    <String, dynamic>{
      'summary': instance.summary,
      'highlights': instance.highlights,
      'nextSteps': instance.nextSteps,
    };
