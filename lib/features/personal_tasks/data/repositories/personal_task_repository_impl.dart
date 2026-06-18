import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/personal_tasks/data/datasources/personal_task_local_datasource.dart';
import 'package:goal_pilot/features/personal_tasks/data/models/personal_task_model.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';
import 'package:goal_pilot/features/personal_tasks/domain/repositories/personal_task_repository.dart';
import 'package:uuid/uuid.dart';

class PersonalTaskRepositoryImpl implements PersonalTaskRepository {
  PersonalTaskRepositoryImpl({
    required PersonalTaskLocalDataSource localDataSource,
    required NotificationService notificationService,
    required String localeCode,
  })  : _local = localDataSource,
        _notifications = notificationService,
        _localeCode = localeCode;

  final PersonalTaskLocalDataSource _local;
  final NotificationService _notifications;
  final String _localeCode;

  AppLocalizations get _l10n => l10nForLocale(_localeCode);

  @override
  Stream<List<PersonalTask>> watchTasks() {
    return _local.watchTasks().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<PersonalTask> addTask({
    required String title,
    DateTime? dueDate,
    DateTime? reminderAt,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Task title cannot be empty.');
    }

    final now = DateTime.now();
    final task = PersonalTaskModel(
      id: const Uuid().v4(),
      title: trimmed,
      dueDate: DateUtils.dateOnly(dueDate ?? now),
      createdAt: now,
      reminderAt: reminderAt,
    );

    final saved = await _local.saveTask(task);
    final entity = saved.toEntity();
    await _syncReminder(entity);
    return entity;
  }

  @override
  Future<PersonalTask> updateTask({
    required String id,
    String? title,
    DateTime? dueDate,
    DateTime? reminderAt,
    bool clearReminder = false,
  }) async {
    final existing = await _local.getTaskById(id);
    if (existing == null) {
      throw StateError('Personal task $id not found.');
    }

    final trimmedTitle = title?.trim();
    final updated = PersonalTaskModel(
      id: existing.id,
      title: trimmedTitle == null || trimmedTitle.isEmpty
          ? existing.title
          : trimmedTitle,
      dueDate: dueDate == null
          ? existing.dueDate
          : DateUtils.dateOnly(dueDate),
      createdAt: existing.createdAt,
      completedOn: existing.completedOn,
      reminderAt: clearReminder ? null : (reminderAt ?? existing.reminderAt),
    );

    final saved = await _local.saveTask(updated);
    final entity = saved.toEntity();
    await _syncReminder(entity);
    return entity;
  }

  @override
  Future<PersonalTask> toggleComplete({
    required String id,
    required bool isCompleted,
    DateTime? day,
  }) async {
    final existing = await _local.getTaskById(id);
    if (existing == null) {
      throw StateError('Personal task $id not found.');
    }

    final referenceDay = DateUtils.dateOnly(day ?? DateTime.now());
    final updated = PersonalTaskModel(
      id: existing.id,
      title: existing.title,
      dueDate: existing.dueDate,
      createdAt: existing.createdAt,
      completedOn: isCompleted ? referenceDay : null,
      reminderAt: existing.reminderAt,
    );

    final saved = await _local.saveTask(updated);
    final entity = saved.toEntity();
    if (isCompleted) {
      await _notifications.cancelPersonalTaskReminder(
        notificationId: entity.notificationId,
      );
    } else {
      await _syncReminder(entity);
    }
    return entity;
  }

  @override
  Future<void> deleteTask(String id) async {
    final existing = await _local.getTaskById(id);
    if (existing != null) {
      await _notifications.cancelPersonalTaskReminder(
        notificationId: existing.toEntity().notificationId,
      );
    }
    await _local.deleteTask(id);
  }

  Future<void> _syncReminder(PersonalTask task) async {
    await _notifications.cancelPersonalTaskReminder(
      notificationId: task.notificationId,
    );

    if (task.reminderAt == null || task.isCompleted) return;

    await _notifications.schedulePersonalTaskReminder(
      notificationId: task.notificationId,
      title: task.title,
      scheduledAt: task.reminderAt!,
      l10n: _l10n,
    );
  }

  Future<void> rescheduleAllReminders() async {
    final tasks = await _local.getAllTasks();
    for (final model in tasks) {
      await _syncReminder(model.toEntity());
    }
  }
}
