import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:goal_pilot/features/settings/domain/entities/app_settings.dart';

final settingsLocalDataSourceProvider =
    FutureProvider<SettingsLocalDataSource>((ref) {
  return openSettingsLocalDataSource();
});

class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController(this._ref) : super(const AsyncLoading()) {
    _load();
  }

  final Ref _ref;

  Future<NotificationScheduleResult?> _load() async {
    try {
      final dataSource = await _ref.read(settingsLocalDataSourceProvider.future);
      final settings = await dataSource.getSettings();
      state = AsyncData(settings);
      return NotificationService.instance.applySettings(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<NotificationScheduleResult> updateSettings(AppSettings settings) async {
    final dataSource = await _ref.read(settingsLocalDataSourceProvider.future);

    state = const AsyncLoading();
    try {
      final saved = await dataSource.saveSettings(settings);
      state = AsyncData(saved);
      return NotificationService.instance.applySettings(saved);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<NotificationScheduleResult> setNotificationsEnabled(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    return updateSettings(current.copyWith(notificationsEnabled: enabled));
  }

  Future<NotificationScheduleResult> setReminderTime(int hour, int minute) async {
    final current = state.valueOrNull ?? const AppSettings();
    return updateSettings(
      current.copyWith(reminderHour: hour, reminderMinute: minute),
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(themeMode: themeMode));
  }

  Future<NotificationScheduleResult> sendTestNotification() {
    return NotificationService.instance.showTestNotification();
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>((ref) {
  return SettingsController(ref);
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsControllerProvider).maybeWhen(
        data: (settings) => settings.themeMode,
        orElse: () => ThemeMode.system,
      );
});

final appSettingsProvider = Provider<AppSettings>((ref) {
  return ref.watch(settingsControllerProvider).maybeWhen(
        data: (settings) => settings,
        orElse: () => const AppSettings(),
      );
});
