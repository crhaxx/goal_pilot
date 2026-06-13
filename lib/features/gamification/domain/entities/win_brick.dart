import 'package:equatable/equatable.dart';

enum WinBrickSource { task, checkIn }

class WinBrick extends Equatable {
  const WinBrick({
    required this.id,
    required this.goalId,
    required this.label,
    required this.createdAt,
    required this.source,
  });

  final String id;
  final String goalId;
  final String label;
  final DateTime createdAt;
  final WinBrickSource source;

  @override
  List<Object?> get props => [id, goalId, label, createdAt, source];
}
