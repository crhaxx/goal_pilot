import 'package:equatable/equatable.dart';

/// AI-predicted difficulty spike tied to a milestone order (week proxy).
class FrictionPoint extends Equatable {
  const FrictionPoint({
    required this.milestoneOrder,
    required this.title,
    required this.warning,
    required this.tip,
  });

  final int milestoneOrder;
  final String title;
  final String warning;
  final String tip;

  @override
  List<Object?> get props => [milestoneOrder, title, warning, tip];
}
