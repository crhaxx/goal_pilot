import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';
import 'package:goal_pilot/features/settings/presentation/widgets/settings_about_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showScheduleFeedback(
    BuildContext context,
    NotificationScheduleResult result,
  ) {
    if (!context.mounted) return;

    final l10n = context.l10n;
    final message = result.message ??
        (result.permissionDenied
            ? l10n.notificationPermissionDenied
            : (result.success ? l10n.reminderUpdated : l10n.failed));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            result.success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorPrefix('$error'))),
        data: (settings) {
          final localeCode = settings.localeCode ?? 'en';

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text(
                l10n.settingsNotifications,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(l10n.settingsDailyReminder),
                      subtitle: Text(l10n.settingsDailyReminderDesc),
                      value: settings.notificationsEnabled,
                      activeThumbColor: AppColors.cyan,
                      onChanged: (enabled) async {
                        final result =
                            await controller.setNotificationsEnabled(enabled);
                        _showScheduleFeedback(context, result);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text(l10n.settingsDailyFuelReminder),
                      subtitle: Text(l10n.settingsDailyFuelReminderDesc),
                      value: settings.dailyFuelNotificationsEnabled &&
                          settings.notificationsEnabled,
                      activeThumbColor: AppColors.cyan,
                      onChanged: settings.notificationsEnabled
                          ? (enabled) async {
                              final result = await controller
                                  .setDailyFuelNotificationsEnabled(enabled);
                              _showScheduleFeedback(context, result);
                            }
                          : null,
                    ),
                    if (settings.notificationsEnabled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(l10n.settingsReminderTime),
                        subtitle: Text(
                          MaterialLocalizations.of(context).formatTimeOfDay(
                            TimeOfDay(
                              hour: settings.reminderHour,
                              minute: settings.reminderMinute,
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: settings.reminderTime,
                          );
                          if (picked == null || !context.mounted) return;

                          final result = await controller.setReminderTime(
                            picked.hour,
                            picked.minute,
                          );
                          _showScheduleFeedback(context, result);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_active_outlined),
                        title: Text(l10n.settingsTestNotification),
                        subtitle: Text(l10n.settingsTestNotificationDesc),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final result =
                              await controller.sendTestNotification();
                          _showScheduleFeedback(context, result);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.settingsBatteryTip,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.settingsAppearance,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.settingsThemeSystem),
                      value: ThemeMode.system,
                      groupValue: settings.themeMode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setThemeMode(value);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.settingsThemeLight),
                      value: ThemeMode.light,
                      groupValue: settings.themeMode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setThemeMode(value);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.settingsThemeDark),
                      value: ThemeMode.dark,
                      groupValue: settings.themeMode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setThemeMode(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.settingsLanguage,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(l10n.languageEnglish),
                      value: 'en',
                      groupValue: localeCode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setLocale(value);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: Text(l10n.languageCzech),
                      value: 'cs',
                      groupValue: localeCode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setLocale(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.settingsAbout,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const SettingsAboutSection(),
            ],
          );
        },
      ),
    );
  }
}
