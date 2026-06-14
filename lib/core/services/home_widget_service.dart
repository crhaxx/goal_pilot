import 'dart:io';

import 'package:goal_pilot/core/constants/home_widget_constants.dart';
import 'package:goal_pilot/core/utils/date_utils.dart';
import 'package:home_widget/home_widget.dart';

/// Syncs motivational quote data to native home screen widgets via SharedPreferences.
class HomeWidgetService {
  HomeWidgetService._();

  static final HomeWidgetService instance = HomeWidgetService._();

  var _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(HomeWidgetConstants.iosAppGroupId);
    }

    _initialized = true;
  }

  /// Shows [quote] on the widget for [date] (usually today after check-in).
  Future<void> updateQuote({
    required String quote,
    required String goalTitle,
    required DateTime date,
  }) async {
    await initialize();
    final trimmed = quote.trim();
    if (trimmed.isEmpty) return;

    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.quoteKey,
      trimmed,
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.goalTitleKey,
      goalTitle.trim(),
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.quoteDateKey,
      DateUtils.dateKey(date),
    );
    await _reloadWidget();
  }

  /// Preloads tomorrow's morning quote (generated at check-in).
  Future<void> scheduleMorningQuote({
    required String quote,
    required String goalTitle,
    required DateTime date,
  }) async {
    await initialize();
    final trimmed = quote.trim();
    if (trimmed.isEmpty) return;

    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.scheduledQuoteKey,
      trimmed,
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.scheduledGoalTitleKey,
      goalTitle.trim(),
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetConstants.scheduledDateKey,
      DateUtils.dateKey(date),
    );
    await _reloadWidget();
  }

  /// Promotes a scheduled morning quote when the day rolls over.
  Future<void> activateScheduledIfNeeded() async {
    await initialize();

    final todayKey = DateUtils.dateKey(DateTime.now());
    final currentDate =
        await HomeWidget.getWidgetData<String>(HomeWidgetConstants.quoteDateKey);
    if (currentDate == todayKey) return;

    final scheduledDate = await HomeWidget.getWidgetData<String>(
      HomeWidgetConstants.scheduledDateKey,
    );
    if (scheduledDate != todayKey) return;

    final quote = await HomeWidget.getWidgetData<String>(
      HomeWidgetConstants.scheduledQuoteKey,
    );
    if (quote == null || quote.trim().isEmpty) return;

    final goalTitle = await HomeWidget.getWidgetData<String>(
          HomeWidgetConstants.scheduledGoalTitleKey,
        ) ??
        '';

    await updateQuote(
      quote: quote,
      goalTitle: goalTitle,
      date: DateUtils.dateOnly(DateTime.now()),
    );
  }

  Future<void> _reloadWidget() async {
    try {
      await HomeWidget.updateWidget(
        androidName: HomeWidgetConstants.androidWidgetName,
        iOSName: HomeWidgetConstants.iosWidgetName,
      );
    } catch (_) {
      // Widget may not be placed on the home screen yet.
    }
  }
}
