import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/data/models/daily_checkin_model.dart';

class CheckInLocalDataSource {
  CheckInLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<DailyCheckInModel>> watchCheckIns(String goalId) async* {
    yield await getCheckIns(goalId);
    yield* _changes.stream.asyncMap((_) => getCheckIns(goalId));
  }

  Future<List<DailyCheckInModel>> getCheckIns(String goalId) async {
    try {
      final prefix = '${goalId}_';
      final checkIns = _box.keys
          .whereType<String>()
          .where((key) => key.startsWith(prefix))
          .map((key) => _box.get(key))
          .whereType<String>()
          .map(
            (raw) => DailyCheckInModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return checkIns;
    } catch (e) {
      throw CacheException('Could not read check-ins.', cause: e);
    }
  }

  Future<DailyCheckInModel?> getCheckInForDate(
    String goalId,
    DateTime date,
  ) async {
    final key = _key(goalId, date);
    final raw = _box.get(key);
    if (raw == null) return null;
    return DailyCheckInModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<DailyCheckInModel> saveCheckIn(DailyCheckInModel checkIn) async {
    try {
      final key = _key(checkIn.goalId, checkIn.date);
      await _box.put(key, jsonEncode(checkIn.toJson()));
      _changes.add(null);
      return checkIn;
    } catch (e) {
      throw CacheException('Could not save check-in.', cause: e);
    }
  }

  Future<List<DailyCheckInModel>> getAllCheckInsSince(DateTime since) async {
    try {
      final sinceDate = DateUtils.dateOnly(since);
      return _box.values
          .map(
            (raw) => DailyCheckInModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .where((checkIn) => !checkIn.date.isBefore(sinceDate))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      throw CacheException('Could not read check-ins.', cause: e);
    }
  }

  Future<void> deleteCheckIn(String goalId, DateTime date) async {
    try {
      await _box.delete(_key(goalId, date));
      _changes.add(null);
    } catch (e) {
      throw CacheException('Could not delete check-in.', cause: e);
    }
  }

  String _key(String goalId, DateTime date) =>
      '${goalId}_${DateUtils.dateKey(date)}';
}

Future<CheckInLocalDataSource> openCheckInLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.checkInsBox)) {
    await Hive.openBox<String>(StorageConstants.checkInsBox);
  }
  return CheckInLocalDataSource(Hive.box<String>(StorageConstants.checkInsBox));
}
