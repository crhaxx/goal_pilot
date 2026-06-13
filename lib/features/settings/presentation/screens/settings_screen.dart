import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showScheduleFeedback(
    BuildContext context,
    NotificationScheduleResult result,
  ) {
    if (!context.mounted) return;

    final message = result.permissionDenied
        ? 'Allow notifications in system settings, then try again.'
        : result.message ?? (result.success ? 'Reminder updated.' : 'Failed.');

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
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text(
                'Notifications',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Daily check-in reminder'),
                      subtitle: const Text(
                        'Local notification at your chosen time every day',
                      ),
                      value: settings.notificationsEnabled,
                      activeThumbColor: AppColors.cyan,
                      onChanged: (enabled) async {
                        final result =
                            await controller.setNotificationsEnabled(enabled);
                        _showScheduleFeedback(context, result);
                      },
                    ),
                    if (settings.notificationsEnabled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.schedule),
                        title: const Text('Reminder time'),
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
                        title: const Text('Test notification'),
                        subtitle: const Text(
                          'Send one now to verify everything works',
                        ),
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
                'Tip: On Xiaomi/Samsung, disable battery optimization for '
                'GoalPilot if reminders are delayed.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Appearance',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('System'),
                      value: ThemeMode.system,
                      groupValue: settings.themeMode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setThemeMode(value);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      value: ThemeMode.light,
                      groupValue: settings.themeMode,
                      activeColor: AppColors.cyan,
                      onChanged: (value) {
                        if (value != null) controller.setThemeMode(value);
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
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
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(AppConfig.appName),
                      subtitle: Text('Version ${AppConfig.version}'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.psychology_outlined),
                      title: const Text('Powered by Gemini AI'),
                      subtitle: const Text(
                        'Goal decomposition, coaching & reviews',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
