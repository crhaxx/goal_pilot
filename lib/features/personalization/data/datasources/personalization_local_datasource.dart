import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';

class PersonalizationLocalDataSource {
  PersonalizationLocalDataSource(this._box);

  final Box<String> _box;

  Future<UserPersonalization> getPersonalization() async {
    try {
      final raw = _box.get(StorageConstants.personalizationKey);
      if (raw == null) return const UserPersonalization();
      return UserPersonalization.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Could not read personalization.', cause: e);
    }
  }

  Future<UserPersonalization> savePersonalization(
    UserPersonalization personalization,
  ) async {
    try {
      await _box.put(
        StorageConstants.personalizationKey,
        jsonEncode(personalization.toJson()),
      );
      return personalization;
    } catch (e) {
      throw CacheException('Could not save personalization.', cause: e);
    }
  }

  Future<void> clearPersonalization() async {
    try {
      await _box.delete(StorageConstants.personalizationKey);
    } catch (e) {
      throw CacheException('Could not clear personalization.', cause: e);
    }
  }
}

Future<PersonalizationLocalDataSource> openPersonalizationLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  return PersonalizationLocalDataSource(
    Hive.box<String>(StorageConstants.preferencesBox),
  );
}
