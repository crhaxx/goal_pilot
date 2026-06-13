import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';

/// Contract for AI coach chat sessions.
abstract class CoachRepository {
  Future<ChatMessage> sendMessage({
    required String message,
    required Goal goal,
    List<ChatMessage> history,
  });

  Future<List<ChatMessage>> getChatHistory(String goalId);

  Future<void> saveChatHistory(String goalId, List<ChatMessage> messages);
}
