// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin_model.dart';

DailyCheckInModel _$DailyCheckInModelFromJson(Map<String, dynamic> json) =>
    DailyCheckInModel(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      date: DailyCheckInModel._dateTimeFromJson(json['date']),
      mood: (json['mood'] as num).toInt(),
      note: json['note'] as String?,
      pilotMessage: json['pilotMessage'] as String?,
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      tasksTotal: (json['tasksTotal'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DailyCheckInModelToJson(DailyCheckInModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'date': DailyCheckInModel._dateTimeToJson(instance.date),
      'mood': instance.mood,
      if (instance.note case final value?) 'note': value,
      if (instance.pilotMessage case final value?) 'pilotMessage': value,
      'tasksCompleted': instance.tasksCompleted,
      'tasksTotal': instance.tasksTotal,
    };
