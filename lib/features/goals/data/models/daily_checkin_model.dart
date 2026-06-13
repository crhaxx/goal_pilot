import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';

part 'daily_checkin_model.g.dart';

@JsonSerializable()
class DailyCheckInModel {
  const DailyCheckInModel({
    required this.id,
    required this.goalId,
    required this.date,
    required this.mood,
    this.note,
    this.pilotMessage,
    this.tasksCompleted = 0,
    this.tasksTotal = 0,
  });

  factory DailyCheckInModel.fromJson(Map<String, dynamic> json) =>
      _$DailyCheckInModelFromJson(json);

  final String id;
  final String goalId;
  final int mood;
  final String? note;
  final String? pilotMessage;
  final int tasksCompleted;
  final int tasksTotal;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;

  Map<String, dynamic> toJson() => _$DailyCheckInModelToJson(this);

  factory DailyCheckInModel.fromEntity(DailyCheckIn entity) {
    return DailyCheckInModel(
      id: entity.id,
      goalId: entity.goalId,
      date: entity.date,
      mood: entity.mood,
      note: entity.note,
      pilotMessage: entity.pilotMessage,
      tasksCompleted: entity.tasksCompleted,
      tasksTotal: entity.tasksTotal,
    );
  }

  DailyCheckIn toEntity() {
    return DailyCheckIn(
      id: id,
      goalId: goalId,
      date: date,
      mood: mood,
      note: note,
      pilotMessage: pilotMessage,
      tasksCompleted: tasksCompleted,
      tasksTotal: tasksTotal,
    );
  }

  static DateTime _dateTimeFromJson(Object value) {
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw FormatException('Invalid DateTime value: $value');
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();
}
