import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/personal_tasks/data/models/personal_task_model.dart';

class PersonalTaskLocalDataSource {
  PersonalTaskLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<PersonalTaskModel>> watchTasks() async* {
    yield await getAllTasks();
    yield* _changes.stream.asyncMap((_) => getAllTasks());
  }

  Future<List<PersonalTaskModel>> getAllTasks() async {
    try {
      final tasks = _box.values
          .map(
            (raw) => PersonalTaskModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) {
          final dueCompare = a.dueDate.compareTo(b.dueDate);
          if (dueCompare != 0) return dueCompare;
          return b.createdAt.compareTo(a.createdAt);
        });
      return tasks;
    } catch (e) {
      throw CacheException('Could not read personal tasks.', cause: e);
    }
  }

  Future<PersonalTaskModel?> getTaskById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      return PersonalTaskModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException('Could not read personal task $id.', cause: e);
    }
  }

  Future<PersonalTaskModel> saveTask(PersonalTaskModel task) async {
    try {
      await _box.put(task.id, jsonEncode(task.toJson()));
      _changes.add(null);
      return task;
    } catch (e) {
      throw CacheException('Could not save personal task.', cause: e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _box.delete(id);
      _changes.add(null);
    } catch (e) {
      throw CacheException('Could not delete personal task.', cause: e);
    }
  }

  void dispose() {
    _changes.close();
  }
}

Future<PersonalTaskLocalDataSource> openPersonalTaskLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.personalTasksBox)) {
    await Hive.openBox<String>(StorageConstants.personalTasksBox);
  }
  return PersonalTaskLocalDataSource(
    Hive.box<String>(StorageConstants.personalTasksBox),
  );
}
