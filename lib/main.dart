import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/app.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/services/home_widget_service.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:goal_pilot/features/settings/domain/entities/app_settings.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<bool> _readOnboardingCompleted() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  return Hive.box<String>(StorageConstants.preferencesBox)
          .get(StorageConstants.onboardingCompletedKey) ==
      'true';
}

Future<AppSettings> _readInitialSettings() async {
  if (!Hive.isBoxOpen(StorageConstants.preferencesBox)) {
    await Hive.openBox<String>(StorageConstants.preferencesBox);
  }
  final raw =
      Hive.box<String>(StorageConstants.preferencesBox).get(StorageConstants.settingsKey);
  if (raw == null) return const AppSettings();
  return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await NotificationService.instance.initialize();
  await HomeWidgetService.instance.initialize();
  final onboardingCompleted = await _readOnboardingCompleted();
  final initialSettings = await _readInitialSettings();

  runApp(
    ProviderScope(
      overrides: [
        onboardingCompletedProvider.overrideWith(
          (ref) => onboardingCompleted,
        ),
        initialAppSettingsProvider.overrideWith(
          (ref) => initialSettings,
        ),
      ],
      child: const GoalPilotApp(),
    ),
  );
}
