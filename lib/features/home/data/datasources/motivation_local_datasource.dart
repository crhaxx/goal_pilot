import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:hive/hive.dart';

class MotivationLocalDataSource {
  MotivationLocalDataSource(this._box);

  final Box<String> _box;

  String _contextualKey(DateTime date) =>
      '${StorageConstants.contextualSloganPrefix}${DateUtils.dateKey(date)}';

  String _dailyFuelKey(DateTime date) =>
      '${StorageConstants.dailyFuelPrefix}${DateUtils.dateKey(date)}';

  Future<String?> getContextualSlogan(DateTime date) async {
    return _box.get(_contextualKey(date));
  }

  Future<void> saveContextualSlogan(DateTime date, String slogan) async {
    await _box.put(_contextualKey(date), slogan.trim());
  }

  Future<String?> getDailyFuel(DateTime date) async {
    return _box.get(_dailyFuelKey(date));
  }

  Future<void> saveDailyFuel(DateTime date, String text) async {
    await _box.put(_dailyFuelKey(date), text.trim());
  }
}

Future<MotivationLocalDataSource> openMotivationLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  return MotivationLocalDataSource(
    Hive.box<String>(StorageConstants.preferencesBox),
  );
}
