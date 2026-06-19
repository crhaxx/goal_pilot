import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/journal/data/models/journal_entry_model.dart';

class JournalLocalDataSource {
  JournalLocalDataSource(this._box);

  final Box<String> _box;
  final _changes = StreamController<void>.broadcast();

  Stream<List<JournalEntryModel>> watchEntries() async* {
    yield await getAllEntries();
    yield* _changes.stream.asyncMap((_) => getAllEntries());
  }

  Future<List<JournalEntryModel>> getAllEntries() async {
    try {
      final entries = _box.values
          .map(
            (raw) => JournalEntryModel.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return entries;
    } catch (e) {
      throw CacheException('Could not read journal entries.', cause: e);
    }
  }

  Future<JournalEntryModel?> getEntryForDate(DateTime date) async {
    final raw = _box.get(_key(date));
    if (raw == null) return null;
    return JournalEntryModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<JournalEntryModel> saveEntry(JournalEntryModel entry) async {
    try {
      await _box.put(_key(entry.date), jsonEncode(entry.toJson()));
      _changes.add(null);
      return entry;
    } catch (e) {
      throw CacheException('Could not save journal entry.', cause: e);
    }
  }

  String _key(DateTime date) => DateUtils.dateKey(date);
}

Future<JournalLocalDataSource> openJournalLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.journalBox)) {
    await Hive.openBox<String>(StorageConstants.journalBox);
  }
  return JournalLocalDataSource(Hive.box<String>(StorageConstants.journalBox));
}
