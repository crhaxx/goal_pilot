import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/settings/domain/entities/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduleResult {
  const NotificationScheduleResult({
    required this.success,
    this.permissionDenied = false,
    this.message,
  });

  final bool success;
  final bool permissionDenied;
  final String? message;
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const _channelId = 'daily_check_in';
  static const _smartChannelId = 'smart_alerts';
  static const _dailyFuelChannelId = 'daily_fuel';
  static const _personalTaskChannelId = 'personal_tasks';

  final _plugin = FlutterLocalNotificationsPlugin();
  var _initialized = false;
  var _notificationsEnabled = true;
  var _dailyFuelNotificationsEnabled = true;
  var _reminderHour = 20;
  var _reminderMinute = 0;
  AppLocalizations? _l10n;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Europe/Prague'));
    }
  }

  Future<void> _ensureAndroidChannel(AppLocalizations l10n) async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final channel = AndroidNotificationChannel(
      _channelId,
      l10n.notifChannelDaily,
      description: l10n.notifChannelDailyDesc,
      importance: Importance.high,
    );

    await androidPlugin?.createNotificationChannel(channel);

    final smartChannel = AndroidNotificationChannel(
      _smartChannelId,
      l10n.notifChannelSmart,
      description: l10n.notifChannelSmartDesc,
      importance: Importance.high,
    );
    await androidPlugin?.createNotificationChannel(smartChannel);

    final dailyFuelChannel = AndroidNotificationChannel(
      _dailyFuelChannelId,
      l10n.notifChannelDailyFuel,
      description: l10n.notifChannelDailyFuelDesc,
      importance: Importance.high,
    );
    await androidPlugin?.createNotificationChannel(dailyFuelChannel);

    final personalTaskChannel = AndroidNotificationChannel(
      _personalTaskChannelId,
      l10n.notifChannelPersonalTask,
      description: l10n.notifChannelPersonalTaskDesc,
      importance: Importance.high,
    );
    await androidPlugin?.createNotificationChannel(personalTaskChannel);
  }

  Future<bool> _ensurePermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final notificationGranted =
          await androidPlugin?.requestNotificationsPermission() ?? true;
      if (notificationGranted == false) return false;

      await androidPlugin?.requestExactAlarmsPermission();
      final notificationStatus = await Permission.notification.status;
      return notificationStatus.isGranted;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<NotificationScheduleResult> applySettings(
    AppSettings settings, {
    required AppLocalizations l10n,
    List<Goal>? goals,
  }) async {
    _l10n = l10n;
    _reminderHour = settings.reminderHour;
    _reminderMinute = settings.reminderMinute;
    try {
      await initialize();
      await _ensureAndroidChannel(l10n);
      await _cancelDailyReminderSlots();
      await _plugin.cancel(StorageConstants.dailyCheckInNotificationId);
      await _plugin.cancel(StorageConstants.dailyFuelNotificationId);

      _notificationsEnabled = settings.notificationsEnabled;
      _dailyFuelNotificationsEnabled = settings.dailyFuelNotificationsEnabled;

      if (!settings.notificationsEnabled) {
        return const NotificationScheduleResult(success: true);
      }

      final granted = await _ensurePermissions();
      if (!granted) {
        return NotificationScheduleResult(
          success: false,
          permissionDenied: true,
          message: l10n.notifPermissionDenied,
        );
      }

      await rescheduleDailyRemindersForGoals(
        goals: goals ?? const [],
        l10n: l10n,
        reminderHour: settings.reminderHour,
        reminderMinute: settings.reminderMinute,
      );

      final time = '${settings.reminderHour.toString().padLeft(2, '0')}:'
          '${settings.reminderMinute.toString().padLeft(2, '0')}';

      return NotificationScheduleResult(
        success: true,
        message: l10n.notifReminderSet(time),
      );
    } catch (error) {
      return NotificationScheduleResult(
        success: false,
        message: l10n.notifScheduleFailed('$error'),
      );
    }
  }

  Future<void> rescheduleDailyRemindersForGoals({
    required List<Goal> goals,
    required AppLocalizations l10n,
    int? reminderHour,
    int? reminderMinute,
  }) async {
    if (!_notificationsEnabled) return;

    _l10n = l10n;
    final hour = reminderHour ?? _reminderHour;
    final minute = reminderMinute ?? _reminderMinute;

    try {
      await initialize();
      await _ensureAndroidChannel(l10n);
      await _cancelDailyReminderSlots();

      final granted = await _ensurePermissions();
      if (!granted) return;

      final now = tz.TZDateTime.now(tz.local);
      final androidDetails = AndroidNotificationDetails(
        _channelId,
        l10n.notifChannelDaily,
        channelDescription: l10n.notifChannelDailyDesc,
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();

      for (var offset = 0;
          offset < StorageConstants.dailyReminderDaysAhead;
          offset++) {
        final day = DateUtils.dateOnly(
          DateTime.now().add(Duration(days: offset)),
        );
        final hasDueGoal = goals.isEmpty
            ? true
            : GoalScheduleUtils.anyGoalActiveOn(day, goals);
        if (!hasDueGoal) continue;

        var scheduled = tz.TZDateTime(
          tz.local,
          day.year,
          day.month,
          day.day,
          hour,
          minute,
        );
        if (!scheduled.isAfter(now)) continue;

        await _plugin.zonedSchedule(
          StorageConstants.dailyReminderSlotBaseId + offset,
          l10n.notifCheckInTitle,
          l10n.notifCheckInBody,
          scheduled,
          NotificationDetails(android: androidDetails, iOS: iosDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (_) {
      // Daily reminder rescheduling is best-effort.
    }
  }

  Future<void> _cancelDailyReminderSlots() async {
    for (var i = 0; i < StorageConstants.dailyReminderDaysAhead; i++) {
      await _plugin.cancel(StorageConstants.dailyReminderSlotBaseId + i);
    }
  }

  Future<NotificationScheduleResult> showTestNotification({
    required AppLocalizations l10n,
  }) async {
    _l10n = l10n;
    try {
      await initialize();
      await _ensureAndroidChannel(l10n);

      final granted = await _ensurePermissions();
      if (!granted) {
        return NotificationScheduleResult(
          success: false,
          permissionDenied: true,
          message: l10n.notifPermissionDenied,
        );
      }

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        l10n.notifChannelDaily,
        channelDescription: l10n.notifChannelDailyDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.show(
        9999,
        l10n.notifTestTitle,
        l10n.notifTestBody,
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
        ),
      );

      return NotificationScheduleResult(
        success: true,
        message: l10n.notifTestSent,
      );
    } catch (error) {
      return NotificationScheduleResult(
        success: false,
        message: l10n.notifTestFailed('$error'),
      );
    }
  }

  Future<void> scheduleSmartAlert({
    required String message,
    required int hour,
    required int minute,
  }) async {
    if (!_notificationsEnabled) return;
    final l10n = _l10n ?? l10nForLocale('en');
    try {
      await initialize();
      await _ensureAndroidChannel(l10n);
      await _plugin.cancel(StorageConstants.smartAlertNotificationId);

      final granted = await _ensurePermissions();
      if (!granted) return;

      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).add(const Duration(days: 1));

      final androidDetails = AndroidNotificationDetails(
        _smartChannelId,
        l10n.notifChannelSmart,
        channelDescription: l10n.notifChannelSmartDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.zonedSchedule(
        StorageConstants.smartAlertNotificationId,
        l10n.notifPilotTitle,
        message,
        scheduled,
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Smart alerts are best-effort.
    }
  }

  Future<void> scheduleDailyFuel({
    required String message,
    required DateTime targetDate,
    AppLocalizations? l10n,
    List<Goal>? goals,
  }) async {
    if (!_notificationsEnabled || !_dailyFuelNotificationsEnabled) return;
    final resolvedL10n = l10n ?? _l10n ?? l10nForLocale('en');
    _l10n = resolvedL10n;
    try {
      await initialize();
      await _ensureAndroidChannel(resolvedL10n);
      await _plugin.cancel(StorageConstants.dailyFuelNotificationId);

      final granted = await _ensurePermissions();
      if (!granted) return;

      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      final day = DateUtils.dateOnly(targetDate);
      if (goals != null &&
          goals.isNotEmpty &&
          !GoalScheduleUtils.anyGoalActiveOn(day, goals)) {
        return;
      }

      final body = trimmed.length > 160 ? trimmed.substring(0, 160) : trimmed;
      final scheduled = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        StorageConstants.dailyFuelHour,
        StorageConstants.dailyFuelMinute,
      );

      final now = tz.TZDateTime.now(tz.local);
      if (!scheduled.isAfter(now)) return;

      final androidDetails = AndroidNotificationDetails(
        _dailyFuelChannelId,
        resolvedL10n.notifChannelDailyFuel,
        channelDescription: resolvedL10n.notifChannelDailyFuelDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.zonedSchedule(
        StorageConstants.dailyFuelNotificationId,
        resolvedL10n.notifDailyFuelTitle,
        body,
        scheduled,
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Daily fuel alerts are best-effort.
    }
  }

  Future<void> schedulePersonalTaskReminder({
    required int notificationId,
    required String title,
    required DateTime scheduledAt,
    required AppLocalizations l10n,
  }) async {
    if (!_notificationsEnabled) return;
    _l10n = l10n;
    try {
      await initialize();
      await _ensureAndroidChannel(l10n);

      final granted = await _ensurePermissions();
      if (!granted) return;

      final trimmed = title.trim();
      if (trimmed.isEmpty) return;

      final scheduled = tz.TZDateTime(
        tz.local,
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
        scheduledAt.hour,
        scheduledAt.minute,
      );

      final now = tz.TZDateTime.now(tz.local);
      if (!scheduled.isAfter(now)) return;

      final androidDetails = AndroidNotificationDetails(
        _personalTaskChannelId,
        l10n.notifChannelPersonalTask,
        channelDescription: l10n.notifChannelPersonalTaskDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.zonedSchedule(
        notificationId,
        l10n.notifPersonalTaskTitle,
        trimmed,
        scheduled,
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Personal task reminders are best-effort.
    }
  }

  Future<void> cancelPersonalTaskReminder({required int notificationId}) async {
    try {
      await initialize();
      await _plugin.cancel(notificationId);
    } catch (_) {
      // Cancellation is best-effort.
    }
  }
}
