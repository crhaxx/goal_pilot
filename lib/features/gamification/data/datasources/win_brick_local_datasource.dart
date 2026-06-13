import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/gamification/data/models/win_brick_model.dart';

class WinBrickLocalDataSource {
  WinBrickLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<WinBrickModel>> watchBricks({String? goalId}) async* {
    yield await getBricks(goalId: goalId);
    yield* _changes.stream.asyncMap((_) => getBricks(goalId: goalId));
  }

  Future<List<WinBrickModel>> getBricks({String? goalId}) async {
    try {
      final bricks = _box.values
          .map(
            (raw) => WinBrickModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .where((brick) => goalId == null || brick.goalId == goalId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return bricks;
    } catch (e) {
      throw CacheException('Could not read win bricks.', cause: e);
    }
  }

  Future<WinBrickModel> saveBrick(WinBrickModel brick) async {
    try {
      await _box.put(brick.id, jsonEncode(brick.toJson()));
      _changes.add(null);
      return brick;
    } catch (e) {
      throw CacheException('Could not save win brick.', cause: e);
    }
  }
}

Future<WinBrickLocalDataSource> openWinBrickLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.winBricksBox)) {
    await Hive.openBox<String>(StorageConstants.winBricksBox);
  }
  return WinBrickLocalDataSource(Hive.box<String>(StorageConstants.winBricksBox));
}
