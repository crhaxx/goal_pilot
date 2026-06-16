import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/di/core_providers.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/personalization/presentation/providers/personalization_providers.dart';
import 'package:goal_pilot/features/home/data/datasources/motivation_local_datasource.dart';
import 'package:goal_pilot/features/home/data/repositories/motivation_repository.dart';

final motivationLocalDataSourceProvider =
    FutureProvider<MotivationLocalDataSource>((ref) {
  return openMotivationLocalDataSource();
});

final motivationRepositoryProvider =
    FutureProvider<MotivationRepository>((ref) async {
  final local = await ref.watch(motivationLocalDataSourceProvider.future);
  final gemini = ref.watch(geminiRemoteDataSourceProvider);
  final apiKeys = ref.watch(geminiApiKeyResolverProvider);
  final personalization =
      await ref.watch(personalizationResolverProvider.future);
  return MotivationRepository(
    localDataSource: local,
    geminiDataSource: gemini,
    apiKeyResolver: apiKeys,
    personalizationResolver: personalization,
  );
});

/// Activates scheduled morning quote on the home screen widget when the app opens.
final homeWidgetStartupProvider = FutureProvider<void>((ref) async {
  ref.watch(todayProvider);
  final motivation = await ref.watch(motivationRepositoryProvider.future);
  final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
  if (goals.isEmpty) {
    await motivation.refreshHomeWidgetOnStartup(
      goals: const [],
      recentCheckIns: const [],
    );
    return;
  }

  final checkInsDs = await ref.watch(checkInLocalDataSourceProvider.future);
  final since = DateTime.now().subtract(const Duration(days: 14));
  final recentCheckIns =
      (await checkInsDs.getAllCheckInsSince(since)).map((m) => m.toEntity()).toList();

  await motivation.refreshHomeWidgetOnStartup(
    goals: goals,
    recentCheckIns: recentCheckIns,
  );
});
