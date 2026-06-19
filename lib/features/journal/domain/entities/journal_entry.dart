import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
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

  bool get isEmpty => content.trim().isEmpty;

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, date, content, createdAt, updatedAt];
}
