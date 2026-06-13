import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/settings/domain/entities/app_settings.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._box);

  final Box<String> _box;

  Future<AppSettings> getSettings() async {
    try {
      final raw = _box.get(StorageConstants.settingsKey);
      if (raw == null) return const AppSettings();
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException('Could not read settings.', cause: e);
    }
  }

  Future<AppSettings> saveSettings(AppSettings settings) async {
    try {
      await _box.put(StorageConstants.settingsKey, jsonEncode(settings.toJson()));
      return settings;
    } catch (e) {
      throw CacheException('Could not save settings.', cause: e);
    }
  }
}

Future<SettingsLocalDataSource> openSettingsLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  return SettingsLocalDataSource(Hive.box<String>(StorageConstants.preferencesBox));
}
