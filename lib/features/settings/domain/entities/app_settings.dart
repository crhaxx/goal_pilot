import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.notificationsEnabled = true,
    this.dailyFuelNotificationsEnabled = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.journalDayStartHour = 20,
    this.journalDayStartMinute = 0,
    this.themeMode = ThemeMode.system,
    this.localeCode,
  });

  final bool notificationsEnabled;
  final bool dailyFuelNotificationsEnabled;
  final int reminderHour;
  final int reminderMinute;
  final int journalDayStartHour;
  final int journalDayStartMinute;
  final ThemeMode themeMode;
  final String? localeCode;

  bool get hasLocale => localeCode != null && localeCode!.isNotEmpty;

  TimeOfDay get reminderTime => TimeOfDay(
        hour: reminderHour,
        minute: reminderMinute,
      );

  TimeOfDay get journalDayStartTime => TimeOfDay(
        hour: journalDayStartHour,
        minute: journalDayStartMinute,
      );

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? dailyFuelNotificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
    int? journalDayStartHour,
    int? journalDayStartMinute,
    ThemeMode? themeMode,
    String? localeCode,
    bool clearLocaleCode = false,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyFuelNotificationsEnabled:
          dailyFuelNotificationsEnabled ?? this.dailyFuelNotificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      journalDayStartHour: journalDayStartHour ?? this.journalDayStartHour,
      journalDayStartMinute:
          journalDayStartMinute ?? this.journalDayStartMinute,
      themeMode: themeMode ?? this.themeMode,
      localeCode: clearLocaleCode ? null : (localeCode ?? this.localeCode),
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationsEnabled': notificationsEnabled,
        'dailyFuelNotificationsEnabled': dailyFuelNotificationsEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'journalDayStartHour': journalDayStartHour,
        'journalDayStartMinute': journalDayStartMinute,
        'themeMode': themeMode.name,
        if (localeCode != null) 'localeCode': localeCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String? ?? ThemeMode.system.name;
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyFuelNotificationsEnabled:
          json['dailyFuelNotificationsEnabled'] as bool? ?? true,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 20,
      reminderMinute: (json['reminderMinute'] as num?)?.toInt() ?? 0,
      journalDayStartHour: (json['journalDayStartHour'] as num?)?.toInt() ?? 20,
      journalDayStartMinute:
          (json['journalDayStartMinute'] as num?)?.toInt() ?? 0,
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      ),
      localeCode: json['localeCode'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        dailyFuelNotificationsEnabled,
        reminderHour,
        reminderMinute,
        journalDayStartHour,
        journalDayStartMinute,
        themeMode,
        localeCode,
      ];
}
