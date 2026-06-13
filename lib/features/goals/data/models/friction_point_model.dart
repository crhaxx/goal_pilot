import 'package:goal_pilot/features/goals/domain/entities/friction_point.dart';

class FrictionPointModel {
  const FrictionPointModel({
    required this.milestoneOrder,
    required this.title,
    required this.warning,
    required this.tip,
  });

  final int milestoneOrder;
  final String title;
  final String warning;
  final String tip;

  factory FrictionPointModel.fromJson(Map<String, dynamic> json) {
    return FrictionPointModel(
      milestoneOrder: (json['milestoneOrder'] as num?)?.toInt() ??
          (json['milestone_order'] as num?)?.toInt() ??
          1,
      title: json['title'] as String? ?? 'Friction point',
      warning: json['warning'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'milestoneOrder': milestoneOrder,
        'title': title,
        'warning': warning,
        'tip': tip,
      };

  FrictionPoint toEntity() => FrictionPoint(
        milestoneOrder: milestoneOrder,
        title: title,
        warning: warning,
        tip: tip,
      );

  factory FrictionPointModel.fromEntity(FrictionPoint entity) {
    return FrictionPointModel(
      milestoneOrder: entity.milestoneOrder,
      title: entity.title,
      warning: entity.warning,
      tip: entity.tip,
    );
  }
}
