import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';

abstract class PersonalizationRepository {
  Future<UserPersonalization> getPersonalization();

  Future<UserPersonalization> savePersonalization(
    UserPersonalization personalization,
  );

  Future<void> clearPersonalization();
}
