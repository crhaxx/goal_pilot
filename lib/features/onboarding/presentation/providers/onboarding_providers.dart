import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/features/onboarding/data/datasources/onboarding_local_datasource.dart';

final onboardingLocalDataSourceProvider =
    FutureProvider<OnboardingLocalDataSource>((ref) {
  return openOnboardingLocalDataSource();
});

final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

class OnboardingController {
  OnboardingController(this._ref);

  final Ref _ref;

  Future<void> complete() async {
    final dataSource = await _ref.read(onboardingLocalDataSourceProvider.future);
    await dataSource.markCompleted();
    _ref.read(onboardingCompletedProvider.notifier).state = true;
  }
}

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref);
});
