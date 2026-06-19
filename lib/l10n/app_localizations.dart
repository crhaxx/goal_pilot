import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GoalPilot'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Navigate your goals with AI'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @couldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {error}'**
  String couldNotLoad(String error);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String onboardingWelcomeTitle(String appName);

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Your AI navigator for reaching goals. Explore the main features, then take off.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your goal'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a goal and AI breaks it into milestones and daily tasks.'**
  String get onboardingGoalDesc;

  /// No description provided for @onboardingDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily plan & check-in'**
  String get onboardingDailyTitle;

  /// No description provided for @onboardingDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'See your daily focus. Check-ins with Pilot keep you on track.'**
  String get onboardingDailyDesc;

  /// No description provided for @onboardingCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'AI coach Pilot'**
  String get onboardingCoachTitle;

  /// No description provided for @onboardingCoachDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask Pilot, practice tough situations, or get motivation when it gets hard.'**
  String get onboardingCoachDesc;

  /// No description provided for @onboardingReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get onboardingReviewTitle;

  /// No description provided for @onboardingReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Each week, review progress, streaks, and what to improve next.'**
  String get onboardingReviewDesc;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to go?'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal and let {appName} navigate your journey.'**
  String onboardingReadyDesc(String appName);

  /// No description provided for @languageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageSelectTitle;

  /// No description provided for @languageSelectDesc.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings.'**
  String get languageSelectDesc;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageCzech.
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get languageCzech;

  /// No description provided for @languageContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get languageContinue;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsDailyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Local notification at your chosen time every day'**
  String get settingsDailyReminderDesc;

  /// No description provided for @settingsDailyFuelReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Fuel reminder'**
  String get settingsDailyFuelReminder;

  /// No description provided for @settingsDailyFuelReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Morning motivation from Pilot at 7:00 on active days'**
  String get settingsDailyFuelReminderDesc;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get settingsReminderTime;

  /// No description provided for @settingsTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get settingsTestNotification;

  /// No description provided for @settingsTestNotificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Send one now to verify everything works'**
  String get settingsTestNotificationDesc;

  /// No description provided for @settingsBatteryTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: On Xiaomi/Samsung, disable battery optimization for GoalPilot if reminders are delayed.'**
  String get settingsBatteryTip;

  /// No description provided for @settingsJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get settingsJournal;

  /// No description provided for @settingsJournalDayStart.
  ///
  /// In en, this message translates to:
  /// **'New journal day starts at'**
  String get settingsJournalDayStart;

  /// No description provided for @settingsJournalDayStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Before this time you are still writing about the previous day'**
  String get settingsJournalDayStartDesc;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsPoweredByGemini.
  ///
  /// In en, this message translates to:
  /// **'Powered by Gemini AI'**
  String get settingsPoweredByGemini;

  /// No description provided for @settingsPoweredByGeminiDesc.
  ///
  /// In en, this message translates to:
  /// **'Goal decomposition, coaching & reviews — powered by your Gemini API key'**
  String get settingsPoweredByGeminiDesc;

  /// No description provided for @settingsAboutFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'What GoalPilot does'**
  String get settingsAboutFeaturesTitle;

  /// No description provided for @settingsAboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get settingsAboutPrivacyTitle;

  /// No description provided for @settingsAboutPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Goals, check-ins, and reviews stay on your device. Your Gemini API key is stored in secure storage and sent only to Google for AI requests.'**
  String get settingsAboutPrivacyDesc;

  /// No description provided for @settingsGeminiModel.
  ///
  /// In en, this message translates to:
  /// **'Model: {model}'**
  String settingsGeminiModel(String model);

  /// No description provided for @settingsShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share GoalPilot'**
  String get settingsShareApp;

  /// No description provided for @settingsShareAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Invite friends to navigate their goals'**
  String get settingsShareAppDesc;

  /// No description provided for @settingsShareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'I\'m tracking my goals with GoalPilot — AI planning, daily check-ins, and weekly reviews. ✈️'**
  String get settingsShareAppMessage;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications in system settings, then try again.'**
  String get notificationPermissionDenied;

  /// No description provided for @reminderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Reminder updated.'**
  String get reminderUpdated;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed.'**
  String get failed;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @statActiveGoals.
  ///
  /// In en, this message translates to:
  /// **'Active goals'**
  String get statActiveGoals;

  /// No description provided for @statBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get statBestStreak;

  /// No description provided for @statCheckIns7d.
  ///
  /// In en, this message translates to:
  /// **'Check-ins (7d)'**
  String get statCheckIns7d;

  /// No description provided for @statAvgProgress.
  ///
  /// In en, this message translates to:
  /// **'Avg progress'**
  String get statAvgProgress;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get newGoal;

  /// No description provided for @createFirstGoal.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal'**
  String get createFirstGoal;

  /// No description provided for @todaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get todaysFocus;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @todaysTasksDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick tasks unrelated to your goals'**
  String get todaysTasksDesc;

  /// No description provided for @todaysTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today yet. Add something you want to get done.'**
  String get todaysTasksEmpty;

  /// No description provided for @personalTaskAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get personalTaskAddTitle;

  /// No description provided for @personalTaskEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get personalTaskEditTitle;

  /// No description provided for @personalTaskAddDesc.
  ///
  /// In en, this message translates to:
  /// **'A simple to-do that does not need to be tied to a goal.'**
  String get personalTaskAddDesc;

  /// No description provided for @personalTaskHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get personalTaskHint;

  /// No description provided for @personalTaskDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get personalTaskDueDate;

  /// No description provided for @personalTaskReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder notification'**
  String get personalTaskReminder;

  /// No description provided for @personalTaskReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick any day and time'**
  String get personalTaskReminderDesc;

  /// No description provided for @personalTaskChangeReminder.
  ///
  /// In en, this message translates to:
  /// **'Change reminder time'**
  String get personalTaskChangeReminder;

  /// No description provided for @personalTaskAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get personalTaskAddButton;

  /// No description provided for @personalTaskSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get personalTaskSave;

  /// No description provided for @personalTaskEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get personalTaskEdit;

  /// No description provided for @personalTaskDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get personalTaskDelete;

  /// No description provided for @personalTaskReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Reminder: {datetime}'**
  String personalTaskReminderAt(String datetime);

  /// No description provided for @completedPersonalTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks'**
  String get completedPersonalTasks;

  /// No description provided for @completedPersonalTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks ({count})'**
  String completedPersonalTasksCount(int count);

  /// No description provided for @notifChannelPersonalTask.
  ///
  /// In en, this message translates to:
  /// **'Task reminders'**
  String get notifChannelPersonalTask;

  /// No description provided for @notifChannelPersonalTaskDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for your personal to-do tasks'**
  String get notifChannelPersonalTaskDesc;

  /// No description provided for @notifPersonalTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get notifPersonalTaskTitle;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCount(int count);

  /// No description provided for @allCheckInsDone.
  ///
  /// In en, this message translates to:
  /// **'All check-ins done for today. Great work!'**
  String get allCheckInsDone;

  /// No description provided for @emptyHomeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String emptyHomeWelcome(String appName);

  /// No description provided for @emptyHomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a goal, get a daily plan, check in with Pilot, and review your progress every week.'**
  String get emptyHomeDesc;

  /// No description provided for @homeOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get homeOverview;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// No description provided for @homeProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get homeProgressLabel;

  /// No description provided for @emptyHomeFeaturePlan.
  ///
  /// In en, this message translates to:
  /// **'AI milestone planning'**
  String get emptyHomeFeaturePlan;

  /// No description provided for @emptyHomeFeatureCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Daily Pilot check-ins'**
  String get emptyHomeFeatureCheckIn;

  /// No description provided for @emptyHomeFeatureReview.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress reviews'**
  String get emptyHomeFeatureReview;

  /// No description provided for @myGoals.
  ///
  /// In en, this message translates to:
  /// **'My Goals'**
  String get myGoals;

  /// No description provided for @newGoalTooltip.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get newGoalTooltip;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'No goals yet'**
  String get noGoalsYet;

  /// No description provided for @noGoalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a goal and Pilot will build your plan.'**
  String get noGoalsDesc;

  /// No description provided for @createGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get createGoalTitle;

  /// No description provided for @createGoalHeadline.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get createGoalHeadline;

  /// No description provided for @createGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe your goal in your own words. Pilot will break it into 4–6 actionable milestones.'**
  String get createGoalDesc;

  /// No description provided for @createGoalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Learn Flutter in 3 months'**
  String get createGoalHint;

  /// No description provided for @createGoalValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 5 characters.'**
  String get createGoalValidation;

  /// No description provided for @createGoalPlanning.
  ///
  /// In en, this message translates to:
  /// **'Pilot is planning your milestones…'**
  String get createGoalPlanning;

  /// No description provided for @goalPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal importance'**
  String get goalPriorityLabel;

  /// No description provided for @goalPriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Sets how prominently this goal appears in your list and today\'s focus.'**
  String get goalPriorityDesc;

  /// No description provided for @goalPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get goalPriorityLow;

  /// No description provided for @goalPriorityLowDesc.
  ///
  /// In en, this message translates to:
  /// **'Nice to have — focus on it when time allows.'**
  String get goalPriorityLowDesc;

  /// No description provided for @goalPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get goalPriorityMedium;

  /// No description provided for @goalPriorityMediumDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced attention alongside your other goals.'**
  String get goalPriorityMediumDesc;

  /// No description provided for @goalPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get goalPriorityHigh;

  /// No description provided for @goalPriorityHighDesc.
  ///
  /// In en, this message translates to:
  /// **'Important — Pilot surfaces it ahead of lower goals.'**
  String get goalPriorityHighDesc;

  /// No description provided for @goalPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get goalPriorityCritical;

  /// No description provided for @goalPriorityCriticalDesc.
  ///
  /// In en, this message translates to:
  /// **'Top priority — always shown first.'**
  String get goalPriorityCriticalDesc;

  /// No description provided for @goalPriorityUpdated.
  ///
  /// In en, this message translates to:
  /// **'Priority updated.'**
  String get goalPriorityUpdated;

  /// No description provided for @changeGoalPriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority'**
  String get changeGoalPriority;

  /// No description provided for @deleteGoal.
  ///
  /// In en, this message translates to:
  /// **'Delete goal'**
  String get deleteGoal;

  /// No description provided for @deleteGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete goal?'**
  String get deleteGoalTitle;

  /// No description provided for @deleteGoalConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove \"{title}\" and all its progress.'**
  String deleteGoalConfirm(String title);

  /// No description provided for @deleteGoalButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteGoalButton;

  /// No description provided for @deleteGoalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Goal deleted.'**
  String get deleteGoalSuccess;

  /// No description provided for @goalActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Goal actions'**
  String get goalActionsTooltip;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @generatePlan.
  ///
  /// In en, this message translates to:
  /// **'Generate Plan'**
  String get generatePlan;

  /// No description provided for @goalTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal templates'**
  String get goalTemplatesTitle;

  /// No description provided for @goalTemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Start with a ready-made plan, or personalize it with AI.'**
  String get goalTemplatesDesc;

  /// No description provided for @goalTemplateLearnLanguage.
  ///
  /// In en, this message translates to:
  /// **'Learn a language'**
  String get goalTemplateLearnLanguage;

  /// No description provided for @goalTemplateLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose 5 kg'**
  String get goalTemplateLoseWeight;

  /// No description provided for @goalTemplateFinishProject.
  ///
  /// In en, this message translates to:
  /// **'Finish a project'**
  String get goalTemplateFinishProject;

  /// No description provided for @useTemplatePlan.
  ///
  /// In en, this message translates to:
  /// **'Use template plan'**
  String get useTemplatePlan;

  /// No description provided for @createGoalAiRequiresKey.
  ///
  /// In en, this message translates to:
  /// **'Add a Gemini API key in Settings to generate a personalized AI plan.'**
  String get createGoalAiRequiresKey;

  /// No description provided for @scheduleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'When do you work on this?'**
  String get scheduleSectionTitle;

  /// No description provided for @scheduleSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Pilot adapts milestones and streak to your schedule.'**
  String get scheduleSectionDesc;

  /// No description provided for @scheduleEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get scheduleEveryDay;

  /// No description provided for @scheduleEveryDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily check-ins and micro-tasks.'**
  String get scheduleEveryDayDesc;

  /// No description provided for @scheduleTimesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'X times a week'**
  String get scheduleTimesPerWeek;

  /// No description provided for @scheduleTimesPerWeekDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick frequency and days — or let Pilot suggest them.'**
  String get scheduleTimesPerWeekDesc;

  /// No description provided for @scheduleWeekendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Weekends only'**
  String get scheduleWeekendsOnly;

  /// No description provided for @scheduleWeekendsOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Saturday and Sunday — weekdays are rest days.'**
  String get scheduleWeekendsOnlyDesc;

  /// No description provided for @schedulePickDays.
  ///
  /// In en, this message translates to:
  /// **'Tap the days you have time (optional)'**
  String get schedulePickDays;

  /// No description provided for @scheduleTimesLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}× per week'**
  String scheduleTimesLabel(int count);

  /// No description provided for @scheduleWeekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get scheduleWeekdayMon;

  /// No description provided for @scheduleWeekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get scheduleWeekdayTue;

  /// No description provided for @scheduleWeekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get scheduleWeekdayWed;

  /// No description provided for @scheduleWeekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get scheduleWeekdayThu;

  /// No description provided for @scheduleWeekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get scheduleWeekdayFri;

  /// No description provided for @scheduleWeekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get scheduleWeekdaySat;

  /// No description provided for @scheduleWeekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get scheduleWeekdaySun;

  /// No description provided for @scheduleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated.'**
  String get scheduleUpdated;

  /// No description provided for @restDaySection.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restDaySection;

  /// No description provided for @restDayNextStepTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Next step awaits you tomorrow'**
  String get restDayNextStepTomorrow;

  /// No description provided for @restDayNextStepOn.
  ///
  /// In en, this message translates to:
  /// **'Next step on {date}'**
  String restDayNextStepOn(String date);

  /// No description provided for @restDayPaused.
  ///
  /// In en, this message translates to:
  /// **'Rest day — no check-in needed'**
  String get restDayPaused;

  /// No description provided for @goalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Goal not found.'**
  String get goalNotFound;

  /// No description provided for @shareProgress.
  ///
  /// In en, this message translates to:
  /// **'Share progress'**
  String get shareProgress;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// No description provided for @tabJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get tabJournal;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get checkedIn;

  /// No description provided for @dailyHabit.
  ///
  /// In en, this message translates to:
  /// **'Daily Habit'**
  String get dailyHabit;

  /// No description provided for @currentMilestone.
  ///
  /// In en, this message translates to:
  /// **'Current Milestone'**
  String get currentMilestone;

  /// No description provided for @pilotTips.
  ///
  /// In en, this message translates to:
  /// **'Pilot Tips'**
  String get pilotTips;

  /// No description provided for @emergencySteps.
  ///
  /// In en, this message translates to:
  /// **'Emergency steps'**
  String get emergencySteps;

  /// No description provided for @allMilestonesComplete.
  ///
  /// In en, this message translates to:
  /// **'All milestones complete!'**
  String get allMilestonesComplete;

  /// No description provided for @addMoreMilestones.
  ///
  /// In en, this message translates to:
  /// **'Add more milestones'**
  String get addMoreMilestones;

  /// No description provided for @extendMilestonesSuccess.
  ///
  /// In en, this message translates to:
  /// **'New milestones are ready — keep going!'**
  String get extendMilestonesSuccess;

  /// No description provided for @milestoneCelebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'All milestones complete!'**
  String get milestoneCelebrationTitle;

  /// No description provided for @milestoneCelebrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amazing work on \"{title}\". You\'re on the right track!'**
  String milestoneCelebrationSubtitle(String title);

  /// No description provided for @milestoneCelebrationBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mission complete. Ready for the next chapter?'**
  String get milestoneCelebrationBannerSubtitle;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet — create a new goal or wait for Pilot to generate tasks.'**
  String get noTasksYet;

  /// No description provided for @doneWallThisGoal.
  ///
  /// In en, this message translates to:
  /// **'This goal\'s win wall'**
  String get doneWallThisGoal;

  /// No description provided for @pivotSuggested.
  ///
  /// In en, this message translates to:
  /// **'Pilot suggests a plan pivot'**
  String get pivotSuggested;

  /// No description provided for @fireDrillSimulator.
  ///
  /// In en, this message translates to:
  /// **'Fire drill simulator'**
  String get fireDrillSimulator;

  /// No description provided for @milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestones;

  /// No description provided for @pivotWizardEdit.
  ///
  /// In en, this message translates to:
  /// **'Pivot Wizard — edit plan'**
  String get pivotWizardEdit;

  /// No description provided for @launchSimulator.
  ///
  /// In en, this message translates to:
  /// **'Launch simulator'**
  String get launchSimulator;

  /// No description provided for @noMicroTasks.
  ///
  /// In en, this message translates to:
  /// **'No micro-tasks for this milestone'**
  String get noMicroTasks;

  /// No description provided for @markMilestoneComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark milestone complete'**
  String get markMilestoneComplete;

  /// No description provided for @noCheckInsYet.
  ///
  /// In en, this message translates to:
  /// **'No check-ins yet. Complete your first daily check-in to start the journal.'**
  String get noCheckInsYet;

  /// No description provided for @moodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood: {mood}/5'**
  String moodLabel(int mood);

  /// No description provided for @tasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {completed}/{total}'**
  String tasksLabel(int completed, int total);

  /// No description provided for @progressMilestones.
  ///
  /// In en, this message translates to:
  /// **'{percent}% · {completed}/{total} milestones'**
  String progressMilestones(int percent, int completed, int total);

  /// No description provided for @milestonesCount.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} milestones'**
  String milestonesCount(int completed, int total);

  /// No description provided for @checkInPending.
  ///
  /// In en, this message translates to:
  /// **'Check-in pending'**
  String get checkInPending;

  /// No description provided for @focusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus: {title}'**
  String focusLabel(String title);

  /// No description provided for @todayTasksDone.
  ///
  /// In en, this message translates to:
  /// **'Today: {completed}/{total} tasks done'**
  String todayTasksDone(int completed, int total);

  /// No description provided for @dailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get dailyCheckIn;

  /// No description provided for @checkedInToday.
  ///
  /// In en, this message translates to:
  /// **'Checked in today'**
  String get checkedInToday;

  /// No description provided for @workedOnGoalToday.
  ///
  /// In en, this message translates to:
  /// **'I worked on this today'**
  String get workedOnGoalToday;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalCurrentDay.
  ///
  /// In en, this message translates to:
  /// **'Day: {date}'**
  String journalCurrentDay(String date);

  /// No description provided for @journalCurrentDayHint.
  ///
  /// In en, this message translates to:
  /// **'Write what you did today — work, learning, life. Not tied to a single goal.'**
  String get journalCurrentDayHint;

  /// No description provided for @journalEntryHint.
  ///
  /// In en, this message translates to:
  /// **'What did you do today?'**
  String get journalEntryHint;

  /// No description provided for @journalSave.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get journalSave;

  /// No description provided for @journalSaved.
  ///
  /// In en, this message translates to:
  /// **'Journal entry saved.'**
  String get journalSaved;

  /// No description provided for @journalPastEntries.
  ///
  /// In en, this message translates to:
  /// **'Previous days'**
  String get journalPastEntries;

  /// No description provided for @journalTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get journalTabToday;

  /// No description provided for @journalTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get journalTabHistory;

  /// No description provided for @journalNoPastEntries.
  ///
  /// In en, this message translates to:
  /// **'No past entries yet. Your previous days will appear here.'**
  String get journalNoPastEntries;

  /// No description provided for @journalEntryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty entry'**
  String get journalEntryEmpty;

  /// No description provided for @journalDayUnlocksAt.
  ///
  /// In en, this message translates to:
  /// **'Today\'s journal unlocks at {time}'**
  String journalDayUnlocksAt(String time);

  /// No description provided for @journalEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to write about your day'**
  String get journalEmptyPrompt;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @dailyTask.
  ///
  /// In en, this message translates to:
  /// **'Daily task'**
  String get dailyTask;

  /// No description provided for @oneTimeTask.
  ///
  /// In en, this message translates to:
  /// **'One-time task'**
  String get oneTimeTask;

  /// No description provided for @addCustomTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your task'**
  String get addCustomTaskTitle;

  /// No description provided for @addCustomTaskDesc.
  ///
  /// In en, this message translates to:
  /// **'Supplement Pilot\'s plan with your own steps for this milestone.'**
  String get addCustomTaskDesc;

  /// No description provided for @addCustomTaskHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to work on?'**
  String get addCustomTaskHint;

  /// No description provided for @addCustomTaskMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get addCustomTaskMilestone;

  /// No description provided for @addCustomTaskType.
  ///
  /// In en, this message translates to:
  /// **'Task type'**
  String get addCustomTaskType;

  /// No description provided for @addCustomTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addCustomTaskButton;

  /// No description provided for @addCustomTaskAction.
  ///
  /// In en, this message translates to:
  /// **'Add your task'**
  String get addCustomTaskAction;

  /// No description provided for @yourTaskLabel.
  ///
  /// In en, this message translates to:
  /// **'Your task'**
  String get yourTaskLabel;

  /// No description provided for @removeCustomTask.
  ///
  /// In en, this message translates to:
  /// **'Remove task'**
  String get removeCustomTask;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day streak} other{{count} day streak}}'**
  String streakDays(int count);

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get checkInTitle;

  /// No description provided for @howFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howFeelingToday;

  /// No description provided for @moodRough.
  ///
  /// In en, this message translates to:
  /// **'Rough'**
  String get moodRough;

  /// No description provided for @moodLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodLow;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// No description provided for @checkInNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What did you work on today? (optional)'**
  String get checkInNoteHint;

  /// No description provided for @tasksTodayCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks today: {completed}/{total} completed'**
  String tasksTodayCompleted(int completed, int total);

  /// No description provided for @antiGoalSection.
  ///
  /// In en, this message translates to:
  /// **'Sabotage trap'**
  String get antiGoalSection;

  /// No description provided for @antiGoalWhich.
  ///
  /// In en, this message translates to:
  /// **'Which saboteur to avoid?'**
  String get antiGoalWhich;

  /// No description provided for @antiGoalSurrenderedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you give in to \"{title}\" today?'**
  String antiGoalSurrenderedQuestion(String title);

  /// No description provided for @antiGoalYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, gave in'**
  String get antiGoalYes;

  /// No description provided for @antiGoalNo.
  ///
  /// In en, this message translates to:
  /// **'No, stayed strong'**
  String get antiGoalNo;

  /// No description provided for @pilotSays.
  ///
  /// In en, this message translates to:
  /// **'Pilot says'**
  String get pilotSays;

  /// No description provided for @pilotThinking.
  ///
  /// In en, this message translates to:
  /// **'Pilot is thinking…'**
  String get pilotThinking;

  /// No description provided for @completeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Complete Check-in'**
  String get completeCheckIn;

  /// No description provided for @crisisDetectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Pilot detected a crisis — consider activating emergency mode in the goal detail.'**
  String get crisisDetectedSnack;

  /// No description provided for @crisisMode.
  ///
  /// In en, this message translates to:
  /// **'Crisis mode'**
  String get crisisMode;

  /// No description provided for @activateEmergencyMode.
  ///
  /// In en, this message translates to:
  /// **'Activate emergency mode'**
  String get activateEmergencyMode;

  /// No description provided for @pilotPreparing.
  ///
  /// In en, this message translates to:
  /// **'Pilot is preparing…'**
  String get pilotPreparing;

  /// No description provided for @emergencyModeActivated.
  ///
  /// In en, this message translates to:
  /// **'Emergency mode activated — atomic steps only.'**
  String get emergencyModeActivated;

  /// No description provided for @emergencyModeActive.
  ///
  /// In en, this message translates to:
  /// **'Emergency mode active'**
  String get emergencyModeActive;

  /// No description provided for @emergencyModeHint.
  ///
  /// In en, this message translates to:
  /// **'Today, these atomic steps are enough — no extra pressure.'**
  String get emergencyModeHint;

  /// No description provided for @exitEmergencyMode.
  ///
  /// In en, this message translates to:
  /// **'Exit emergency mode'**
  String get exitEmergencyMode;

  /// No description provided for @crisisReasonNote.
  ///
  /// In en, this message translates to:
  /// **'Your check-in signals it\'s too much. Pilot suggests emergency mode with minimal steps.'**
  String get crisisReasonNote;

  /// No description provided for @crisisReasonDays.
  ///
  /// In en, this message translates to:
  /// **'No check-in for {days} days on \"{title}\". Try emergency mode — atomic steps only.'**
  String crisisReasonDays(int days, String title);

  /// No description provided for @crisisFallbackTask.
  ///
  /// In en, this message translates to:
  /// **'Open the app and look at your goal (30 seconds)'**
  String get crisisFallbackTask;

  /// No description provided for @winBrickFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Small win'**
  String get winBrickFallbackLabel;

  /// No description provided for @pivotWizard.
  ///
  /// In en, this message translates to:
  /// **'Pivot Wizard'**
  String get pivotWizard;

  /// No description provided for @pivotContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pivotContinue;

  /// No description provided for @pivotDetected.
  ///
  /// In en, this message translates to:
  /// **'Pilot detected recurring difficulties'**
  String get pivotDetected;

  /// No description provided for @pivotReshaping.
  ///
  /// In en, this message translates to:
  /// **'Pilot is reshaping the plan…'**
  String get pivotReshaping;

  /// No description provided for @launchPivot.
  ///
  /// In en, this message translates to:
  /// **'Launch Pivot'**
  String get launchPivot;

  /// No description provided for @pivotSuccess.
  ///
  /// In en, this message translates to:
  /// **'Plan updated — {streak}-day streak preserved. Check-in history kept.'**
  String pivotSuccess(int streak);

  /// No description provided for @pivotReason.
  ///
  /// In en, this message translates to:
  /// **'Recent check-ins show mood {moods}/5.{notes}'**
  String pivotReason(String moods, String notes);

  /// No description provided for @pivotReasonNotes.
  ///
  /// In en, this message translates to:
  /// **' Notes: {notes}'**
  String pivotReasonNotes(String notes);

  /// No description provided for @realityCheck.
  ///
  /// In en, this message translates to:
  /// **'Reality Check'**
  String get realityCheck;

  /// No description provided for @realityCheckLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocks after {days} days or {checkIns} check-ins.'**
  String realityCheckLocked(int days, int checkIns);

  /// No description provided for @realityMirror.
  ///
  /// In en, this message translates to:
  /// **'Reality mirror'**
  String get realityMirror;

  /// No description provided for @realityCheckReady.
  ///
  /// In en, this message translates to:
  /// **'Pilot is ready to compare your plan with real check-in and journal data.'**
  String get realityCheckReady;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @pilotAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Pilot is analyzing…'**
  String get pilotAnalyzing;

  /// No description provided for @runRealityCheck.
  ///
  /// In en, this message translates to:
  /// **'Run Reality Check'**
  String get runRealityCheck;

  /// No description provided for @refreshAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Refresh analysis'**
  String get refreshAnalysis;

  /// No description provided for @pilotWarns.
  ///
  /// In en, this message translates to:
  /// **'Pilot warns: {message}'**
  String pilotWarns(String message);

  /// No description provided for @askPilot.
  ///
  /// In en, this message translates to:
  /// **'Ask Pilot'**
  String get askPilot;

  /// No description provided for @saboteurProfile.
  ///
  /// In en, this message translates to:
  /// **'Saboteur profile'**
  String get saboteurProfile;

  /// No description provided for @saboteurDesc.
  ///
  /// In en, this message translates to:
  /// **'3 things that will sink you — track them in check-ins.'**
  String get saboteurDesc;

  /// No description provided for @triggerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger: {trigger}'**
  String triggerLabel(String trigger);

  /// No description provided for @costLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost}'**
  String costLabel(String cost);

  /// No description provided for @pilotCoach.
  ///
  /// In en, this message translates to:
  /// **'Pilot Coach'**
  String get pilotCoach;

  /// No description provided for @pilotCoachEmpty.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Pilot. How can I help you with \"{title}\" today?'**
  String pilotCoachEmpty(String title);

  /// No description provided for @messagePilotHint.
  ///
  /// In en, this message translates to:
  /// **'Message Pilot…'**
  String get messagePilotHint;

  /// No description provided for @roleplayUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Roleplay is not available.'**
  String get roleplayUnavailable;

  /// No description provided for @roleplaySimulator.
  ///
  /// In en, this message translates to:
  /// **'Simulator: {title}'**
  String roleplaySimulator(String title);

  /// No description provided for @roleplayMessagesToEval.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} messages until evaluation'**
  String roleplayMessagesToEval(int count, int total);

  /// No description provided for @roleplayScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}/100'**
  String roleplayScore(int score);

  /// No description provided for @roleplayImprove.
  ///
  /// In en, this message translates to:
  /// **'What to improve:'**
  String get roleplayImprove;

  /// No description provided for @roleplayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write your first message and start training.'**
  String get roleplayEmpty;

  /// No description provided for @roleplayReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Your reply…'**
  String get roleplayReplyHint;

  /// No description provided for @roleplayComplete.
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get roleplayComplete;

  /// No description provided for @doneWall.
  ///
  /// In en, this message translates to:
  /// **'Win wall'**
  String get doneWall;

  /// No description provided for @doneWallEmpty.
  ///
  /// In en, this message translates to:
  /// **'The win wall fills up — complete micro-tasks or write a great check-in.'**
  String get doneWallEmpty;

  /// No description provided for @doneWallMore.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String doneWallMore(int count);

  /// No description provided for @doneWallLegendTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get doneWallLegendTask;

  /// No description provided for @doneWallLegendCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get doneWallLegendCheckIn;

  /// No description provided for @doneWallLegendTap.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get doneWallLegendTap;

  /// No description provided for @pilotEmergencyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Emergency mode — keeping you in the game'**
  String get pilotEmergencyHeadline;

  /// No description provided for @pilotEmergencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'For \"{title}\", atomic steps are enough. No extra pressure.'**
  String pilotEmergencySubtitle(String title);

  /// No description provided for @pilotMissionCompleteHeadline.
  ///
  /// In en, this message translates to:
  /// **'Mission complete, captain!'**
  String get pilotMissionCompleteHeadline;

  /// No description provided for @pilotMissionCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pilot celebrates your success on \"{title}\".'**
  String pilotMissionCompleteSubtitle(String title);

  /// No description provided for @pilotClearSkiesHeadline.
  ///
  /// In en, this message translates to:
  /// **'Clear skies, captain'**
  String get pilotClearSkiesHeadline;

  /// No description provided for @pilotClearSkiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{streak}-day streak on \"{title}\". Cockpit is green.'**
  String pilotClearSkiesSubtitle(int streak, String title);

  /// No description provided for @pilotTurbulenceHeadline.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in is missing'**
  String get pilotTurbulenceHeadline;

  /// No description provided for @pilotTurbulenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in for \"{title}\" is still due.'**
  String pilotTurbulenceSubtitle(String title);

  /// No description provided for @pilotCheckInWaitingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Cockpit blinking — check-in waiting'**
  String get pilotCheckInWaitingHeadline;

  /// No description provided for @pilotCheckInWaitingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{streak}-day streak on \"{title}\". Don\'t lose momentum.'**
  String pilotCheckInWaitingSubtitle(int streak, String title);

  /// No description provided for @pilotSteadyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Steady flight'**
  String get pilotSteadyHeadline;

  /// No description provided for @pilotSteadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pilot is tracking \"{title}\". You\'re on course.'**
  String pilotSteadySubtitle(String title);

  /// No description provided for @pilotReadyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Pilot is ready'**
  String get pilotReadyHeadline;

  /// No description provided for @pilotReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal and start the mission.'**
  String get pilotReadySubtitle;

  /// No description provided for @pilotEmergencyBoardHeadline.
  ///
  /// In en, this message translates to:
  /// **'Emergency mode on board'**
  String get pilotEmergencyBoardHeadline;

  /// No description provided for @pilotEmergencyBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} goals in emergency mode — atomic steps are enough.'**
  String pilotEmergencyBoardSubtitle(int count);

  /// No description provided for @pilotTurbulenceReportHeadline.
  ///
  /// In en, this message translates to:
  /// **'Pilot reports turbulence'**
  String get pilotTurbulenceReportHeadline;

  /// No description provided for @pilotTurbulenceReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} goals need emergency mode. Don\'t lose momentum.'**
  String pilotTurbulenceReportSubtitle(int count);

  /// No description provided for @pilotTurbulenceBoardHeadline.
  ///
  /// In en, this message translates to:
  /// **'Turbulence on board'**
  String get pilotTurbulenceBoardHeadline;

  /// No description provided for @pilotTurbulenceBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} goals waiting for check-in. Pilot needs you.'**
  String pilotTurbulenceBoardSubtitle(int count);

  /// No description provided for @pilotAllCheckInsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Clear skies, captain'**
  String get pilotAllCheckInsHeadline;

  /// No description provided for @pilotAllCheckInsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All check-ins done. Discipline on board.'**
  String get pilotAllCheckInsSubtitle;

  /// No description provided for @pilotOneCheckInHeadline.
  ///
  /// In en, this message translates to:
  /// **'One check-in missing'**
  String get pilotOneCheckInHeadline;

  /// No description provided for @pilotOneCheckInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete it today — Pilot holds the course.'**
  String get pilotOneCheckInSubtitle;

  /// No description provided for @pilotActiveGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} active goals. Keep the pace.'**
  String pilotActiveGoalsSubtitle(int count);

  /// No description provided for @weeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Review'**
  String get weeklyReview;

  /// No description provided for @pilotWeeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Pilot Weekly Review'**
  String get pilotWeeklyReview;

  /// No description provided for @weeklyReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Once a week, Pilot analyzes your check-ins, streaks, and tasks — then suggests what to focus on next.'**
  String get weeklyReviewDesc;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get generating;

  /// No description provided for @generateWeeklyReview.
  ///
  /// In en, this message translates to:
  /// **'Generate This Week\'s Review'**
  String get generateWeeklyReview;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Generate your first weekly review above.'**
  String get noReviewsYet;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// No description provided for @shareReview.
  ///
  /// In en, this message translates to:
  /// **'Share review'**
  String get shareReview;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @nextSteps.
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get nextSteps;

  /// No description provided for @failureGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get failureGeneric;

  /// No description provided for @failureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get failureNetwork;

  /// No description provided for @failureParse.
  ///
  /// In en, this message translates to:
  /// **'Could not understand the AI response.'**
  String get failureParse;

  /// No description provided for @failureCache.
  ///
  /// In en, this message translates to:
  /// **'Could not save or load your data.'**
  String get failureCache;

  /// No description provided for @failureTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get failureTimeout;

  /// No description provided for @failureQuota.
  ///
  /// In en, this message translates to:
  /// **'Gemini API quota exceeded. Wait a minute and try again, or enable billing in Google AI Studio.'**
  String get failureQuota;

  /// No description provided for @failureRetrySeconds.
  ///
  /// In en, this message translates to:
  /// **'{message}\nTry again in about {seconds} seconds.'**
  String failureRetrySeconds(String message, int seconds);

  /// No description provided for @failureModelUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Gemini model unavailable. Try again later or update your API key in Settings.'**
  String get failureModelUnavailable;

  /// No description provided for @failureMissingApiKey.
  ///
  /// In en, this message translates to:
  /// **'Add your Gemini API key in Settings to use AI features.'**
  String get failureMissingApiKey;

  /// No description provided for @settingsApiKey.
  ///
  /// In en, this message translates to:
  /// **'Gemini API key'**
  String get settingsApiKey;

  /// No description provided for @settingsApiKeyDesc.
  ///
  /// In en, this message translates to:
  /// **'Bring your own key — stored securely on this device'**
  String get settingsApiKeyDesc;

  /// No description provided for @settingsPersonalization.
  ///
  /// In en, this message translates to:
  /// **'My Pilot Profile'**
  String get settingsPersonalization;

  /// No description provided for @settingsPersonalizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Optional — help Pilot tailor coaching to your lifestyle'**
  String get settingsPersonalizationDesc;

  /// No description provided for @personalizationTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pilot Profile'**
  String get personalizationTitle;

  /// No description provided for @personalizationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable AI personalization'**
  String get personalizationEnabled;

  /// No description provided for @personalizationEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'When off, Pilot uses default coaching. All fields below are optional.'**
  String get personalizationEnabledDesc;

  /// No description provided for @personalizationScheduleRhythm.
  ///
  /// In en, this message translates to:
  /// **'Daily schedule rhythm'**
  String get personalizationScheduleRhythm;

  /// No description provided for @personalizationCoachingStyle.
  ///
  /// In en, this message translates to:
  /// **'Coaching style'**
  String get personalizationCoachingStyle;

  /// No description provided for @personalizationOccupation.
  ///
  /// In en, this message translates to:
  /// **'Current occupation'**
  String get personalizationOccupation;

  /// No description provided for @personalizationUserBio.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get personalizationUserBio;

  /// No description provided for @personalizationUserBioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell your AI Coach about your daily routine, strengths, weaknesses, motivations, or procrastination triggers…'**
  String get personalizationUserBioHint;

  /// No description provided for @personalizationNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get personalizationNotSpecified;

  /// No description provided for @personalizationSave.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get personalizationSave;

  /// No description provided for @personalizationSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get personalizationSaved;

  /// No description provided for @personalizationClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get personalizationClear;

  /// No description provided for @personalizationClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove all personalization data from this device?'**
  String get personalizationClearConfirm;

  /// No description provided for @personalizationClearDone.
  ///
  /// In en, this message translates to:
  /// **'Personalization data cleared'**
  String get personalizationClearDone;

  /// No description provided for @personalizationScheduleEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early bird'**
  String get personalizationScheduleEarlyBird;

  /// No description provided for @personalizationScheduleNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night owl'**
  String get personalizationScheduleNightOwl;

  /// No description provided for @personalizationScheduleFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get personalizationScheduleFlexible;

  /// No description provided for @personalizationScheduleIrregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular / shifting'**
  String get personalizationScheduleIrregular;

  /// No description provided for @personalizationStyleEmpathetic.
  ///
  /// In en, this message translates to:
  /// **'Empathetic & supportive'**
  String get personalizationStyleEmpathetic;

  /// No description provided for @personalizationStyleBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get personalizationStyleBalanced;

  /// No description provided for @personalizationStyleDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct & no-nonsense'**
  String get personalizationStyleDirect;

  /// No description provided for @personalizationStyleMilitary.
  ///
  /// In en, this message translates to:
  /// **'Military-style discipline'**
  String get personalizationStyleMilitary;

  /// No description provided for @personalizationOccupationStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get personalizationOccupationStudent;

  /// No description provided for @personalizationOccupationEmployed.
  ///
  /// In en, this message translates to:
  /// **'Employed full-time'**
  String get personalizationOccupationEmployed;

  /// No description provided for @personalizationOccupationSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self-employed'**
  String get personalizationOccupationSelfEmployed;

  /// No description provided for @personalizationOccupationFreelancing.
  ///
  /// In en, this message translates to:
  /// **'Freelancer / gig worker'**
  String get personalizationOccupationFreelancing;

  /// No description provided for @personalizationOccupationUnemployed.
  ///
  /// In en, this message translates to:
  /// **'Between jobs'**
  String get personalizationOccupationUnemployed;

  /// No description provided for @personalizationOccupationCaregiving.
  ///
  /// In en, this message translates to:
  /// **'Primary caregiver'**
  String get personalizationOccupationCaregiving;

  /// No description provided for @personalizationOccupationRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get personalizationOccupationRetired;

  /// No description provided for @personalizationHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help Pilot understand your rhythm, challenges, and coaching style — everything stays on this device.'**
  String get personalizationHeroSubtitle;

  /// No description provided for @personalizationCompletionLabel.
  ///
  /// In en, this message translates to:
  /// **'filled'**
  String get personalizationCompletionLabel;

  /// No description provided for @personalizationStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Personalization on'**
  String get personalizationStatusActive;

  /// No description provided for @personalizationStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Personalization off'**
  String get personalizationStatusInactive;

  /// No description provided for @personalizationDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'What should Pilot call you?'**
  String get personalizationDisplayNameHint;

  /// No description provided for @personalizationLifestyleSection.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get personalizationLifestyleSection;

  /// No description provided for @personalizationLifestyleSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'When and how you work best'**
  String get personalizationLifestyleSectionDesc;

  /// No description provided for @personalizationCoachingSection.
  ///
  /// In en, this message translates to:
  /// **'Coaching preferences'**
  String get personalizationCoachingSection;

  /// No description provided for @personalizationCoachingSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'How Pilot should motivate and structure your plan'**
  String get personalizationCoachingSectionDesc;

  /// No description provided for @personalizationAboutSection.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get personalizationAboutSection;

  /// No description provided for @personalizationAboutSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Optional context Pilot can reference'**
  String get personalizationAboutSectionDesc;

  /// No description provided for @personalizationMilestoneGranularity.
  ///
  /// In en, this message translates to:
  /// **'Milestone sizing'**
  String get personalizationMilestoneGranularity;

  /// No description provided for @personalizationMilestoneMicro.
  ///
  /// In en, this message translates to:
  /// **'Micro-steps'**
  String get personalizationMilestoneMicro;

  /// No description provided for @personalizationMilestoneMicroDesc.
  ///
  /// In en, this message translates to:
  /// **'Tiny daily wins, low friction'**
  String get personalizationMilestoneMicroDesc;

  /// No description provided for @personalizationMilestoneBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get personalizationMilestoneBalanced;

  /// No description provided for @personalizationMilestoneBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix of quick wins and real progress'**
  String get personalizationMilestoneBalancedDesc;

  /// No description provided for @personalizationMilestoneAmbitious.
  ///
  /// In en, this message translates to:
  /// **'Ambitious'**
  String get personalizationMilestoneAmbitious;

  /// No description provided for @personalizationMilestoneAmbitiousDesc.
  ///
  /// In en, this message translates to:
  /// **'Bigger leaps, stretch goals'**
  String get personalizationMilestoneAmbitiousDesc;

  /// No description provided for @personalizationMotivationDriver.
  ///
  /// In en, this message translates to:
  /// **'What motivates you'**
  String get personalizationMotivationDriver;

  /// No description provided for @personalizationMotivationEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Encouragement'**
  String get personalizationMotivationEncouragement;

  /// No description provided for @personalizationMotivationEncouragementDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm praise and positive momentum'**
  String get personalizationMotivationEncouragementDesc;

  /// No description provided for @personalizationMotivationAccountability.
  ///
  /// In en, this message translates to:
  /// **'Accountability'**
  String get personalizationMotivationAccountability;

  /// No description provided for @personalizationMotivationAccountabilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow-through and honest check-ins'**
  String get personalizationMotivationAccountabilityDesc;

  /// No description provided for @personalizationMotivationAutonomy.
  ///
  /// In en, this message translates to:
  /// **'Autonomy'**
  String get personalizationMotivationAutonomy;

  /// No description provided for @personalizationMotivationAutonomyDesc.
  ///
  /// In en, this message translates to:
  /// **'You steer — Pilot guides lightly'**
  String get personalizationMotivationAutonomyDesc;

  /// No description provided for @personalizationMotivationChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get personalizationMotivationChallenge;

  /// No description provided for @personalizationMotivationChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Push harder, competitive edge'**
  String get personalizationMotivationChallengeDesc;

  /// No description provided for @personalizationChallengeAreas.
  ///
  /// In en, this message translates to:
  /// **'Common challenges'**
  String get personalizationChallengeAreas;

  /// No description provided for @personalizationChallengeProcrastination.
  ///
  /// In en, this message translates to:
  /// **'Procrastination'**
  String get personalizationChallengeProcrastination;

  /// No description provided for @personalizationChallengeInconsistency.
  ///
  /// In en, this message translates to:
  /// **'Inconsistency'**
  String get personalizationChallengeInconsistency;

  /// No description provided for @personalizationChallengeOverwhelm.
  ///
  /// In en, this message translates to:
  /// **'Overwhelm'**
  String get personalizationChallengeOverwhelm;

  /// No description provided for @personalizationChallengePerfectionism.
  ///
  /// In en, this message translates to:
  /// **'Perfectionism'**
  String get personalizationChallengePerfectionism;

  /// No description provided for @personalizationChallengeTimeManagement.
  ///
  /// In en, this message translates to:
  /// **'Time management'**
  String get personalizationChallengeTimeManagement;

  /// No description provided for @personalizationScheduleEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Peak energy in the morning'**
  String get personalizationScheduleEarlyBirdDesc;

  /// No description provided for @personalizationScheduleNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Most productive in the evening'**
  String get personalizationScheduleNightOwlDesc;

  /// No description provided for @personalizationScheduleFlexibleDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule shifts day to day'**
  String get personalizationScheduleFlexibleDesc;

  /// No description provided for @personalizationScheduleIrregularDesc.
  ///
  /// In en, this message translates to:
  /// **'Unpredictable or rotating hours'**
  String get personalizationScheduleIrregularDesc;

  /// No description provided for @personalizationStyleEmpatheticDesc.
  ///
  /// In en, this message translates to:
  /// **'Validates feelings, gentle nudges, no guilt trips'**
  String get personalizationStyleEmpatheticDesc;

  /// No description provided for @personalizationStyleBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Warmth plus accountability in equal measure'**
  String get personalizationStyleBalancedDesc;

  /// No description provided for @personalizationStyleDirectDesc.
  ///
  /// In en, this message translates to:
  /// **'Short, clear, action-first communication'**
  String get personalizationStyleDirectDesc;

  /// No description provided for @personalizationStyleMilitaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Strict discipline, no excuses, mission focus'**
  String get personalizationStyleMilitaryDesc;

  /// No description provided for @personalizationPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Pilot preview'**
  String get personalizationPreviewTitle;

  /// No description provided for @personalizationPreviewActiveHint.
  ///
  /// In en, this message translates to:
  /// **'This is how Pilot will adapt once you save.'**
  String get personalizationPreviewActiveHint;

  /// No description provided for @personalizationPreviewInactiveHint.
  ///
  /// In en, this message translates to:
  /// **'Turn on personalization to see a live preview.'**
  String get personalizationPreviewInactiveHint;

  /// No description provided for @personalizationPreviewInactive.
  ///
  /// In en, this message translates to:
  /// **'Pilot will use the default coaching voice until you enable personalization.'**
  String get personalizationPreviewInactive;

  /// No description provided for @personalizationPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Fill in a few fields above and Pilot will tailor milestones, tone, and motivation to you.'**
  String get personalizationPreviewEmpty;

  /// No description provided for @personalizationPreviewSample.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}, ready for today\'s flight? I\'ll keep it {style}.'**
  String personalizationPreviewSample(String name, String style);

  /// No description provided for @personalizationPreviewStyleDefault.
  ///
  /// In en, this message translates to:
  /// **'supportive but focused'**
  String get personalizationPreviewStyleDefault;

  /// No description provided for @personalizationPreviewStyleEmpathetic.
  ///
  /// In en, this message translates to:
  /// **'warm and understanding'**
  String get personalizationPreviewStyleEmpathetic;

  /// No description provided for @personalizationPreviewStyleBalanced.
  ///
  /// In en, this message translates to:
  /// **'balanced and steady'**
  String get personalizationPreviewStyleBalanced;

  /// No description provided for @personalizationPreviewStyleDirect.
  ///
  /// In en, this message translates to:
  /// **'direct and efficient'**
  String get personalizationPreviewStyleDirect;

  /// No description provided for @personalizationPreviewStyleMilitary.
  ///
  /// In en, this message translates to:
  /// **'strict and mission-focused'**
  String get personalizationPreviewStyleMilitary;

  /// No description provided for @personalizationPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Profile data is stored only on this device and sent to Google Gemini with your AI requests. Nothing is uploaded to GoalPilot servers.'**
  String get personalizationPrivacyNote;

  /// No description provided for @apiKeySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Gemini AI'**
  String get apiKeySetupTitle;

  /// No description provided for @apiKeySetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GoalPilot uses your personal Gemini API key. Google offers a free tier — you stay in control of usage and billing.'**
  String get apiKeySetupSubtitle;

  /// No description provided for @apiKeySetupHowToTitle.
  ///
  /// In en, this message translates to:
  /// **'How to get a free API key'**
  String get apiKeySetupHowToTitle;

  /// No description provided for @apiKeySetupStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open Google AI Studio'**
  String get apiKeySetupStep1Title;

  /// No description provided for @apiKeySetupStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account and open the API keys page.'**
  String get apiKeySetupStep1Desc;

  /// No description provided for @apiKeySetupStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Create an API key'**
  String get apiKeySetupStep2Title;

  /// No description provided for @apiKeySetupStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click \"Create API key\" and choose a Google Cloud project (a default project works fine).'**
  String get apiKeySetupStep2Desc;

  /// No description provided for @apiKeySetupStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Copy the key'**
  String get apiKeySetupStep3Title;

  /// No description provided for @apiKeySetupStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Copy the generated key — it starts with \"AIza\". Keep it private.'**
  String get apiKeySetupStep3Desc;

  /// No description provided for @apiKeySetupStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Paste and validate'**
  String get apiKeySetupStep4Title;

  /// No description provided for @apiKeySetupStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Paste the key below and tap Validate & save. We test it with a lightweight Gemini request.'**
  String get apiKeySetupStep4Desc;

  /// No description provided for @apiKeySetupFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Gemini API key'**
  String get apiKeySetupFieldLabel;

  /// No description provided for @apiKeySetupFieldHint.
  ///
  /// In en, this message translates to:
  /// **'AIza...'**
  String get apiKeySetupFieldHint;

  /// No description provided for @apiKeySetupFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key.'**
  String get apiKeySetupFieldRequired;

  /// No description provided for @apiKeySetupFieldTooShort.
  ///
  /// In en, this message translates to:
  /// **'That key looks too short. Copy the full key from Google AI Studio.'**
  String get apiKeySetupFieldTooShort;

  /// No description provided for @apiKeySetupValidateSave.
  ///
  /// In en, this message translates to:
  /// **'Validate & save'**
  String get apiKeySetupValidateSave;

  /// No description provided for @apiKeySetupClear.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get apiKeySetupClear;

  /// No description provided for @apiKeySetupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to GoalPilot'**
  String get apiKeySetupContinue;

  /// No description provided for @apiKeySetupSuccess.
  ///
  /// In en, this message translates to:
  /// **'API key saved and validated.'**
  String get apiKeySetupSuccess;

  /// No description provided for @apiKeySetupCleared.
  ///
  /// In en, this message translates to:
  /// **'API key removed from this device.'**
  String get apiKeySetupCleared;

  /// No description provided for @apiKeySetupStatusConfigured.
  ///
  /// In en, this message translates to:
  /// **'API key configured — AI features are ready.'**
  String get apiKeySetupStatusConfigured;

  /// No description provided for @apiKeySetupStatusMissing.
  ///
  /// In en, this message translates to:
  /// **'No API key yet — AI features need your key.'**
  String get apiKeySetupStatusMissing;

  /// No description provided for @apiKeySetupOpenStudio.
  ///
  /// In en, this message translates to:
  /// **'Open Google AI Studio'**
  String get apiKeySetupOpenStudio;

  /// No description provided for @apiKeySetupOpenStudioFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google AI Studio in the browser.'**
  String get apiKeySetupOpenStudioFailed;

  /// No description provided for @apiKeySetupPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your key is stored only in this device\'s secure storage and is sent directly to Google for AI requests.'**
  String get apiKeySetupPrivacyNote;

  /// No description provided for @apiKeySetupClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove API key?'**
  String get apiKeySetupClearConfirmTitle;

  /// No description provided for @apiKeySetupClearConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'AI features will stop working until you add a key again. Your goals and check-ins stay on this device.'**
  String get apiKeySetupClearConfirmDesc;

  /// No description provided for @homeApiKeyMissingBanner.
  ///
  /// In en, this message translates to:
  /// **'Add your Gemini API key to unlock AI features like goal planning and coaching.'**
  String get homeApiKeyMissingBanner;

  /// No description provided for @homeApiKeyMissingAction.
  ///
  /// In en, this message translates to:
  /// **'Add API key'**
  String get homeApiKeyMissingAction;

  /// No description provided for @notifChannelDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get notifChannelDaily;

  /// No description provided for @notifChannelDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders to complete your GoalPilot check-in'**
  String get notifChannelDailyDesc;

  /// No description provided for @notifChannelSmart.
  ///
  /// In en, this message translates to:
  /// **'Pilot Smart Alerts'**
  String get notifChannelSmart;

  /// No description provided for @notifChannelSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalized reminders from Pilot based on your progress'**
  String get notifChannelSmartDesc;

  /// No description provided for @notifCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for your check-in'**
  String get notifCheckInTitle;

  /// No description provided for @notifCheckInBody.
  ///
  /// In en, this message translates to:
  /// **'Open GoalPilot and tell Pilot how your goals are going today.'**
  String get notifCheckInBody;

  /// No description provided for @notifPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied.'**
  String get notifPermissionDenied;

  /// No description provided for @notifReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {time}.'**
  String notifReminderSet(String time);

  /// No description provided for @notifScheduleFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not schedule reminder: {error}'**
  String notifScheduleFailed(String error);

  /// No description provided for @notifTestTitle.
  ///
  /// In en, this message translates to:
  /// **'GoalPilot test'**
  String get notifTestTitle;

  /// No description provided for @notifTestBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are working. Your daily reminder is scheduled.'**
  String get notifTestBody;

  /// No description provided for @notifTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent.'**
  String get notifTestSent;

  /// No description provided for @notifTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Test failed: {error}'**
  String notifTestFailed(String error);

  /// No description provided for @notifPilotTitle.
  ///
  /// In en, this message translates to:
  /// **'Pilot'**
  String get notifPilotTitle;

  /// No description provided for @notifDailyFuelTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Fuel'**
  String get notifDailyFuelTitle;

  /// No description provided for @notifChannelDailyFuel.
  ///
  /// In en, this message translates to:
  /// **'Daily Fuel'**
  String get notifChannelDailyFuel;

  /// No description provided for @notifChannelDailyFuelDesc.
  ///
  /// In en, this message translates to:
  /// **'Aggressive morning motivation prepared by Pilot for your goals'**
  String get notifChannelDailyFuelDesc;

  /// No description provided for @contextualPromptLabel.
  ///
  /// In en, this message translates to:
  /// **'Micro-Dose'**
  String get contextualPromptLabel;

  /// No description provided for @motivationFallbackStreak.
  ///
  /// In en, this message translates to:
  /// **'{streak} days straight, captain. You\'re building bulletproof discipline. Let\'s finish strong today.'**
  String motivationFallbackStreak(int streak);

  /// No description provided for @motivationFallbackMissedCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Yesterday is history. Today\'s check-in is what matters. Just 1% effort is enough.'**
  String get motivationFallbackMissedCheckIn;

  /// No description provided for @motivationFallbackLowMood.
  ///
  /// In en, this message translates to:
  /// **'Even a slow step forward is still a step. Don\'t push hard today — just open the plan.'**
  String get motivationFallbackLowMood;

  /// No description provided for @motivationFallbackPending.
  ///
  /// In en, this message translates to:
  /// **'{count} check-ins waiting. One tap and you\'re back in the cockpit.'**
  String motivationFallbackPending(int count);

  /// No description provided for @motivationFallbackAllDone.
  ///
  /// In en, this message translates to:
  /// **'All check-ins done. Discipline locked in. Enjoy the momentum.'**
  String get motivationFallbackAllDone;

  /// No description provided for @motivationFallbackSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady flight on \"{title}\". Pilot has the course — keep the pace.'**
  String motivationFallbackSteady(String title);

  /// No description provided for @motivationFallbackDefault.
  ///
  /// In en, this message translates to:
  /// **'Captain, your goals are waiting. One small move today beats zero.'**
  String get motivationFallbackDefault;

  /// No description provided for @motivationFallbackDailyFuel.
  ///
  /// In en, this message translates to:
  /// **'[{goal}] Day {day}. Today you conquer {focus}. No excuses — let\'s fly.'**
  String motivationFallbackDailyFuel(String goal, int day, String focus);

  /// No description provided for @motivationFallbackDailyFuelDefault.
  ///
  /// In en, this message translates to:
  /// **'GoalPilot: Day 1. Open the app. One step. No excuses.'**
  String get motivationFallbackDailyFuelDefault;

  /// No description provided for @shareProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress: {percent}%'**
  String shareProgressLabel(int percent);

  /// No description provided for @shareStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak: {count} {count, plural, =1{day} other{days}}'**
  String shareStreak(int count);

  /// No description provided for @shareMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones: {completed}/{total}'**
  String shareMilestones(int completed, int total);

  /// No description provided for @shareCurrentFocus.
  ///
  /// In en, this message translates to:
  /// **'Current focus: {title}'**
  String shareCurrentFocus(String title);

  /// No description provided for @shareDailyHabit.
  ///
  /// In en, this message translates to:
  /// **'Daily habit: {habit}'**
  String shareDailyHabit(String habit);

  /// No description provided for @shareTrackedWith.
  ///
  /// In en, this message translates to:
  /// **'Tracked with GoalPilot ✈️'**
  String get shareTrackedWith;

  /// No description provided for @shareGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'I\'m getting started with GoalPilot! ✈️'**
  String get shareGettingStarted;

  /// No description provided for @shareMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My GoalPilot Progress ✈️'**
  String get shareMyProgress;

  /// No description provided for @shareAvgProgress.
  ///
  /// In en, this message translates to:
  /// **'Average progress: {percent}%'**
  String shareAvgProgress(int percent);

  /// No description provided for @shareWeeklyReviewHeader.
  ///
  /// In en, this message translates to:
  /// **'GoalPilot Weekly Review ✈️'**
  String get shareWeeklyReviewHeader;

  /// No description provided for @shareActiveGoals.
  ///
  /// In en, this message translates to:
  /// **'Active goals: {count}'**
  String shareActiveGoals(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
