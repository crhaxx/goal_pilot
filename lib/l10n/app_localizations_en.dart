// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'GoalPilot';

  @override
  String get appTagline => 'Navigate your goals with AI';

  @override
  String get navHome => 'Home';

  @override
  String get navGoals => 'Goals';

  @override
  String get navReview => 'Review';

  @override
  String get navSettings => 'Settings';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get share => 'Share';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String couldNotLoad(String error) {
    return 'Could not load: $error';
  }

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get onboardingWelcomeDesc =>
      'Your AI navigator for reaching goals. Explore the main features, then take off.';

  @override
  String get onboardingGoalTitle => 'Set your goal';

  @override
  String get onboardingGoalDesc =>
      'Enter a goal and AI breaks it into milestones and daily tasks.';

  @override
  String get onboardingDailyTitle => 'Daily plan & check-in';

  @override
  String get onboardingDailyDesc =>
      'See your daily focus. Check-ins with Pilot keep you on track.';

  @override
  String get onboardingCoachTitle => 'AI coach Pilot';

  @override
  String get onboardingCoachDesc =>
      'Ask Pilot, practice tough situations, or get motivation when it gets hard.';

  @override
  String get onboardingReviewTitle => 'Weekly review';

  @override
  String get onboardingReviewDesc =>
      'Each week, review progress, streaks, and what to improve next.';

  @override
  String get onboardingReadyTitle => 'Ready to go?';

  @override
  String onboardingReadyDesc(String appName) {
    return 'Create your first goal and let $appName navigate your journey.';
  }

  @override
  String get languageSelectTitle => 'Choose your language';

  @override
  String get languageSelectDesc => 'You can change this anytime in Settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageContinue => 'Continue';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsDailyReminder => 'Daily check-in reminder';

  @override
  String get settingsDailyReminderDesc =>
      'Local notification at your chosen time every day';

  @override
  String get settingsReminderTime => 'Reminder time';

  @override
  String get settingsTestNotification => 'Test notification';

  @override
  String get settingsTestNotificationDesc =>
      'Send one now to verify everything works';

  @override
  String get settingsBatteryTip =>
      'Tip: On Xiaomi/Samsung, disable battery optimization for GoalPilot if reminders are delayed.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsPoweredByGemini => 'Powered by Gemini AI';

  @override
  String get settingsPoweredByGeminiDesc =>
      'Goal decomposition, coaching & reviews';

  @override
  String get notificationPermissionDenied =>
      'Allow notifications in system settings, then try again.';

  @override
  String get reminderUpdated => 'Reminder updated.';

  @override
  String get failed => 'Failed.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get statActiveGoals => 'Active goals';

  @override
  String get statBestStreak => 'Best streak';

  @override
  String get statCheckIns7d => 'Check-ins (7d)';

  @override
  String get statAvgProgress => 'Avg progress';

  @override
  String get newGoal => 'New Goal';

  @override
  String get createFirstGoal => 'Create your first goal';

  @override
  String get todaysFocus => 'Today\'s Focus';

  @override
  String pendingCount(int count) {
    return '$count pending';
  }

  @override
  String get allCheckInsDone => 'All check-ins done for today. Great work!';

  @override
  String emptyHomeWelcome(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get emptyHomeDesc =>
      'Set a goal, get a daily plan, check in with Pilot, and review your progress every week.';

  @override
  String get homeOverview => 'Overview';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get homeProgressLabel => 'Overall';

  @override
  String get emptyHomeFeaturePlan => 'AI milestone planning';

  @override
  String get emptyHomeFeatureCheckIn => 'Daily Pilot check-ins';

  @override
  String get emptyHomeFeatureReview => 'Weekly progress reviews';

  @override
  String get myGoals => 'My Goals';

  @override
  String get newGoalTooltip => 'New goal';

  @override
  String get noGoalsYet => 'No goals yet';

  @override
  String get noGoalsDesc => 'Create a goal and Pilot will build your plan.';

  @override
  String get createGoalTitle => 'New Goal';

  @override
  String get createGoalHeadline => 'What do you want to achieve?';

  @override
  String get createGoalDesc =>
      'Describe your goal in your own words. Pilot will break it into 4–6 actionable milestones.';

  @override
  String get createGoalHint => 'e.g. Learn Flutter in 3 months';

  @override
  String get createGoalValidation => 'Enter at least 5 characters.';

  @override
  String get createGoalPlanning => 'Pilot is planning your milestones…';

  @override
  String get goalPriorityLabel => 'Goal importance';

  @override
  String get goalPriorityDesc =>
      'Sets how prominently this goal appears in your list and today\'s focus.';

  @override
  String get goalPriorityLow => 'Low';

  @override
  String get goalPriorityLowDesc =>
      'Nice to have — focus on it when time allows.';

  @override
  String get goalPriorityMedium => 'Medium';

  @override
  String get goalPriorityMediumDesc =>
      'Balanced attention alongside your other goals.';

  @override
  String get goalPriorityHigh => 'High';

  @override
  String get goalPriorityHighDesc =>
      'Important — Pilot surfaces it ahead of lower goals.';

  @override
  String get goalPriorityCritical => 'Critical';

  @override
  String get goalPriorityCriticalDesc => 'Top priority — always shown first.';

  @override
  String get goalPriorityUpdated => 'Priority updated.';

  @override
  String get changeGoalPriority => 'Change priority';

  @override
  String get deleteGoal => 'Delete goal';

  @override
  String get deleteGoalTitle => 'Delete goal?';

  @override
  String deleteGoalConfirm(String title) {
    return 'This will permanently remove \"$title\" and all its progress.';
  }

  @override
  String get deleteGoalButton => 'Delete';

  @override
  String get deleteGoalSuccess => 'Goal deleted.';

  @override
  String get goalActionsTooltip => 'Goal actions';

  @override
  String get cancel => 'Cancel';

  @override
  String get generatePlan => 'Generate Plan';

  @override
  String get scheduleSectionTitle => 'When do you work on this?';

  @override
  String get scheduleSectionDesc =>
      'Pilot adapts milestones and streak to your schedule.';

  @override
  String get scheduleEveryDay => 'Every day';

  @override
  String get scheduleEveryDayDesc => 'Daily check-ins and micro-tasks.';

  @override
  String get scheduleTimesPerWeek => 'X times a week';

  @override
  String get scheduleTimesPerWeekDesc =>
      'Pick frequency and days — or let Pilot suggest them.';

  @override
  String get scheduleWeekendsOnly => 'Weekends only';

  @override
  String get scheduleWeekendsOnlyDesc =>
      'Saturday and Sunday — weekdays are rest days.';

  @override
  String get schedulePickDays => 'Tap the days you have time (optional)';

  @override
  String scheduleTimesLabel(int count) {
    return '$count× per week';
  }

  @override
  String get scheduleWeekdayMon => 'Mon';

  @override
  String get scheduleWeekdayTue => 'Tue';

  @override
  String get scheduleWeekdayWed => 'Wed';

  @override
  String get scheduleWeekdayThu => 'Thu';

  @override
  String get scheduleWeekdayFri => 'Fri';

  @override
  String get scheduleWeekdaySat => 'Sat';

  @override
  String get scheduleWeekdaySun => 'Sun';

  @override
  String get restDaySection => 'Rest day';

  @override
  String get restDayNextStepTomorrow => 'Next step awaits you tomorrow';

  @override
  String restDayNextStepOn(String date) {
    return 'Next step on $date';
  }

  @override
  String get restDayPaused => 'Rest day — no check-in needed';

  @override
  String get goalNotFound => 'Goal not found.';

  @override
  String get shareProgress => 'Share progress';

  @override
  String get tabToday => 'Today';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabJournal => 'Journal';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkedIn => 'Checked in';

  @override
  String get dailyHabit => 'Daily Habit';

  @override
  String get currentMilestone => 'Current Milestone';

  @override
  String get pilotTips => 'Pilot Tips';

  @override
  String get emergencySteps => 'Emergency steps';

  @override
  String get todaysTasks => 'Today\'s Tasks';

  @override
  String get allMilestonesComplete => 'All milestones complete!';

  @override
  String get noTasksYet =>
      'No tasks yet — create a new goal or wait for Pilot to generate tasks.';

  @override
  String get doneWallThisGoal => 'This goal\'s win wall';

  @override
  String get pivotSuggested => 'Pilot suggests a plan pivot';

  @override
  String get fireDrillSimulator => 'Fire drill simulator';

  @override
  String get milestones => 'Milestones';

  @override
  String get pivotWizardEdit => 'Pivot Wizard — edit plan';

  @override
  String get launchSimulator => 'Launch simulator';

  @override
  String get noMicroTasks => 'No micro-tasks for this milestone';

  @override
  String get markMilestoneComplete => 'Mark milestone complete';

  @override
  String get noCheckInsYet =>
      'No check-ins yet. Complete your first daily check-in to start the journal.';

  @override
  String moodLabel(int mood) {
    return 'Mood: $mood/5';
  }

  @override
  String tasksLabel(int completed, int total) {
    return 'Tasks: $completed/$total';
  }

  @override
  String progressMilestones(int percent, int completed, int total) {
    return '$percent% · $completed/$total milestones';
  }

  @override
  String milestonesCount(int completed, int total) {
    return '$completed/$total milestones';
  }

  @override
  String get checkInPending => 'Check-in pending';

  @override
  String focusLabel(String title) {
    return 'Focus: $title';
  }

  @override
  String todayTasksDone(int completed, int total) {
    return 'Today: $completed/$total tasks done';
  }

  @override
  String get dailyCheckIn => 'Daily Check-in';

  @override
  String get checkedInToday => 'Checked in today';

  @override
  String get dailyTask => 'Daily task';

  @override
  String get oneTimeTask => 'One-time task';

  @override
  String get addCustomTaskTitle => 'Add your task';

  @override
  String get addCustomTaskDesc =>
      'Supplement Pilot\'s plan with your own steps for this milestone.';

  @override
  String get addCustomTaskHint => 'What do you want to work on?';

  @override
  String get addCustomTaskMilestone => 'Milestone';

  @override
  String get addCustomTaskType => 'Task type';

  @override
  String get addCustomTaskButton => 'Add task';

  @override
  String get addCustomTaskAction => 'Add your task';

  @override
  String get yourTaskLabel => 'Your task';

  @override
  String get removeCustomTask => 'Remove task';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String get checkInTitle => 'Daily Check-in';

  @override
  String get howFeelingToday => 'How are you feeling today?';

  @override
  String get moodRough => 'Rough';

  @override
  String get moodLow => 'Low';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodGood => 'Good';

  @override
  String get moodGreat => 'Great';

  @override
  String get checkInNoteHint => 'What did you work on today? (optional)';

  @override
  String tasksTodayCompleted(int completed, int total) {
    return 'Tasks today: $completed/$total completed';
  }

  @override
  String get antiGoalSection => 'Sabotage trap';

  @override
  String get antiGoalWhich => 'Which saboteur to avoid?';

  @override
  String antiGoalSurrenderedQuestion(String title) {
    return 'Did you give in to \"$title\" today?';
  }

  @override
  String get antiGoalYes => 'Yes, gave in';

  @override
  String get antiGoalNo => 'No, stayed strong';

  @override
  String get pilotSays => 'Pilot says';

  @override
  String get pilotThinking => 'Pilot is thinking…';

  @override
  String get completeCheckIn => 'Complete Check-in';

  @override
  String get crisisDetectedSnack =>
      'Pilot detected a crisis — consider activating emergency mode in the goal detail.';

  @override
  String get crisisMode => 'Crisis mode';

  @override
  String get activateEmergencyMode => 'Activate emergency mode';

  @override
  String get pilotPreparing => 'Pilot is preparing…';

  @override
  String get emergencyModeActivated =>
      'Emergency mode activated — atomic steps only.';

  @override
  String get emergencyModeActive => 'Emergency mode active';

  @override
  String get emergencyModeHint =>
      'Today, these atomic steps are enough — no extra pressure.';

  @override
  String get exitEmergencyMode => 'Exit emergency mode';

  @override
  String get crisisReasonNote =>
      'Your check-in signals it\'s too much. Pilot suggests emergency mode with minimal steps.';

  @override
  String crisisReasonDays(int days, String title) {
    return 'No check-in for $days days on \"$title\". Try emergency mode — atomic steps only.';
  }

  @override
  String get pivotWizard => 'Pivot Wizard';

  @override
  String get pivotContinue => 'Continue';

  @override
  String get pivotDetected => 'Pilot detected recurring difficulties';

  @override
  String get pivotReshaping => 'Pilot is reshaping the plan…';

  @override
  String get launchPivot => 'Launch Pivot';

  @override
  String pivotSuccess(int streak) {
    return 'Plan updated — $streak-day streak preserved. Check-in history kept.';
  }

  @override
  String pivotReason(String moods, String notes) {
    return 'Recent check-ins show mood $moods/5.$notes';
  }

  @override
  String pivotReasonNotes(String notes) {
    return ' Notes: $notes';
  }

  @override
  String get realityCheck => 'Reality Check';

  @override
  String realityCheckLocked(int days, int checkIns) {
    return 'Unlocks after $days days or $checkIns check-ins.';
  }

  @override
  String get realityMirror => 'Reality mirror';

  @override
  String get realityCheckReady =>
      'Pilot is ready to compare your plan with real check-in and journal data.';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get pilotAnalyzing => 'Pilot is analyzing…';

  @override
  String get runRealityCheck => 'Run Reality Check';

  @override
  String get refreshAnalysis => 'Refresh analysis';

  @override
  String pilotWarns(String message) {
    return 'Pilot warns: $message';
  }

  @override
  String get askPilot => 'Ask Pilot';

  @override
  String get saboteurProfile => 'Saboteur profile';

  @override
  String get saboteurDesc =>
      '3 things that will sink you — track them in check-ins.';

  @override
  String triggerLabel(String trigger) {
    return 'Trigger: $trigger';
  }

  @override
  String costLabel(String cost) {
    return 'Cost: $cost';
  }

  @override
  String get pilotCoach => 'Pilot Coach';

  @override
  String pilotCoachEmpty(String title) {
    return 'Hi! I\'m Pilot. How can I help you with \"$title\" today?';
  }

  @override
  String get messagePilotHint => 'Message Pilot…';

  @override
  String get roleplayUnavailable => 'Roleplay is not available.';

  @override
  String roleplaySimulator(String title) {
    return 'Simulator: $title';
  }

  @override
  String roleplayMessagesToEval(int count, int total) {
    return '$count/$total messages until evaluation';
  }

  @override
  String roleplayScore(int score) {
    return 'Score: $score/100';
  }

  @override
  String get roleplayImprove => 'What to improve:';

  @override
  String get roleplayEmpty => 'Write your first message and start training.';

  @override
  String get roleplayReplyHint => 'Your reply…';

  @override
  String get roleplayComplete => 'Training complete';

  @override
  String get doneWall => 'Win wall';

  @override
  String get doneWallEmpty =>
      'The win wall fills up — complete micro-tasks or write a great check-in.';

  @override
  String doneWallMore(int count) {
    return '+$count';
  }

  @override
  String get doneWallLegendTask => 'Task';

  @override
  String get doneWallLegendCheckIn => 'Check-in';

  @override
  String get doneWallLegendTap => 'Tap';

  @override
  String get pilotEmergencyHeadline =>
      'Emergency mode — keeping you in the game';

  @override
  String pilotEmergencySubtitle(String title) {
    return 'For \"$title\", atomic steps are enough. No extra pressure.';
  }

  @override
  String get pilotMissionCompleteHeadline => 'Mission complete, captain!';

  @override
  String pilotMissionCompleteSubtitle(String title) {
    return 'Pilot celebrates your success on \"$title\".';
  }

  @override
  String get pilotClearSkiesHeadline => 'Clear skies, captain';

  @override
  String pilotClearSkiesSubtitle(int streak, String title) {
    return '$streak-day streak on \"$title\". Cockpit is green.';
  }

  @override
  String get pilotTurbulenceHeadline => 'Turbulence — need a restart';

  @override
  String pilotTurbulenceSubtitle(String title) {
    return 'Missing check-in on \"$title\". Pilot awaits your signal.';
  }

  @override
  String get pilotCheckInWaitingHeadline =>
      'Cockpit blinking — check-in waiting';

  @override
  String pilotCheckInWaitingSubtitle(int streak, String title) {
    return '$streak-day streak on \"$title\". Don\'t lose momentum.';
  }

  @override
  String get pilotSteadyHeadline => 'Steady flight';

  @override
  String pilotSteadySubtitle(String title) {
    return 'Pilot is tracking \"$title\". You\'re on course.';
  }

  @override
  String get pilotReadyHeadline => 'Pilot is ready';

  @override
  String get pilotReadySubtitle =>
      'Create your first goal and start the mission.';

  @override
  String get pilotEmergencyBoardHeadline => 'Emergency mode on board';

  @override
  String pilotEmergencyBoardSubtitle(int count) {
    return '$count goals in emergency mode — atomic steps are enough.';
  }

  @override
  String get pilotTurbulenceReportHeadline => 'Pilot reports turbulence';

  @override
  String pilotTurbulenceReportSubtitle(int count) {
    return '$count goals need emergency mode. Don\'t lose momentum.';
  }

  @override
  String get pilotTurbulenceBoardHeadline => 'Turbulence on board';

  @override
  String pilotTurbulenceBoardSubtitle(int count) {
    return '$count goals waiting for check-in. Pilot needs you.';
  }

  @override
  String get pilotAllCheckInsHeadline => 'Clear skies, captain';

  @override
  String get pilotAllCheckInsSubtitle =>
      'All check-ins done. Discipline on board.';

  @override
  String get pilotOneCheckInHeadline => 'One check-in missing';

  @override
  String get pilotOneCheckInSubtitle =>
      'Complete it today — Pilot holds the course.';

  @override
  String pilotActiveGoalsSubtitle(int count) {
    return '$count active goals. Keep the pace.';
  }

  @override
  String get weeklyReview => 'Weekly Review';

  @override
  String get pilotWeeklyReview => 'Pilot Weekly Review';

  @override
  String get weeklyReviewDesc =>
      'Once a week, Pilot analyzes your check-ins, streaks, and tasks — then suggests what to focus on next.';

  @override
  String get generating => 'Generating…';

  @override
  String get generateWeeklyReview => 'Generate This Week\'s Review';

  @override
  String get noReviewsYet =>
      'No reviews yet. Generate your first weekly review above.';

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String get shareReview => 'Share review';

  @override
  String get highlights => 'Highlights';

  @override
  String get nextSteps => 'Next Steps';

  @override
  String get failureGeneric => 'Something went wrong. Please try again.';

  @override
  String get failureNetwork => 'Check your connection and try again.';

  @override
  String get failureParse => 'Could not understand the AI response.';

  @override
  String get failureCache => 'Could not save or load your data.';

  @override
  String get failureTimeout => 'Request timed out. Please try again.';

  @override
  String get failureQuota =>
      'Gemini API quota exceeded. Wait a minute and try again, or enable billing in Google AI Studio.';

  @override
  String failureRetrySeconds(String message, int seconds) {
    return '$message\nTry again in about $seconds seconds.';
  }

  @override
  String get failureModelUnavailable =>
      'Gemini model unavailable. Update GEMINI_MODEL in .env (try gemini-3.1-flash-lite or gemini-3.5-flash).';

  @override
  String get notifChannelDaily => 'Daily Check-in';

  @override
  String get notifChannelDailyDesc =>
      'Reminders to complete your GoalPilot check-in';

  @override
  String get notifChannelSmart => 'Pilot Smart Alerts';

  @override
  String get notifChannelSmartDesc =>
      'Personalized reminders from Pilot based on your progress';

  @override
  String get notifCheckInTitle => 'Time for your check-in';

  @override
  String get notifCheckInBody =>
      'Open GoalPilot and tell Pilot how your goals are going today.';

  @override
  String get notifPermissionDenied => 'Notification permission was denied.';

  @override
  String notifReminderSet(String time) {
    return 'Reminder set for $time.';
  }

  @override
  String notifScheduleFailed(String error) {
    return 'Could not schedule reminder: $error';
  }

  @override
  String get notifTestTitle => 'GoalPilot test';

  @override
  String get notifTestBody =>
      'Notifications are working. Your daily reminder is scheduled.';

  @override
  String get notifTestSent => 'Test notification sent.';

  @override
  String notifTestFailed(String error) {
    return 'Test failed: $error';
  }

  @override
  String get notifPilotTitle => 'Pilot';

  @override
  String get notifDailyFuelTitle => 'Daily Fuel';

  @override
  String get notifChannelDailyFuel => 'Daily Fuel';

  @override
  String get notifChannelDailyFuelDesc =>
      'Aggressive morning motivation prepared by Pilot for your goals';

  @override
  String get contextualPromptLabel => 'Micro-Dose';

  @override
  String motivationFallbackStreak(int streak) {
    return '$streak days straight, captain. You\'re building bulletproof discipline. Let\'s finish strong today.';
  }

  @override
  String get motivationFallbackMissedCheckIn =>
      'Yesterday is history. Today\'s check-in is what matters. Just 1% effort is enough.';

  @override
  String get motivationFallbackLowMood =>
      'Even a slow step forward is still a step. Don\'t push hard today — just open the plan.';

  @override
  String motivationFallbackPending(int count) {
    return '$count check-ins waiting. One tap and you\'re back in the cockpit.';
  }

  @override
  String get motivationFallbackAllDone =>
      'All check-ins done. Discipline locked in. Enjoy the momentum.';

  @override
  String motivationFallbackSteady(String title) {
    return 'Steady flight on \"$title\". Pilot has the course — keep the pace.';
  }

  @override
  String get motivationFallbackDefault =>
      'Captain, your goals are waiting. One small move today beats zero.';

  @override
  String motivationFallbackDailyFuel(String goal, int day, String focus) {
    return '[$goal] Day $day. Today you conquer $focus. No excuses — let\'s fly.';
  }

  @override
  String get motivationFallbackDailyFuelDefault =>
      'GoalPilot: Day 1. Open the app. One step. No excuses.';

  @override
  String shareProgressLabel(int percent) {
    return 'Progress: $percent%';
  }

  @override
  String shareStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'Streak: $count $_temp0';
  }

  @override
  String shareMilestones(int completed, int total) {
    return 'Milestones: $completed/$total';
  }

  @override
  String shareCurrentFocus(String title) {
    return 'Current focus: $title';
  }

  @override
  String shareDailyHabit(String habit) {
    return 'Daily habit: $habit';
  }

  @override
  String get shareTrackedWith => 'Tracked with GoalPilot ✈️';

  @override
  String get shareGettingStarted => 'I\'m getting started with GoalPilot! ✈️';

  @override
  String get shareMyProgress => 'My GoalPilot Progress ✈️';

  @override
  String shareAvgProgress(int percent) {
    return 'Average progress: $percent%';
  }

  @override
  String get shareWeeklyReviewHeader => 'GoalPilot Weekly Review ✈️';

  @override
  String shareActiveGoals(int count) {
    return 'Active goals: $count';
  }
}
