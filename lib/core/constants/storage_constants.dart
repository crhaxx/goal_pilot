/// Hive box names and storage keys.
abstract final class StorageConstants {
  static const goalsBox = 'goals';
  static const checkInsBox = 'check_ins';
  static const chatBox = 'chat_messages';
  static const reviewsBox = 'weekly_reviews';
  static const preferencesBox = 'preferences';
  static const winBricksBox = 'win_bricks';
  static const settingsKey = 'app_settings';
  static const personalizationKey = 'user_personalization';
  static const onboardingCompletedKey = 'onboarding_completed';
  static const pendingSmartAlertKey = 'pending_smart_alert';
  static const contextualSloganPrefix = 'motivation_contextual_';
  static const contextualPendingPrefix = 'motivation_contextual_pending_';
  static const dailyFuelPrefix = 'motivation_daily_fuel_';
  static const chatHistoryPrefix = 'chat_';

  static const dailyCheckInNotificationId = 1001;
  static const smartAlertNotificationId = 1002;
  static const dailyFuelNotificationId = 1003;
  static const dailyReminderSlotBaseId = 1010;
  static const dailyReminderDaysAhead = 14;

  static const dailyFuelHour = 7;
  static const dailyFuelMinute = 0;
}
