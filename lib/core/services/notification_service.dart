import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
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
  static const _channelName = 'Daily Check-in';

  final _plugin = FlutterLocalNotificationsPlugin();
  var _initialized = false;

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
    await _ensureAndroidChannel();
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

  Future<void> _ensureAndroidChannel() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Reminders to complete your GoalPilot check-in',
      importance: Importance.high,
    );

    await androidPlugin?.createNotificationChannel(channel);
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

  Future<NotificationScheduleResult> applySettings(AppSettings settings) async {
    try {
      await initialize();
      await _plugin.cancel(StorageConstants.dailyCheckInNotificationId);

      if (!settings.notificationsEnabled) {
        return const NotificationScheduleResult(success: true);
      }

      final granted = await _ensurePermissions();
      if (!granted) {
        return const NotificationScheduleResult(
          success: false,
          permissionDenied: true,
          message: 'Notification permission was denied.',
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

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Reminders to complete your GoalPilot check-in',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();

      await _plugin.zonedSchedule(
        StorageConstants.dailyCheckInNotificationId,
        'Time for your check-in',
        'Open GoalPilot and tell Pilot how your goals are going today.',
        scheduled,
        const NotificationDetails(android: androidDetails, iOS: iosDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      return NotificationScheduleResult(
        success: true,
        message: 'Reminder set for '
            '${settings.reminderHour.toString().padLeft(2, '0')}:'
            '${settings.reminderMinute.toString().padLeft(2, '0')}.',
      );
    } catch (error) {
      return NotificationScheduleResult(
        success: false,
        message: 'Could not schedule reminder: $error',
      );
    }
  }

  /// Fires immediately — useful to verify notifications work on this device.
  Future<NotificationScheduleResult> showTestNotification() async {
    try {
      await initialize();

      final granted = await _ensurePermissions();
      if (!granted) {
        return const NotificationScheduleResult(
          success: false,
          permissionDenied: true,
          message: 'Notification permission was denied.',
        );
      }

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Reminders to complete your GoalPilot check-in',
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.show(
        9999,
        'GoalPilot test',
        'Notifications are working. Your daily reminder is scheduled.',
        const NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
        ),
      );

      return const NotificationScheduleResult(
        success: true,
        message: 'Test notification sent.',
      );
    } catch (error) {
      return NotificationScheduleResult(
        success: false,
        message: 'Test failed: $error',
      );
    }
  }
}
