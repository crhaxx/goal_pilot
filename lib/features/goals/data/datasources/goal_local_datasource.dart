import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/goals/data/models/goal_model.dart';

class GoalLocalDataSource {
  GoalLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<GoalModel>> watchGoals() async* {
    yield await getAllGoals();
    yield* _changes.stream.asyncMap((_) => getAllGoals());
  }

  Future<List<GoalModel>> getAllGoals() async {
    try {
      final goals = _box.values
          .map((raw) => GoalModel.fromJson(jsonDecode(raw) as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final priorityCompare =
              a.priority.sortWeight.compareTo(b.priority.sortWeight);
          if (priorityCompare != 0) return priorityCompare;
          return b.updatedAt.compareTo(a.updatedAt);
        });
      return goals;
    } catch (e) {
      throw CacheException('Could not read goals.', cause: e);
    }
  }

  Future<GoalModel?> getGoalById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      return GoalModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException('Could not read goal $id.', cause: e);
    }
  }

  Future<GoalModel> saveGoal(GoalModel goal) async {
    try {
      await _box.put(goal.id, jsonEncode(goal.toJson()));
      _changes.add(null);
      return goal;
    } catch (e) {
      throw CacheException('Could not save goal.', cause: e);
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _box.delete(id);
      _changes.add(null);
    } catch (e) {
      throw CacheException('Could not delete goal.', cause: e);
    }
  }

  void dispose() {
    _changes.close();
  }
}

Future<GoalLocalDataSource> openGoalLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.goalsBox)) {
    await Hive.openBox<String>(StorageConstants.goalsBox);
  }
  return GoalLocalDataSource(Hive.box<String>(StorageConstants.goalsBox));
}
