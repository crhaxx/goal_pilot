import 'package:goal_pilot/features/goals/domain/entities/roleplay_scenario.dart';

class RoleplayScenarioModel {
  const RoleplayScenarioModel({
    required this.characterRole,
    required this.scenarioBrief,
    required this.opponentPersona,
  });

  factory RoleplayScenarioModel.fromJson(Map<String, dynamic> json) {
    return RoleplayScenarioModel(
      characterRole: json['characterRole'] as String? ??
          json['character_role'] as String? ??
          '',
      scenarioBrief: json['scenarioBrief'] as String? ??
          json['scenario_brief'] as String? ??
          '',
      opponentPersona: json['opponentPersona'] as String? ??
          json['opponent_persona'] as String? ??
          '',
    );
  }

  final String characterRole;
  final String scenarioBrief;
  final String opponentPersona;

  Map<String, dynamic> toJson() => {
        'characterRole': characterRole,
        'scenarioBrief': scenarioBrief,
        'opponentPersona': opponentPersona,
      };

  factory RoleplayScenarioModel.fromEntity(RoleplayScenario entity) {
    return RoleplayScenarioModel(
      characterRole: entity.characterRole,
      scenarioBrief: entity.scenarioBrief,
      opponentPersona: entity.opponentPersona,
    );
  }

  RoleplayScenario toEntity() {
    return RoleplayScenario(
      characterRole: characterRole,
      scenarioBrief: scenarioBrief,
      opponentPersona: opponentPersona,
    );
  }

  bool get isValid =>
      characterRole.isNotEmpty &&
      scenarioBrief.isNotEmpty &&
      opponentPersona.isNotEmpty;
}
