import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/core/utils/journal_date_utils.dart';
import 'package:goal_pilot/features/journal/data/datasources/journal_local_datasource.dart';
import 'package:goal_pilot/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:goal_pilot/features/journal/domain/entities/journal_entry.dart';
import 'package:goal_pilot/features/journal/domain/repositories/journal_repository.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';

final journalLocalDataSourceProvider =
    FutureProvider<JournalLocalDataSource>((ref) {
  return openJournalLocalDataSource();
});

final journalRepositoryProvider = FutureProvider<JournalRepository>((ref) async {
  final local = await ref.watch(journalLocalDataSourceProvider.future);
  return JournalRepositoryImpl(local);
});

final journalEntriesStreamProvider = StreamProvider<List<JournalEntry>>((ref) async* {
  final repository = await ref.watch(journalRepositoryProvider.future);
  yield* repository.watchEntries();
});

final currentJournalDateProvider = Provider<DateTime>((ref) {
  ref.watch(todayProvider);
  final settings = ref.watch(appSettingsProvider);
  return JournalDateUtils.currentJournalDate(
    now: DateTime.now(),
    dayStartHour: settings.journalDayStartHour,
    dayStartMinute: settings.journalDayStartMinute,
  );
});

final currentJournalEntryProvider = Provider<JournalEntry?>((ref) {
  final journalDate = ref.watch(currentJournalDateProvider);
  final entries = ref.watch(journalEntriesStreamProvider).valueOrNull ?? [];
  for (final entry in entries) {
    if (entry.date.year == journalDate.year &&
        entry.date.month == journalDate.month &&
        entry.date.day == journalDate.day) {
      return entry;
    }
  }
  return null;
});

final journalDayUnlockProvider = Provider<DateTime?>((ref) {
  ref.watch(todayProvider);
  final settings = ref.watch(appSettingsProvider);
  return JournalDateUtils.nextJournalDateUnlock(
    now: DateTime.now(),
    dayStartHour: settings.journalDayStartHour,
    dayStartMinute: settings.journalDayStartMinute,
  );
});

Future<void> saveJournalEntry(
  WidgetRef ref, {
  required DateTime date,
  required String content,
}) async {
  final repository = await ref.read(journalRepositoryProvider.future);
  await repository.saveEntry(date: date, content: content);
}
