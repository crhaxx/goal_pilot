import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/features/personalization/data/datasources/personalization_local_datasource.dart';
import 'package:goal_pilot/features/personalization/data/repositories/personalization_repository_impl.dart';
import 'package:goal_pilot/features/personalization/data/repositories/personalization_resolver.dart';
import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';
import 'package:goal_pilot/features/personalization/domain/repositories/personalization_repository.dart';

final personalizationLocalDataSourceProvider =
    FutureProvider<PersonalizationLocalDataSource>((ref) {
  return openPersonalizationLocalDataSource();
});

final personalizationRepositoryProvider =
    FutureProvider<PersonalizationRepository>((ref) async {
  final local = await ref.watch(personalizationLocalDataSourceProvider.future);
  return PersonalizationRepositoryImpl(local);
});

final personalizationResolverProvider =
    FutureProvider<PersonalizationResolver>((ref) async {
  final repository = await ref.watch(personalizationRepositoryProvider.future);
  return PersonalizationResolver(repository);
});

class PersonalizationController
    extends StateNotifier<AsyncValue<UserPersonalization>> {
  PersonalizationController(this._ref)
      : super(const AsyncData(UserPersonalization())) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    try {
      final repository =
          await _ref.read(personalizationRepositoryProvider.future);
      final personalization = await repository.getPersonalization();
      state = AsyncData(personalization);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updatePersonalization(UserPersonalization personalization) async {
    final repository =
        await _ref.read(personalizationRepositoryProvider.future);

    state = const AsyncLoading();
    try {
      final saved = await repository.savePersonalization(personalization);
      state = AsyncData(saved);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final current = state.valueOrNull ?? const UserPersonalization();
    await updatePersonalization(current.copyWith(enabled: enabled));
  }

  Future<void> clearAll() async {
    final repository =
        await _ref.read(personalizationRepositoryProvider.future);

    state = const AsyncLoading();
    try {
      await repository.clearPersonalization();
      state = const AsyncData(UserPersonalization());
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final personalizationControllerProvider = StateNotifierProvider<
    PersonalizationController, AsyncValue<UserPersonalization>>((ref) {
  return PersonalizationController(ref);
});

final userPersonalizationProvider = Provider<UserPersonalization>((ref) {
  return ref.watch(personalizationControllerProvider).maybeWhen(
        data: (personalization) => personalization,
        orElse: () => const UserPersonalization(),
      );
});
