import 'package:equatable/equatable.dart';

/// Interactive practice scenario tied to a milestone.
class RoleplayScenario extends Equatable {
  const RoleplayScenario({
    required this.characterRole,
    required this.scenarioBrief,
    required this.opponentPersona,
  });

  final String characterRole;
  final String scenarioBrief;
  final String opponentPersona;

  @override
  List<Object?> get props => [characterRole, scenarioBrief, opponentPersona];
}
