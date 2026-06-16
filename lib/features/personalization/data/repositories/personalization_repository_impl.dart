import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/core/error/failures.dart';
import 'package:goal_pilot/features/personalization/data/datasources/personalization_local_datasource.dart';
import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';
import 'package:goal_pilot/features/personalization/domain/repositories/personalization_repository.dart';

class PersonalizationRepositoryImpl implements PersonalizationRepository {
  PersonalizationRepositoryImpl(this._local);

  final PersonalizationLocalDataSource _local;

  @override
  Future<UserPersonalization> getPersonalization() async {
    try {
      return await _local.getPersonalization();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<UserPersonalization> savePersonalization(
    UserPersonalization personalization,
  ) async {
    try {
      return await _local.savePersonalization(personalization);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> clearPersonalization() async {
    try {
      await _local.clearPersonalization();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
