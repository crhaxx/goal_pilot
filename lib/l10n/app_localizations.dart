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

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

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
  /// **'Goal decomposition, coaching & reviews'**
  String get settingsPoweredByGeminiDesc;

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

  /// No description provided for @generatePlan.
  ///
  /// In en, this message translates to:
  /// **'Generate Plan'**
  String get generatePlan;

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

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @allMilestonesComplete.
  ///
  /// In en, this message translates to:
  /// **'All milestones complete!'**
  String get allMilestonesComplete;

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
  /// **'Turbulence — need a restart'**
  String get pilotTurbulenceHeadline;

  /// No description provided for @pilotTurbulenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Missing check-in on \"{title}\". Pilot awaits your signal.'**
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
  /// **'Gemini model unavailable. Update GEMINI_MODEL in .env (try gemini-3.1-flash-lite or gemini-3.5-flash).'**
  String get failureModelUnavailable;

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
