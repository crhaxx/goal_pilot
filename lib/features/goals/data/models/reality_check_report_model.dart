import 'package:goal_pilot/features/goals/domain/entities/reality_check_report.dart';

class RealityCheckReportModel {
  const RealityCheckReportModel({
    required this.insight,
    required this.recommendations,
    required this.generatedAt,
  });

  factory RealityCheckReportModel.fromJson(Map<String, dynamic> json) {
    return RealityCheckReportModel(
      insight: json['insight'] as String,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  final String insight;
  final List<String> recommendations;
  final DateTime generatedAt;

  Map<String, dynamic> toJson() => {
        'insight': insight,
        'recommendations': recommendations,
        'generatedAt': generatedAt.toIso8601String(),
      };

  factory RealityCheckReportModel.fromEntity(RealityCheckReport entity) {
    return RealityCheckReportModel(
      insight: entity.insight,
      recommendations: entity.recommendations,
      generatedAt: entity.generatedAt,
    );
  }

  RealityCheckReport toEntity() {
    return RealityCheckReport(
      insight: insight,
      recommendations: recommendations,
      generatedAt: generatedAt,
    );
  }
}
