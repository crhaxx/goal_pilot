import 'package:goal_pilot/core/config/env_config.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/constants/home_widget_constants.dart';
import 'package:goal_pilot/core/services/home_widget_service.dart';
import 'package:goal_pilot/core/services/notification_service.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:goal_pilot/features/goals/data/datasources/gemini_remote_datasource.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/home/data/datasources/motivation_local_datasource.dart';
import 'package:goal_pilot/features/home/data/services/motivation_context_builder.dart';
import 'package:goal_pilot/features/home/data/services/motivation_fallbacks.dart';
import 'package:goal_pilot/features/home/domain/entities/motivation_snapshot.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';
import 'package:home_widget/home_widget.dart';

class MotivationRepository {
  MotivationRepository({
    required MotivationLocalDataSource localDataSource,
    required GeminiRemoteDataSource geminiDataSource,
  })  : _local = localDataSource,
        _gemini = geminiDataSource;

  final MotivationLocalDataSource _local;
  final GeminiRemoteDataSource _gemini;

  Future<String> getContextualSlogan({
    required List<Goal> goals,
    required List<DailyCheckIn> recentCheckIns,
    required AppLocalizations l10n,
    required String localeCode,
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final cached = await _local.getContextualSlogan(today);
    if (cached != null && cached.trim().isNotEmpty) {
      return cached.trim();
    }

    final snapshot = MotivationContextBuilder.build(
      goals: goals,
      recentCheckIns: recentCheckIns,
    );

    if (EnvConfig.hasGeminiApiKey && snapshot.goals.isNotEmpty) {
      try {
        final response = await _gemini.generateMotivationBundle(
          goals: snapshot.goals,
          recentCheckIns: snapshot.recentCheckIns,
          localeCode: localeCode,
        );

        final slogan = response.contextualSlogan.trim();
        if (slogan.isNotEmpty) {
          await _local.saveContextualSlogan(today, slogan);

          final fuel = response.dailyFuelText?.trim();
          if (fuel != null && fuel.isNotEmpty) {
            await _persistDailyFuel(
              fuel,
              snapshot: snapshot,
              goals: goals,
            );
          }

          await _syncWidget(
            quote: slogan,
            goalTitle: snapshot.focusGoal?.title ?? '',
            date: today,
          );

          return slogan;
        }
      } catch (_) {
        // Fall through to rule-based slogans.
      }
    }

    final fallback = MotivationFallbacks.contextualSlogan(snapshot, l10n);
    await _local.saveContextualSlogan(today, fallback);
    await _syncWidget(
      quote: fallback,
      goalTitle: snapshot.focusGoal?.title ?? '',
      date: today,
    );
    return fallback;
  }

  Future<void> applyCheckInMotivation({
    required List<Goal> goals,
    required List<DailyCheckIn> recentCheckIns,
    required AppLocalizations l10n,
    String? contextualSlogan,
    String? dailyFuelText,
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final snapshot = MotivationContextBuilder.build(
      goals: goals,
      recentCheckIns: recentCheckIns,
    );

    final slogan = contextualSlogan?.trim().isNotEmpty == true
        ? contextualSlogan!.trim()
        : MotivationFallbacks.contextualSlogan(snapshot, l10n);
    await _local.saveContextualSlogan(today, slogan);

    final fuel = dailyFuelText?.trim().isNotEmpty == true
        ? dailyFuelText!.trim()
        : MotivationFallbacks.dailyFuel(snapshot, l10n);
    await _persistDailyFuel(
      fuel,
      snapshot: snapshot,
      goals: goals,
    );

    await _syncWidget(
      quote: slogan,
      goalTitle: snapshot.focusGoal?.title ?? '',
      date: today,
    );
  }

  Future<void> refreshHomeWidgetOnStartup({
    required List<Goal> goals,
    required List<DailyCheckIn> recentCheckIns,
  }) async {
    await HomeWidgetService.instance.activateScheduledIfNeeded();

    final today = DateUtils.dateOnly(DateTime.now());
    final todayKey = DateUtils.dateKey(today);
    final widgetDate = await HomeWidget.getWidgetData<String>(
      HomeWidgetConstants.quoteDateKey,
    );
    if (widgetDate == todayKey) return;

    final cached = await _local.getContextualSlogan(today);
    if (cached == null || cached.trim().isEmpty) return;

    final snapshot = MotivationContextBuilder.build(
      goals: goals,
      recentCheckIns: recentCheckIns,
    );
    await _syncWidget(
      quote: cached.trim(),
      goalTitle: snapshot.focusGoal?.title ?? '',
      date: today,
    );
  }

  Future<void> rescheduleDailyFuelNotification({
    required AppLocalizations l10n,
    List<Goal> goals = const [],
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());
    var targetDate = today;
    final now = DateTime.now();

    if (now.hour > StorageConstants.dailyFuelHour ||
        (now.hour == StorageConstants.dailyFuelHour &&
            now.minute >= StorageConstants.dailyFuelMinute)) {
      targetDate = today.add(const Duration(days: 1));
    }

    final message = await _local.getDailyFuel(targetDate);
    if (message == null || message.trim().isEmpty) return;

    await NotificationService.instance.scheduleDailyFuel(
      message: message,
      targetDate: targetDate,
      l10n: l10n,
      goals: goals,
    );
  }

  Future<void> _persistDailyFuel(
    String message, {
    required MotivationSnapshot snapshot,
    List<Goal> goals = const [],
  }) async {
    final tomorrow = DateUtils.dateOnly(
      DateTime.now().add(const Duration(days: 1)),
    );
    await _local.saveDailyFuel(tomorrow, message);
    await NotificationService.instance.scheduleDailyFuel(
      message: message,
      targetDate: tomorrow,
      goals: goals,
    );
    await HomeWidgetService.instance.scheduleMorningQuote(
      quote: message,
      goalTitle: snapshot.focusGoal?.title ?? '',
      date: tomorrow,
    );
  }

  Future<void> _syncWidget({
    required String quote,
    required String goalTitle,
    required DateTime date,
  }) async {
    await HomeWidgetService.instance.updateQuote(
      quote: quote,
      goalTitle: goalTitle,
      date: date,
    );
  }
}
