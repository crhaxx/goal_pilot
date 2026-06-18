import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';

abstract interface class PersonalTaskRepository {
  Stream<List<PersonalTask>> watchTasks();

  Future<PersonalTask> addTask({
    required String title,
    DateTime? dueDate,
    DateTime? reminderAt,
  });

  Future<PersonalTask> updateTask({
    required String id,
    String? title,
    DateTime? dueDate,
    DateTime? reminderAt,
    bool clearReminder = false,
  });

  Future<PersonalTask> toggleComplete({
    required String id,
    required bool isCompleted,
    DateTime? day,
  });

  Future<void> deleteTask(String id);
}
