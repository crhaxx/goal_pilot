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
  GeminiRemoteDataSource({List<String>? models})
      : _models = models ?? EnvConfig.geminiModels;

  final List<String> _models;

  /// Lightweight call to verify that an API key is valid.
  Future<void> validateApiKey(String apiKey) async {
    await _generateWithModel(
      apiKey: apiKey,
      modelName: _models.first,
      systemPrompt: 'Reply with exactly: OK',
      userPrompt: 'ping',
    );
  }

  Future<GoalDecompositionResponse> decomposeGoal(
    String userPrompt, {
    required String apiKey,
    String? schedulePromptLine,
    String? personalizationBlock,
  }) async {
    final buffer = StringBuffer(userPrompt.trim());
    if (schedulePromptLine != null && schedulePromptLine.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln('Schedule context: ${schedulePromptLine.trim()}');
    }

    final text = await _generateWithFallback(
      apiKey: apiKey,
      systemPrompt: ApiConstants.goalDecompositionSystemPrompt,
      userPrompt: buffer.toString(),
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return GoalDecompositionResponse.fromJson(json);
  }

  Future<CheckInAiResponse> generateCheckInMessage({
    required String apiKey,
    required Goal goal,
    required int mood,
    String? note,
    required int tasksCompleted,
    required int tasksTotal,
    bool? antiGoalSurrendered,
    String? antiGoalTitle,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.checkInSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );

    try {
      final json = JsonUtils.parseAiJson(text);
      return CheckInAiResponse.fromJson(json);
    } on ParseException {
      return CheckInAiResponse(pilotMessage: text);
    }
  }

  Future<MotivationBundleResponse> generateMotivationBundle({
    required String apiKey,
    required List<Goal> goals,
    required List<DailyCheckIn> recentCheckIns,
    required String localeCode,
    String? personalizationBlock,
  }) async {
    final goalsText = goals.map((goal) {
      final milestone = goal.currentMilestone;
      return '''
- ${goal.title}: ${goal.progressPercent}% progress, ${goal.streak}-day streak, checked in today: ${goal.hasCheckedInToday}, needs check-in: ${goal.needsCheckInToday}, milestone: ${milestone?.title ?? 'completed'}, daily habit: ${goal.dailyHabit.isEmpty ? 'none' : goal.dailyHabit}
''';
    }).join();

    final checkInsText = recentCheckIns.isEmpty
        ? 'No recent check-ins.'
        : recentCheckIns
            .take(10)
            .map(
              (c) =>
                  '- ${c.date.toIso8601String().split('T').first}: mood ${c.mood}/5, tasks ${c.tasksCompleted}/${c.tasksTotal}${c.note == null || c.note!.trim().isEmpty ? '' : ', journal: ${c.note!.trim()}'}',
            )
            .join('\n');

    final userPrompt = '''
User locale: $localeCode
Today: ${DateTime.now().toIso8601String().split('T').first}

Goals:
$goalsText

Recent check-ins (newest context):
$checkInsText
''';

    final text = await _generateWithFallback(
      apiKey: apiKey,
      systemPrompt: ApiConstants.motivationSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );

    try {
      final json = JsonUtils.parseAiJson(text);
      return MotivationBundleResponse.fromJson(json);
    } on ParseException {
      return MotivationBundleResponse(contextualSlogan: text.trim());
    }
  }

  Future<String> sendCoachReply({
    required String apiKey,
    required Goal goal,
    required String userMessage,
    required List<ChatMessage> history,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.coachSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
  }

  Future<WeeklyReviewResponse> generateWeeklyReview({
    required String apiKey,
    required List<Goal> goals,
    required List<DailyCheckIn> checkIns,
    required String localeCode,
    String? personalizationBlock,
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
User locale: $localeCode

Weekly data for review:

Goals:
$goalsText

Check-ins (last 7 days):
$checkInsText
''';

    final text = await _generateWithFallback(
      apiKey: apiKey,
      systemPrompt: ApiConstants.weeklyReviewSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return WeeklyReviewResponse.fromJson(json);
  }

  Future<GoalPivotResponse> pivotGoal({
    required String apiKey,
    required Goal goal,
    required List<DailyCheckIn> checkIns,
    required String reason,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.pivotGoalSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return GoalPivotResponse.fromJson(json);
  }

  Future<ExtendMilestonesResponse> generateMoreMilestones({
    required String apiKey,
    required Goal goal,
    required List<DailyCheckIn> checkIns,
    String? personalizationBlock,
  }) async {
    final completedText = goal.sortedMilestones.map((m) {
      return '- [${m.order}] ${m.title}${m.description != null ? ': ${m.description}' : ''}';
    }).join('\n');

    final journalText = checkIns.isEmpty
        ? 'No check-ins yet.'
        : checkIns
            .take(14)
            .map(
              (c) =>
                  '- ${c.date.toIso8601String().split('T').first}: mood ${c.mood}/5, tasks ${c.tasksCompleted}/${c.tasksTotal}${c.note == null ? '' : ', note: ${c.note}'}',
            )
            .join('\n');

    final userPrompt = '''
Goal: ${goal.title}
Original description: ${goal.description}
Daily habit: ${goal.dailyHabit}
Streak: ${goal.streak} days
Progress: all ${goal.totalMilestones} milestones completed

Completed milestones:
$completedText

Journal (recent check-ins):
$journalText

Generate the next phase of milestones that continue this journey.
''';

    final text = await _generateWithFallback(
      apiKey: apiKey,
      systemPrompt: ApiConstants.extendMilestonesSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return ExtendMilestonesResponse.fromJson(json);
  }

  Future<String> extractWinLabel({
    required String apiKey,
    required String goalTitle,
    required String context,
    String? personalizationBlock,
  }) async {
    final userPrompt = '''
Goal: $goalTitle
Accomplishment context: $context
''';

    final text = await _generateWithFallback(
      apiKey: apiKey,
      systemPrompt: ApiConstants.winLabelSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
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
    required String apiKey,
    required Goal goal,
    required List<DailyCheckIn> checkIns,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.realityCheckSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return RealityCheckAiResponse.fromJson(json);
  }

  Future<CrisisModeAiResponse> activateCrisisMode({
    required String apiKey,
    required Goal goal,
    String? personalizationBlock,
  }) async {
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.crisisModeSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
    final json = JsonUtils.parseAiJson(text);
    return CrisisModeAiResponse.fromJson(json);
  }

  Future<String> sendRoleplayReply({
    required String apiKey,
    required Goal goal,
    required String userMessage,
    required List<ChatMessage> history,
    required String characterRole,
    required String scenarioBrief,
    required String opponentPersona,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
    );
  }

  Future<RoleplayEvaluationResponse> evaluateRoleplay({
    required String apiKey,
    required Goal goal,
    required List<ChatMessage> history,
    required String characterRole,
    required String scenarioBrief,
    String? personalizationBlock,
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
      apiKey: apiKey,
      systemPrompt: ApiConstants.roleplayEvaluationSystemPrompt,
      userPrompt: userPrompt,
      personalizationBlock: personalizationBlock,
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

  String _appendPersonalization(String userPrompt, String? block) {
    if (block == null || block.trim().isEmpty) return userPrompt;
    return '${userPrompt.trim()}\n\n${block.trim()}';
  }

  Future<String> _generateWithFallback({
    required String apiKey,
    required String systemPrompt,
    required String userPrompt,
    String? personalizationBlock,
  }) async {
    final enrichedPrompt =
        _appendPersonalization(userPrompt, personalizationBlock);
    ApiException? lastRetryableError;

    for (final modelName in _models) {
      try {
        return await _generateWithModel(
          apiKey: apiKey,
          modelName: modelName,
          systemPrompt: systemPrompt,
          userPrompt: enrichedPrompt,
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
    required String apiKey,
    required String modelName,
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
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
