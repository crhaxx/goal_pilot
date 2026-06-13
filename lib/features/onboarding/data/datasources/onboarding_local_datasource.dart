import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';

class OnboardingLocalDataSource {
  OnboardingLocalDataSource(this._box);

  final Box<String> _box;

  Future<bool> isCompleted() async {
    return _box.get(StorageConstants.onboardingCompletedKey) == 'true';
  }

  Future<void> markCompleted() async {
    await _box.put(StorageConstants.onboardingCompletedKey, 'true');
  }
}

Future<OnboardingLocalDataSource> openOnboardingLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  return OnboardingLocalDataSource(
    Hive.box<String>(StorageConstants.preferencesBox),
  );
}
