import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/coach/data/datasources/chat_local_datasource.dart';
import 'package:goal_pilot/features/coach/data/models/chat_message_model.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_role.dart';
import 'package:goal_pilot/features/coach/domain/repositories/coach_repository.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:uuid/uuid.dart';

class CoachRepositoryImpl implements CoachRepository {
  CoachRepositoryImpl({
    required ChatLocalDataSource chatDataSource,
    required GeminiRemoteDataSource geminiDataSource,
    Uuid? uuid,
  })  : _chat = chatDataSource,
        _gemini = geminiDataSource,
        _uuid = uuid ?? const Uuid();

  final ChatLocalDataSource _chat;
  final GeminiRemoteDataSource _gemini;
  final Uuid _uuid;

  @override
  Future<ChatMessage> sendMessage({
    required String message,
    required Goal goal,
    List<ChatMessage> history = const [],
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Message cannot be empty.');
    }

    try {
      final userMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.user,
        content: trimmed,
        timestamp: DateTime.now(),
        goalId: goal.id,
      );

      final replyText = await _gemini.sendCoachReply(
        goal: goal,
        userMessage: trimmed,
        history: [...history, userMessage],
      );

      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.assistant,
        content: replyText.trim(),
        timestamp: DateTime.now(),
        goalId: goal.id,
      );

      final updatedHistory = [...history, userMessage, assistantMessage];
      await saveChatHistory(goal.id, updatedHistory);
      return assistantMessage;
    } on ValidationFailure {
      rethrow;
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<List<ChatMessage>> getChatHistory(String goalId) async {
    try {
      final models = await _chat.getMessages(goalId);
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> saveChatHistory(String goalId, List<ChatMessage> messages) async {
    try {
      final models = messages.map(ChatMessageModel.fromEntity).toList();
      await _chat.saveMessages(goalId, models);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
