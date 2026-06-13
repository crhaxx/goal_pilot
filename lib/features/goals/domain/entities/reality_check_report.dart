import 'package:equatable/equatable.dart';

/// AI-generated plan-vs-reality analysis unlocked after 14 days of usage.
class RealityCheckReport extends Equatable {
  const RealityCheckReport({
    required this.insight,
    required this.recommendations,
    required this.generatedAt,
  });

  final String insight;
  final List<String> recommendations;
  final DateTime generatedAt;

  @override
  List<Object?> get props => [insight, recommendations, generatedAt];
}
