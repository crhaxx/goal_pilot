import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/config/env_config.dart';
import 'package:goal_pilot/core/constants/api_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/utils/gemini_error_utils.dart';
import 'package:goal_pilot/core/utils/json_utils.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/goals/data/models/ai_response_models.dart';
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

  Future<CheckInAiResponse> generateCheckInMessage({
    required Goal goal,
    required int mood,
    String? note,
    required int tasksCompleted,
    required int tasksTotal,
    bool? antiGoalSurrendered,
    String? antiGoalTitle,
  }) async {
    final milestone = goal.currentMilestone;
    final antiGoalLine = antiGoalTitle == null
        ? ''
        : '\nAnti-goal today: $antiGoalTitle — user surrendered: ${antiGoalSurrendered == true ? 'YES' : 'NO'}';
    final userPrompt = '''
Goal: ${goal.title}
Current milestone: ${milestone?.title ?? 'Completed'}
Daily habit: ${goal.dailyHabit.isEmpty ? 'Not set' : goal.dailyHabit}
Tasks completed today: $tasksCompleted/$tasksTotal
Mood (1-5): $mood
User note: ${note?.trim().isEmpty ?? true ? 'None' : note!.trim()}
Streak: ${goal.streak} days
Crisis mode: ${goal.crisisModeActive ? 'ACTIVE' : 'off'}$antiGoalLine
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.checkInSystemPrompt,
      userPrompt: userPrompt,
    );

    try {
      final json = JsonUtils.parseAiJson(text);
      return CheckInAiResponse.fromJson(json);
    } on ParseException {
      return CheckInAiResponse(pilotMessage: text);
    }
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

  Future<GoalPivotResponse> pivotGoal({
    required Goal goal,
    required List<DailyCheckIn> checkIns,
    required String reason,
  }) async {
    final journalText = checkIns.isEmpty
        ? 'No check-ins yet.'
        : checkIns
            .take(14)
            .map(
              (c) =>
                  '- ${c.date.toIso8601String().split('T').first}: mood ${c.mood}/5, tasks ${c.tasksCompleted}/${c.tasksTotal}${c.note == null ? '' : ', note: ${c.note}'}',
            )
            .join('\n');

    final milestonesText = goal.sortedMilestones.map((m) {
      final status = m.isCompleted ? 'DONE' : 'pending';
      return '- [${m.order}] $status: ${m.title}';
    }).join('\n');

    final userPrompt = '''
Goal: ${goal.title}
Original description: ${goal.description}
Current streak: ${goal.streak} days (MUST preserve)
Progress: ${goal.progressPercent}%
Daily habit: ${goal.dailyHabit}
Pivot reason: $reason

Current milestones:
$milestonesText

Journal (recent check-ins):
$journalText

Adapt the remaining plan to the new reality while preserving completed milestones and streak.
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.pivotGoalSystemPrompt,
      userPrompt: userPrompt,
    );
    final json = JsonUtils.parseAiJson(text);
    return GoalPivotResponse.fromJson(json);
  }

  Future<String> extractWinLabel({
    required String goalTitle,
    required String context,
  }) async {
    final userPrompt = '''
Goal: $goalTitle
Accomplishment context: $context
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.winLabelSystemPrompt,
      userPrompt: userPrompt,
    );

    var label = text.trim();
    if (label.length >= 2 &&
        ((label.startsWith('"') && label.endsWith('"')) ||
            (label.startsWith("'") && label.endsWith("'")))) {
      label = label.substring(1, label.length - 1).trim();
    }
    if (label.length > 40) return label.substring(0, 40).trim();
    return label.isEmpty ? 'Malé vítězství' : label;
  }

  Future<RealityCheckAiResponse> generateRealityCheck({
    required Goal goal,
    required List<DailyCheckIn> checkIns,
  }) async {
    final journalText = checkIns.isEmpty
        ? 'No check-ins yet.'
        : checkIns
            .map(
              (c) =>
                  '- ${c.date.toIso8601String().split('T').first} (${_weekdayName(c.date)}): mood ${c.mood}/5, tasks ${c.tasksCompleted}/${c.tasksTotal}${c.note == null ? '' : ', note: ${c.note}'}${c.antiGoalSurrendered == true ? ', surrendered to anti-goal' : ''}',
            )
            .join('\n');

    final milestonesText = goal.sortedMilestones.map((m) {
      final status = m.isCompleted ? 'DONE' : 'pending';
      return '- [${m.order}] $status: ${m.title}';
    }).join('\n');

    final avgMood = checkIns.isEmpty
        ? 0
        : checkIns.map((c) => c.mood).reduce((a, b) => a + b) / checkIns.length;

    final userPrompt = '''
Goal: ${goal.title}
Original plan/description: ${goal.description}
Daily habit promised: ${goal.dailyHabit}
Days since creation: ${goal.daysSinceCreation}
Progress: ${goal.progressPercent}%
Average mood: ${avgMood.toStringAsFixed(1)}/5
Streak: ${goal.streak} days

Planned milestones:
$milestonesText

Journal & check-in history:
$journalText

Compare plan vs reality. Be specific about day-of-week patterns if visible.
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.realityCheckSystemPrompt,
      userPrompt: userPrompt,
    );
    final json = JsonUtils.parseAiJson(text);
    return RealityCheckAiResponse.fromJson(json);
  }

  Future<CrisisModeAiResponse> activateCrisisMode({required Goal goal}) async {
    final milestone = goal.currentMilestone;
    final currentTasks = goal.todayTasks
        .map((t) => '- ${t.title}')
        .join('\n');

    final userPrompt = '''
Goal: ${goal.title}
Current milestone: ${milestone?.title ?? 'Unknown'}
Streak to preserve: ${goal.streak} days
Current tasks to shrink:
${currentTasks.isEmpty ? 'No tasks — suggest generic atomic steps for the goal.' : currentTasks}

User is overwhelmed. Create atomic minimum version of today's work.
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.crisisModeSystemPrompt,
      userPrompt: userPrompt,
    );
    final json = JsonUtils.parseAiJson(text);
    return CrisisModeAiResponse.fromJson(json);
  }

  Future<String> sendRoleplayReply({
    required Goal goal,
    required String userMessage,
    required List<ChatMessage> history,
    required String characterRole,
    required String scenarioBrief,
    required String opponentPersona,
  }) async {
    final systemPrompt = '''
${ApiConstants.roleplaySystemPrompt}

Character: $characterRole
Scenario: $scenarioBrief
Persona: $opponentPersona
Goal context: ${goal.title} — milestone: ${goal.currentMilestone?.title ?? ''}
''';

    final historyText = history
        .where((m) => !m.role.name.contains('system'))
        .map((m) => '${m.role.name}: ${m.content}')
        .join('\n');

    final userPrompt = '''
Conversation so far:
$historyText

User: $userMessage
Character:''';

    return _generateWithFallback(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
    );
  }

  Future<RoleplayEvaluationResponse> evaluateRoleplay({
    required Goal goal,
    required List<ChatMessage> history,
    required String characterRole,
    required String scenarioBrief,
  }) async {
    final transcript = history
        .map((m) => '${m.role.name}: ${m.content}')
        .join('\n');

    final userPrompt = '''
Scenario: $scenarioBrief
Character played: $characterRole
Goal: ${goal.title}

Transcript:
$transcript

Evaluate the user's performance.
''';

    final text = await _generateWithFallback(
      systemPrompt: ApiConstants.roleplayEvaluationSystemPrompt,
      userPrompt: userPrompt,
    );
    final json = JsonUtils.parseAiJson(text);
    return RoleplayEvaluationResponse.fromJson(json);
  }

  String _weekdayName(DateTime date) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[date.weekday - 1];
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

    final friction = goal.activeFrictionPoint;
    if (friction != null) {
      buffer.writeln('Active friction warning: ${friction.warning}');
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
