import 'package:goal_pilot/features/journal/domain/entities/journal_entry.dart';

abstract class JournalRepository {
  Future<List<JournalEntry>> getEntries();

  Stream<List<JournalEntry>> watchEntries();

  Future<JournalEntry?> getEntryForDate(DateTime date);

  Future<JournalEntry> saveEntry({
    required DateTime date,
    required String content,
  });
}
