import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/journal/data/datasources/journal_local_datasource.dart';
import 'package:goal_pilot/features/journal/data/models/journal_entry_model.dart';
import 'package:goal_pilot/features/journal/domain/entities/journal_entry.dart';
import 'package:goal_pilot/features/journal/domain/repositories/journal_repository.dart';
import 'package:uuid/uuid.dart';

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._local);

  final JournalLocalDataSource _local;
  final _uuid = const Uuid();

  @override
  Future<List<JournalEntry>> getEntries() async {
    try {
      final models = await _local.getAllEntries();
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Stream<List<JournalEntry>> watchEntries() {
    return _local.watchEntries().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<JournalEntry?> getEntryForDate(DateTime date) async {
    try {
      final model = await _local.getEntryForDate(DateUtils.dateOnly(date));
      return model?.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<JournalEntry> saveEntry({
    required DateTime date,
    required String content,
  }) async {
    try {
      final normalizedDate = DateUtils.dateOnly(date);
      final existing = await _local.getEntryForDate(normalizedDate);
      final now = DateTime.now();

      final model = JournalEntryModel(
        id: existing?.id ?? _uuid.v4(),
        date: normalizedDate,
        content: content.trim(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      final saved = await _local.saveEntry(model);
      return saved.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
