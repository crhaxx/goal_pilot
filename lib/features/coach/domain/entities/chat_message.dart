import 'package:equatable/equatable.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_role.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.goalId,
  });

  final String id;
  final ChatRole role;
  final String content;
  final DateTime timestamp;
  final String? goalId;

  ChatMessage copyWith({
    String? id,
    ChatRole? role,
    String? content,
    DateTime? timestamp,
    String? goalId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      goalId: goalId ?? this.goalId,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, goalId];
}
