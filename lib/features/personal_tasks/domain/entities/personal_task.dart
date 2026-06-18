import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';

class PersonalTask {
  const PersonalTask({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.createdAt,
    this.completedOn,
    this.reminderAt,
  });

  final String id;
  final String title;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime? completedOn;
  final DateTime? reminderAt;

  bool get isCompleted => completedOn != null;

  bool isDueOn(DateTime day) => DateUtils.isSameDay(dueDate, day);

  bool isDoneForDay(DateTime day) =>
      completedOn != null && DateUtils.isSameDay(completedOn!, day);

  bool get hasReminder => reminderAt != null;

  int get notificationId =>
      StorageConstants.personalTaskNotificationBaseId +
      (id.hashCode.abs() % StorageConstants.personalTaskNotificationIdRange);

  PersonalTask copyWith({
    String? title,
    DateTime? dueDate,
    DateTime? completedOn,
    DateTime? reminderAt,
    bool clearCompletedOn = false,
    bool clearReminderAt = false,
  }) {
    return PersonalTask(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      completedOn: clearCompletedOn ? null : (completedOn ?? this.completedOn),
      reminderAt: clearReminderAt ? null : (reminderAt ?? this.reminderAt),
    );
  }
}
