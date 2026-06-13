class CheckInAiResponse {
  const CheckInAiResponse({
    required this.pilotMessage,
    this.smartAlertText,
  });

  factory CheckInAiResponse.fromJson(Map<String, dynamic> json) {
    return CheckInAiResponse(
      pilotMessage: json['pilotMessage'] as String? ??
          json['message'] as String? ??
          '',
      smartAlertText: json['smartAlertText'] as String? ??
          json['smart_alert_text'] as String?,
    );
  }

  final String pilotMessage;
  final String? smartAlertText;
}

class GoalPivotResponse {
  const GoalPivotResponse({
    required this.summary,
    required this.dailyHabit,
    required this.milestones,
    required this.motivationalTips,
  });

  factory GoalPivotResponse.fromJson(Map<String, dynamic> json) {
    final rawMilestones = json['milestones'] as List<dynamic>? ?? [];
    return GoalPivotResponse(
      summary: json['summary'] as String? ?? '',
      dailyHabit: json['dailyHabit'] as String? ?? '',
      motivationalTips: json['motivationalTips'] as String? ?? '',
      milestones: rawMilestones
          .map((e) => PivotMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String summary;
  final String dailyHabit;
  final String motivationalTips;
  final List<PivotMilestone> milestones;
}

class PivotMilestone {
  const PivotMilestone({
    required this.title,
    required this.order,
    this.description,
    this.actionSteps = const [],
    this.preserveExisting = false,
  });

  factory PivotMilestone.fromJson(Map<String, dynamic> json) {
    return PivotMilestone(
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      description: json['description'] as String?,
      preserveExisting: json['preserveExisting'] as bool? ?? false,
      actionSteps: (json['actionSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  final String title;
  final String? description;
  final int order;
  final List<String> actionSteps;
  final bool preserveExisting;
}

class RealityCheckAiResponse {
  const RealityCheckAiResponse({
    required this.insight,
    required this.recommendations,
  });

  factory RealityCheckAiResponse.fromJson(Map<String, dynamic> json) {
    return RealityCheckAiResponse(
      insight: json['insight'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  final String insight;
  final List<String> recommendations;
}

class CrisisModeAiResponse {
  const CrisisModeAiResponse({
    required this.crisisMessage,
    required this.atomicTasks,
  });

  factory CrisisModeAiResponse.fromJson(Map<String, dynamic> json) {
    return CrisisModeAiResponse(
      crisisMessage: json['crisisMessage'] as String? ?? '',
      atomicTasks: (json['atomicTasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  final String crisisMessage;
  final List<String> atomicTasks;
}

class RoleplayEvaluationResponse {
  const RoleplayEvaluationResponse({
    required this.score,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.improvements,
  });

  factory RoleplayEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return RoleplayEvaluationResponse(
      score: (json['score'] as num?)?.toInt() ?? 0,
      summary: json['summary'] as String? ?? '',
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      weaknesses: (json['weaknesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  final int score;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> improvements;
}
