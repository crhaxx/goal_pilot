import 'package:goal_pilot/core/services/personalization_prompt_builder.dart';
import 'package:goal_pilot/features/personalization/domain/repositories/personalization_repository.dart';

/// Resolves the user's personalization prompt block for Gemini calls.
class PersonalizationResolver {
  const PersonalizationResolver(this._repository);

  final PersonalizationRepository _repository;

  Future<String?> resolvePromptBlock() async {
    final personalization = await _repository.getPersonalization();
    return PersonalizationPromptBuilder.build(personalization);
  }
}
