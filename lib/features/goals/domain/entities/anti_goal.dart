import 'package:equatable/equatable.dart';

/// A predicted self-sabotage pattern generated at goal creation.
class AntiGoal extends Equatable {
  const AntiGoal({
    required this.title,
    required this.trigger,
    required this.consequence,
  });

  final String title;
  final String trigger;
  final String consequence;

  @override
  List<Object?> get props => [title, trigger, consequence];
}
