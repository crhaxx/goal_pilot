import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.notificationsEnabled = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.themeMode = ThemeMode.system,
    this.localeCode,
  });

  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;
  final ThemeMode themeMode;
  final String? localeCode;

  bool get hasLocale => localeCode != null && localeCode!.isNotEmpty;

  TimeOfDay get reminderTime => TimeOfDay(
        hour: reminderHour,
        minute: reminderMinute,
      );

  AppSettings copyWith({
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
    ThemeMode? themeMode,
    String? localeCode,
    bool clearLocaleCode = false,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      themeMode: themeMode ?? this.themeMode,
      localeCode: clearLocaleCode ? null : (localeCode ?? this.localeCode),
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationsEnabled': notificationsEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'themeMode': themeMode.name,
        if (localeCode != null) 'localeCode': localeCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String? ?? ThemeMode.system.name;
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 20,
      reminderMinute: (json['reminderMinute'] as num?)?.toInt() ?? 0,
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
        reminderHour,
        reminderMinute,
        themeMode,
        localeCode,
      ];
}
