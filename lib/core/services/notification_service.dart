import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
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

  final _plugin = FlutterLocalNotificationsPlugin();
  var _initialized = false;
  var _notificationsEnabled = true;
  AppLocalizations? _l10n;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
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
  }) async {
    _l10n = l10n;
    try {
      await initialize();
      await _ensureAndroidChannel(l10n);
      await _plugin.cancel(StorageConstants.dailyCheckInNotificationId);

      _notificationsEnabled = settings.notificationsEnabled;

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

      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.reminderHour,
        settings.reminderMinute,
      );

      if (!scheduled.isAfter(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final time = '${settings.reminderHour.toString().padLeft(2, '0')}:'
          '${settings.reminderMinute.toString().padLeft(2, '0')}';

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        l10n.notifChannelDaily,
        channelDescription: l10n.notifChannelDailyDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();

      await _plugin.zonedSchedule(
        StorageConstants.dailyCheckInNotificationId,
        l10n.notifCheckInTitle,
        l10n.notifCheckInBody,
        scheduled,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

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
}
