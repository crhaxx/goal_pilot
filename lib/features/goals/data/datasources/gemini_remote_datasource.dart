import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/config/env_config.dart';
import 'package:goal_pilot/core/constants/api_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/utils/gemini_error_utils.dart';
import 'package:goal_pilot/core/utils/json_utils.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/goals/data/models/goal_decomposition_response.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/review/data/models/weekly_review_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRemoteDataSource {
  GeminiRemoteDataSource({
    required String apiKey,
    List<String>? models,
  })  : _apiKey = apiKey,
        _models = models ?? EnvConfig.geminiModels;

  final String _apiKey;
  final List<String> _models;

  Future<GoalDecompositionResponse> decomposeGoal(String userPrompt) async {
    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.goalDecompositionSystemPrompt,
      userPrompt: userPrompt.trim(),
    );
    final json = JsonUtils.parseAiJson(text);
    return GoalDecompositionResponse.fromJson(json);
  }

  Future<String> generateCheckInMessage({
    required Goal goal,
    required int mood,
    String? note,
    required int tasksCompleted,
    required int tasksTotal,
  }) async {
    final milestone = goal.currentMilestone;
    final userPrompt = '''
Goal: ${goal.title}
Current milestone: ${milestone?.title ?? 'Completed'}
Daily habit: ${goal.dailyHabit.isEmpty ? 'Not set' : goal.dailyHabit}
Tasks completed today: $tasksCompleted/$tasksTotal
Mood (1-5): $mood
User note: ${note?.trim().isEmpty ?? true ? 'None' : note!.trim()}
Streak: ${goal.streak} days
''';

    return _generateWithFallback(
      systemPrompt: ApiConstants.checkInSystemPrompt,
      userPrompt: userPrompt,
    );
  }

  Future<String> sendCoachReply({
    required Goal goal,
    required String userMessage,
    required List<ChatMessage> history,
  }) async {
    final context = _buildGoalContext(goal);
    final historyText = history
        .where((m) => !m.role.name.contains('system'))
        .map((m) => '${m.role.name}: ${m.content}')
        .join('\n');

    final userPrompt = '''
$context

Conversation so far:
$historyText

User: $userMessage
Pilot:''';

    return _generateWithFallback(
      systemPrompt: ApiConstants.coachSystemPrompt,
      userPrompt: userPrompt,
    );
  }

  Future<WeeklyReviewResponse> generateWeeklyReview({
    required List<Goal> goals,
    required List<DailyCheckIn> checkIns,
  }) async {
    final goalsText = goals.map((goal) {
      return '''
- ${goal.title}: ${goal.progressPercent}% progress, ${goal.streak}-day streak, ${goal.completedMilestoneCount}/${goal.totalMilestones} milestones, checked in today: ${goal.hasCheckedInToday}
''';
    }).join();

    final checkInsText = checkIns.isEmpty
        ? 'No check-ins this week.'
        : checkIns
            .map(
              (c) =>
                  '- ${c.date.toIso8601String().split('T').first}: mood ${c.mood}/5, tasks ${c.tasksCompleted}/${c.tasksTotal}${c.note == null ? '' : ', note: ${c.note}'}',
            )
            .join('\n');

    final userPrompt = '''
Weekly data for review:

Goals:
$goalsText

Check-ins (last 7 days):
$checkInsText
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.weeklyReviewSystemPrompt,
      userPrompt: userPrompt,
    );
    final json = JsonUtils.parseAiJson(text);
    return WeeklyReviewResponse.fromJson(json);
  }

  String _buildGoalContext(Goal goal) {
    final milestone = goal.currentMilestone;
    final buffer = StringBuffer()
      ..writeln('Goal: ${goal.title}')
      ..writeln('Progress: ${goal.progressPercent}%')
      ..writeln('Streak: ${goal.streak} days')
      ..writeln('Daily habit: ${goal.dailyHabit}')
      ..writeln('Current milestone: ${milestone?.title ?? 'All complete'}');

    if (milestone != null) {
      buffer.writeln('Milestone description: ${milestone.description ?? ''}');
      final tasks = goal.todayTasks;
      if (tasks.isNotEmpty) {
        buffer.writeln('Today\'s tasks:');
        for (final task in tasks) {
          buffer.writeln(
            '- ${task.title} (${task.isDoneOn(DateTime.now()) ? 'done' : 'pending'})',
          );
        }
      }
    }

    return buffer.toString();
  }

  Future<String> _generateWithFallback({
    required String systemPrompt,
    required String userPrompt,
  }) async {
    ApiException? lastRetryableError;

    for (final modelName in _models) {
      try {
        return await _generateWithModel(
          modelName: modelName,
          systemPrompt: systemPrompt,
          userPrompt: userPrompt,
        );
      } on ApiException catch (e) {
        if (e.isRetryableWithNextModel) {
          lastRetryableError = e;
          continue;
        }
        rethrow;
      }
    }

    throw lastRetryableError ??
        const ApiException(
          'All configured Gemini models are unavailable.',
          isModelUnavailable: true,
        );
  }

  Future<String> _generateWithModel({
    required String modelName,
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      systemInstruction: Content.system(systemPrompt),
    );

    try {
      final response = await model
          .generateContent([Content.text(userPrompt)])
          .timeout(
            AppConfig.apiTimeout,
            onTimeout: () => throw const TimeoutException(
              'Gemini request timed out.',
            ),
          );

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw const ApiException('Gemini returned an empty response.');
      }
      return text;
    } on ParseException {
      rethrow;
    } on GenerativeAIException catch (e) {
      throw _mapGenerativeAiException(e);
    } catch (e) {
      if (e is ApiException || e is ParseException || e is TimeoutException) {
        rethrow;
      }
      throw ApiException('Gemini request failed.', cause: e);
    }
  }

  ApiException _mapGenerativeAiException(GenerativeAIException error) {
    final message = error.message;
    if (GeminiErrorUtils.isQuotaError(message)) {
      return ApiException(
        message,
        isQuotaExceeded: true,
        retryAfter: GeminiErrorUtils.parseRetryAfter(message),
      );
    }
    if (GeminiErrorUtils.isModelUnavailableError(message)) {
      return ApiException(
        message,
        isModelUnavailable: true,
      );
    }
    return ApiException(message);
  }
}
