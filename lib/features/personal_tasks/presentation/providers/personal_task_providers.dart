import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/personal_tasks/data/datasources/personal_task_local_datasource.dart';
import 'package:goal_pilot/features/personal_tasks/data/repositories/personal_task_repository_impl.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';

final personalTaskLocalDataSourceProvider =
    FutureProvider<PersonalTaskLocalDataSource>((ref) {
  return openPersonalTaskLocalDataSource();
});

final personalTaskRepositoryProvider =
    FutureProvider<PersonalTaskRepositoryImpl>((ref) async {
  final local = await ref.watch(personalTaskLocalDataSourceProvider.future);
  final localeCode = ref.watch(appSettingsProvider).localeCode ?? 'en';
  return PersonalTaskRepositoryImpl(
    localDataSource: local,
    notificationService: NotificationService.instance,
    localeCode: localeCode,
  );
});

final personalTasksStreamProvider = StreamProvider<List<PersonalTask>>((ref) async* {
  final repository = await ref.watch(personalTaskRepositoryProvider.future);
  yield* repository.watchTasks();
});

final todaysPersonalTasksProvider = Provider<List<PersonalTask>>((ref) {
  final today = ref.watch(todayProvider);
  final tasks = ref.watch(personalTasksStreamProvider).valueOrNull ?? [];

  return tasks.where((task) {
    final dueTodayOrOverdue =
        !task.dueDate.isAfter(DateUtils.dateOnly(today));
    return dueTodayOrOverdue && !task.isDoneForDay(today);
  }).toList();
});

final todaysCompletedPersonalTasksProvider = Provider<List<PersonalTask>>((ref) {
  final today = ref.watch(todayProvider);
  final tasks = ref.watch(personalTasksStreamProvider).valueOrNull ?? [];

  return tasks.where((task) {
    final dueTodayOrOverdue =
        !task.dueDate.isAfter(DateUtils.dateOnly(today));
    return dueTodayOrOverdue && task.isDoneForDay(today);
  }).toList();
});

final personalTasksStartupProvider = FutureProvider<void>((ref) async {
  final repository = await ref.watch(personalTaskRepositoryProvider.future);
  await repository.rescheduleAllReminders();
});

Future<void> togglePersonalTask(
  WidgetRef ref, {
  required String taskId,
  required bool isCompleted,
}) async {
  final repository = await ref.read(personalTaskRepositoryProvider.future);
  await repository.toggleComplete(id: taskId, isCompleted: isCompleted);
}

Future<void> deletePersonalTask(WidgetRef ref, String taskId) async {
  final repository = await ref.read(personalTaskRepositoryProvider.future);
  await repository.deleteTask(taskId);
}
