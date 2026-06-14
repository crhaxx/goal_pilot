/// Keys shared between Flutter and native home screen widgets.
abstract final class HomeWidgetConstants {
  static const androidWidgetName = 'DailyFuelWidgetReceiver';
  static const iosWidgetName = 'DailyFuelWidget';

  /// App Group for iOS widget data sharing (requires paid Apple Developer account).
  static const iosAppGroupId = 'group.com.example.goal_pilot';

  static const quoteKey = 'daily_fuel_quote';
  static const goalTitleKey = 'daily_fuel_goal_title';
  static const quoteDateKey = 'daily_fuel_date';

  static const scheduledQuoteKey = 'scheduled_quote';
  static const scheduledGoalTitleKey = 'scheduled_goal_title';
  static const scheduledDateKey = 'scheduled_date';

  static const fallbackQuote =
      'Captain, your goals are waiting. One small move today beats zero.';
}
