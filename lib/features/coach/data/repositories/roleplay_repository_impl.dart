import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/coach/data/datasources/chat_local_datasource.dart';
import 'package:goal_pilot/features/coach/data/models/chat_message_model.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_role.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_evaluation.dart';
import 'package:goal_pilot/features/goals/domain/entities/roleplay_scenario.dart';
import 'package:goal_pilot/features/personalization/data/repositories/personalization_resolver.dart';
import 'package:goal_pilot/features/settings/data/repositories/gemini_api_key_repository_impl.dart';
import 'package:uuid/uuid.dart';

abstract class RoleplayRepository {
  Future<ChatMessage> sendMessage({
    required String message,
    required Goal goal,
    required RoleplayScenario scenario,
    List<ChatMessage> history = const [],
  });

  Future<List<ChatMessage>> getHistory(String sessionKey);

  Future<RoleplayEvaluation?> evaluateIfReady({
    required Goal goal,
    required RoleplayScenario scenario,
    required List<ChatMessage> history,
    int userMessageThreshold = 5,
  });
}

class RoleplayRepositoryImpl implements RoleplayRepository {
  RoleplayRepositoryImpl({
    required ChatLocalDataSource chatDataSource,
    required GeminiRemoteDataSource geminiDataSource,
    required GeminiApiKeyResolver apiKeyResolver,
    required PersonalizationResolver personalizationResolver,
    this.localeCode = 'en',
    Uuid? uuid,
  })  : _chat = chatDataSource,
        _gemini = geminiDataSource,
        _apiKeys = apiKeyResolver,
        _personalization = personalizationResolver,
        _uuid = uuid ?? const Uuid();

  final ChatLocalDataSource _chat;
  final GeminiRemoteDataSource _gemini;
  final GeminiApiKeyResolver _apiKeys;
  final PersonalizationResolver _personalization;
  final String localeCode;
  final Uuid _uuid;

  static String sessionKey(String goalId, String milestoneId) =>
      'roleplay_${goalId}_$milestoneId';

  @override
  Future<ChatMessage> sendMessage({
    required String message,
    required Goal goal,
    required RoleplayScenario scenario,
    List<ChatMessage> history = const [],
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Message cannot be empty.');
    }

    try {
      final milestone = goal.roleplayMilestone;
      final key = sessionKey(
        goal.id,
        milestone?.id ?? goal.currentMilestone?.id ?? goal.id,
      );

      final userMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.user,
        content: trimmed,
        timestamp: DateTime.now(),
        goalId: goal.id,
      );

      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final replyText = await _gemini.sendRoleplayReply(
        apiKey: apiKey,
        goal: goal,
        userMessage: trimmed,
        history: [...history, userMessage],
        characterRole: scenario.characterRole,
        scenarioBrief: scenario.scenarioBrief,
        opponentPersona: scenario.opponentPersona,
        localeCode: localeCode,
        personalizationBlock: personalizationBlock,
      );

      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.assistant,
        content: replyText.trim(),
        timestamp: DateTime.now(),
        goalId: goal.id,
      );

      final updatedHistory = [...history, userMessage, assistantMessage];
      await _saveHistory(key, updatedHistory);
      return assistantMessage;
    } on ValidationFailure {
      rethrow;
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<List<ChatMessage>> getHistory(String sessionKey) async {
    try {
      final models = await _chat.getMessages(sessionKey);
      return models.map((m) => m.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<RoleplayEvaluation?> evaluateIfReady({
    required Goal goal,
    required RoleplayScenario scenario,
    required List<ChatMessage> history,
    int userMessageThreshold = 5,
  }) async {
    final userCount = history.where((m) => m.role.isUser).length;
    if (userCount < userMessageThreshold) return null;

    try {
      final apiKey = await _apiKeys.requireApiKey();
      final personalizationBlock = await _personalization.resolvePromptBlock();
      final response = await _gemini.evaluateRoleplay(
        apiKey: apiKey,
        goal: goal,
        history: history,
        characterRole: scenario.characterRole,
        scenarioBrief: scenario.scenarioBrief,
        localeCode: localeCode,
        personalizationBlock: personalizationBlock,
      );
      return RoleplayEvaluation(
        score: response.score,
        summary: response.summary,
        strengths: response.strengths,
        weaknesses: response.weaknesses,
        improvements: response.improvements,
      );
    } on MissingApiKeyException {
      throw const MissingApiKeyFailure();
    } on TimeoutException {
      throw const TimeoutFailure();
    } on ApiException catch (e) {
      throw mapApiException(e);
    }
  }

  Future<void> _saveHistory(String key, List<ChatMessage> messages) async {
    final models = messages.map(ChatMessageModel.fromEntity).toList();
    await _chat.saveMessages(key, models);
  }
}
