import 'package:equatable/equatable.dart';

class Milestone extends Equatable {
  const Milestone({
    required this.id,
    required this.title,
    required this.order,
    this.description,
    this.isCompleted = false,
    this.completedAt,
  });

  final String id;
  final String title;
  final String? description;
  final int order;
  final bool isCompleted;
  final DateTime? completedAt;

  Milestone copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Milestone(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        order,
        isCompleted,
        completedAt,
      ];
}
