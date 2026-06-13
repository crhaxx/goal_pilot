// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyCheckInModel _$DailyCheckInModelFromJson(Map<String, dynamic> json) =>
    DailyCheckInModel(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      date: DailyCheckInModel._dateTimeFromJson(json['date'] as Object),
      mood: (json['mood'] as num).toInt(),
      note: json['note'] as String?,
      pilotMessage: json['pilotMessage'] as String?,
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      tasksTotal: (json['tasksTotal'] as num?)?.toInt() ?? 0,
      antiGoalSurrendered: json['antiGoalSurrendered'] as bool?,
      antiGoalIndex: (json['antiGoalIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DailyCheckInModelToJson(DailyCheckInModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'mood': instance.mood,
      'note': ?instance.note,
      'pilotMessage': ?instance.pilotMessage,
      'tasksCompleted': instance.tasksCompleted,
      'tasksTotal': instance.tasksTotal,
      'antiGoalSurrendered': ?instance.antiGoalSurrendered,
      'antiGoalIndex': ?instance.antiGoalIndex,
      'date': DailyCheckInModel._dateTimeToJson(instance.date),
    };
