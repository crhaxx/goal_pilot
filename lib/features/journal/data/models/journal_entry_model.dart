import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/journal/domain/entities/journal_entry.dart';

class JournalEntryModel {
  const JournalEntryModel({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final DateTime date;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry toEntity() => JournalEntry(
        id: id,
        date: date,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory JournalEntryModel.fromEntity(JournalEntry entry) => JournalEntryModel(
        id: entry.id,
        date: entry.date,
        content: entry.content,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] as String,
      date: DateUtils.dateOnly(DateTime.parse(json['date'] as String)),
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
