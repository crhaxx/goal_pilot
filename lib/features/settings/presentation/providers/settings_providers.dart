import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:goal_pilot/features/settings/domain/entities/app_settings.dart';

final settingsLocalDataSourceProvider =
    FutureProvider<SettingsLocalDataSource>((ref) {
  return openSettingsLocalDataSource();
});

final initialAppSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(),
);

class SettingsController extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsController(this._ref) : super(AsyncData(_ref.read(initialAppSettingsProvider))) {
    _load();
  }

  final Ref _ref;

  Future<NotificationScheduleResult?> _load() async {
    try {
      final dataSource = await _ref.read(settingsLocalDataSourceProvider.future);
      final settings = await dataSource.getSettings();
      state = AsyncData(settings);
      if (settings.hasLocale) {
        return NotificationService.instance.applySettings(
          settings,
          l10n: l10nForLocale(settings.localeCode!),
        );
      }
      return null;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  AppLocalizations _l10nFor(AppSettings settings) {
    final code = settings.localeCode ?? 'en';
    return l10nForLocale(code);
  }

  Future<NotificationScheduleResult> updateSettings(AppSettings settings) async {
    final dataSource = await _ref.read(settingsLocalDataSourceProvider.future);

    state = const AsyncLoading();
    try {
      final saved = await dataSource.saveSettings(settings);
      state = AsyncData(saved);
      return NotificationService.instance.applySettings(
        saved,
        l10n: _l10nFor(saved),
      );
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

  Future<NotificationScheduleResult> setLocale(String localeCode) async {
    final current = state.valueOrNull ?? const AppSettings();
    return updateSettings(current.copyWith(localeCode: localeCode));
  }

  Future<NotificationScheduleResult> sendTestNotification() {
    final current = state.valueOrNull ?? const AppSettings();
    return NotificationService.instance.showTestNotification(
      l10n: _l10nFor(current),
    );
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

final appLocaleProvider = Provider<Locale?>((ref) {
  final code = ref.watch(appSettingsProvider).localeCode;
  if (code == null || code.isEmpty) return null;
  return Locale(code);
});

final hasSelectedLocaleProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).hasLocale;
});
