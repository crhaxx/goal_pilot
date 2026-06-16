// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appName => 'GoalPilot';

  @override
  String get appTagline => 'Naviguj svými cíli s AI';

  @override
  String get navHome => 'Domů';

  @override
  String get navGoals => 'Cíle';

  @override
  String get navReview => 'Review';

  @override
  String get navProfile => 'Můj profil';

  @override
  String get navSettings => 'Nastavení';

  @override
  String get skip => 'Přeskočit';

  @override
  String get next => 'Další';

  @override
  String get getStarted => 'Začít';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Hotovo';

  @override
  String get back => 'Zpět';

  @override
  String get share => 'Sdílet';

  @override
  String errorPrefix(String error) {
    return 'Chyba: $error';
  }

  @override
  String couldNotLoad(String error) {
    return 'Nepodařilo se načíst: $error';
  }

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Vítej v $appName';
  }

  @override
  String get onboardingWelcomeDesc =>
      'Tvůj AI navigátor pro dosažení cílů. Projdi si hlavní funkce a pak vyraž na cestu.';

  @override
  String get onboardingGoalTitle => 'Nastav si cíl';

  @override
  String get onboardingGoalDesc =>
      'Zadej cíl a AI ti ho rozloží na milníky a konkrétní denní úkoly.';

  @override
  String get onboardingDailyTitle => 'Denní plán a check-in';

  @override
  String get onboardingDailyDesc =>
      'Každý den vidíš, na co se soustředit. Check-in s Pilotem tě udrží v tempu.';

  @override
  String get onboardingCoachTitle => 'AI kouč Pilot';

  @override
  String get onboardingCoachDesc =>
      'Zeptej se Pilota, procvič si těžké situace nebo získej motivaci, když to bude těžké.';

  @override
  String get onboardingReviewTitle => 'Týdenní review';

  @override
  String get onboardingReviewDesc =>
      'Každý týden vyhodnoť pokrok, streaky a zjisti, co zlepšit dál.';

  @override
  String get onboardingReadyTitle => 'Jsi připraven?';

  @override
  String onboardingReadyDesc(String appName) {
    return 'Vytvoř první cíl a nech $appName navigovat tvou cestu.';
  }

  @override
  String get languageSelectTitle => 'Vyber jazyk';

  @override
  String get languageSelectDesc => 'Kdykoli to můžeš změnit v Nastavení.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageContinue => 'Pokračovat';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsNotifications => 'Notifikace';

  @override
  String get settingsDailyReminder => 'Denní připomínka check-inu';

  @override
  String get settingsDailyReminderDesc =>
      'Lokální notifikace ve zvolený čas každý den';

  @override
  String get settingsDailyFuelReminder => 'Ranní připomínka Daily Fuel';

  @override
  String get settingsDailyFuelReminderDesc =>
      'Ranní motivace od Pilota v 7:00 v aktivní dny';

  @override
  String get settingsReminderTime => 'Čas připomínky';

  @override
  String get settingsTestNotification => 'Test notifikace';

  @override
  String get settingsTestNotificationDesc =>
      'Odeslat hned pro ověření, že vše funguje';

  @override
  String get settingsBatteryTip =>
      'Tip: Na Xiaomi/Samsung vypni optimalizaci baterie pro GoalPilot, pokud se připomínky zpožďují.';

  @override
  String get settingsAppearance => 'Vzhled';

  @override
  String get settingsThemeSystem => 'Systém';

  @override
  String get settingsThemeLight => 'Světlý';

  @override
  String get settingsThemeDark => 'Tmavý';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsAbout => 'O aplikaci';

  @override
  String settingsVersion(String version) {
    return 'Verze $version';
  }

  @override
  String get settingsPoweredByGemini => 'Powered by Gemini AI';

  @override
  String get settingsPoweredByGeminiDesc =>
      'Rozklad cílů, koučink a review — poháněno tvým Gemini API klíčem';

  @override
  String get settingsAboutFeaturesTitle => 'Co GoalPilot umí';

  @override
  String get settingsAboutPrivacyTitle => 'Soukromí na prvním místě';

  @override
  String get settingsAboutPrivacyDesc =>
      'Cíle, check-iny a review zůstávají v zařízení. Gemini API klíč je uložen v zabezpečeném úložišti a posílá se pouze Googlu pro AI požadavky.';

  @override
  String settingsGeminiModel(String model) {
    return 'Model: $model';
  }

  @override
  String get settingsShareApp => 'Sdílet GoalPilot';

  @override
  String get settingsShareAppDesc => 'Pozvi kamarády k navigaci vlastních cílů';

  @override
  String get settingsShareAppMessage =>
      'Sleduju své cíle v GoalPilot — AI plánování, denní check-iny a týdenní review. ✈️';

  @override
  String get notificationPermissionDenied =>
      'Povol notifikace v nastavení systému a zkus to znovu.';

  @override
  String get reminderUpdated => 'Připomínka aktualizována.';

  @override
  String get failed => 'Selhalo.';

  @override
  String get greetingMorning => 'Dobré ráno';

  @override
  String get greetingAfternoon => 'Dobré odpoledne';

  @override
  String get greetingEvening => 'Dobrý večer';

  @override
  String get statActiveGoals => 'Aktivní cíle';

  @override
  String get statBestStreak => 'Nejdelší streak';

  @override
  String get statCheckIns7d => 'Check-iny (7 dní)';

  @override
  String get statAvgProgress => 'Prům. pokrok';

  @override
  String get newGoal => 'Nový cíl';

  @override
  String get createFirstGoal => 'Vytvoř první cíl';

  @override
  String get todaysFocus => 'Dnešní fokus';

  @override
  String pendingCount(int count) {
    return '$count čeká';
  }

  @override
  String get allCheckInsDone =>
      'Všechny check-iny na dnes hotové. Skvělá práce!';

  @override
  String emptyHomeWelcome(String appName) {
    return 'Vítej v $appName';
  }

  @override
  String get emptyHomeDesc =>
      'Nastav cíl, získej denní plán, check-in s Pilotem a každý týden vyhodnoť pokrok.';

  @override
  String get homeOverview => 'Přehled';

  @override
  String get homeQuickActions => 'Rychlé akce';

  @override
  String get homeProgressLabel => 'Celkově';

  @override
  String get emptyHomeFeaturePlan => 'AI plánování milníků';

  @override
  String get emptyHomeFeatureCheckIn => 'Denní check-iny s Pilotem';

  @override
  String get emptyHomeFeatureReview => 'Týdenní vyhodnocení pokroku';

  @override
  String get myGoals => 'Moje cíle';

  @override
  String get newGoalTooltip => 'Nový cíl';

  @override
  String get noGoalsYet => 'Zatím žádné cíle';

  @override
  String get noGoalsDesc => 'Vytvoř cíl a Pilot ti sestaví plán.';

  @override
  String get createGoalTitle => 'Nový cíl';

  @override
  String get createGoalHeadline => 'Čeho chceš dosáhnout?';

  @override
  String get createGoalDesc =>
      'Popiš cíl vlastními slovy. Pilot ho rozloží na 4–6 akčních milníků.';

  @override
  String get createGoalHint => 'např. Naučit se Flutter za 3 měsíce';

  @override
  String get createGoalValidation => 'Zadej alespoň 5 znaků.';

  @override
  String get createGoalPlanning => 'Pilot plánuje tvé milníky…';

  @override
  String get goalPriorityLabel => 'Důležitost cíle';

  @override
  String get goalPriorityDesc =>
      'Určuje pořadí cílů v seznamu a při výběru dnešního fokusu.';

  @override
  String get goalPriorityLow => 'Nízká';

  @override
  String get goalPriorityLowDesc => 'V pozadí — řešíš ho, když zbude čas.';

  @override
  String get goalPriorityMedium => 'Střední';

  @override
  String get goalPriorityMediumDesc => 'Standardní cíl — vyvážená pozornost.';

  @override
  String get goalPriorityHigh => 'Vysoká';

  @override
  String get goalPriorityHighDesc =>
      'Důležitý — Pilot ho upřednostní před méně důležitými.';

  @override
  String get goalPriorityCritical => 'Kritická';

  @override
  String get goalPriorityCriticalDesc =>
      'Nejvyšší priorita — vždy na prvním místě.';

  @override
  String get goalPriorityUpdated => 'Priorita aktualizována.';

  @override
  String get changeGoalPriority => 'Změnit prioritu';

  @override
  String get deleteGoal => 'Smazat cíl';

  @override
  String get deleteGoalTitle => 'Smazat cíl?';

  @override
  String deleteGoalConfirm(String title) {
    return 'Trvale odstraní cíl \"$title\" včetně veškerého pokroku.';
  }

  @override
  String get deleteGoalButton => 'Smazat';

  @override
  String get deleteGoalSuccess => 'Cíl byl smazán.';

  @override
  String get goalActionsTooltip => 'Akce s cílem';

  @override
  String get cancel => 'Zrušit';

  @override
  String get generatePlan => 'Vygenerovat plán';

  @override
  String get scheduleSectionTitle => 'Kdy na tom pracuješ?';

  @override
  String get scheduleSectionDesc =>
      'Pilot přizpůsobí milníky a streak tvému rozvrhu.';

  @override
  String get scheduleEveryDay => 'Každý den';

  @override
  String get scheduleEveryDayDesc => 'Denní check-iny a micro-úkoly.';

  @override
  String get scheduleTimesPerWeek => 'X× týdně';

  @override
  String get scheduleTimesPerWeekDesc =>
      'Zvol frekvenci a dny — nebo nech Pilot navrhnout.';

  @override
  String get scheduleWeekendsOnly => 'Pouze víkendy';

  @override
  String get scheduleWeekendsOnlyDesc =>
      'Sobota a neděle — všední dny jsou volno.';

  @override
  String get schedulePickDays => 'Klikni na dny, kdy máš čas (volitelné)';

  @override
  String scheduleTimesLabel(int count) {
    return '$count× týdně';
  }

  @override
  String get scheduleWeekdayMon => 'Po';

  @override
  String get scheduleWeekdayTue => 'Út';

  @override
  String get scheduleWeekdayWed => 'St';

  @override
  String get scheduleWeekdayThu => 'Čt';

  @override
  String get scheduleWeekdayFri => 'Pá';

  @override
  String get scheduleWeekdaySat => 'So';

  @override
  String get scheduleWeekdaySun => 'Ne';

  @override
  String get scheduleUpdated => 'Rozvrh aktualizován.';

  @override
  String get restDaySection => 'Den odpočinku';

  @override
  String get restDayNextStepTomorrow => 'Další krok tě čeká zítra';

  @override
  String restDayNextStepOn(String date) {
    return 'Další krok $date';
  }

  @override
  String get restDayPaused => 'Den odpočinku — check-in nepotřebuješ';

  @override
  String get goalNotFound => 'Cíl nenalezen.';

  @override
  String get shareProgress => 'Sdílet pokrok';

  @override
  String get tabToday => 'Dnes';

  @override
  String get tabPlan => 'Plán';

  @override
  String get tabJournal => 'Deník';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkedIn => 'Check-in hotov';

  @override
  String get dailyHabit => 'Denní návyk';

  @override
  String get currentMilestone => 'Aktuální milník';

  @override
  String get pilotTips => 'Tipy Pilota';

  @override
  String get emergencySteps => 'Nouzové kroky';

  @override
  String get todaysTasks => 'Dnešní úkoly';

  @override
  String get allMilestonesComplete => 'Všechny milníky splněny!';

  @override
  String get addMoreMilestones => 'Přidat další milníky';

  @override
  String get extendMilestonesSuccess =>
      'Nové milníky jsou připraveny — pokračuj!';

  @override
  String get milestoneCelebrationTitle => 'Všechny milníky splněny!';

  @override
  String milestoneCelebrationSubtitle(String title) {
    return 'Skvělá práce u cíle „$title“. Jsi na správné cestě!';
  }

  @override
  String get milestoneCelebrationBannerSubtitle =>
      'Mise dokončena. Chceš pokračovat dál?';

  @override
  String get noTasksYet =>
      'Zatím žádné úkoly — vytvoř nový cíl nebo počkej na generování.';

  @override
  String get doneWallThisGoal => 'Zeď úspěchů tohoto cíle';

  @override
  String get pivotSuggested => 'Pilot navrhuje Pivot plánu';

  @override
  String get fireDrillSimulator => 'Simulátor zkoušky ohněm';

  @override
  String get milestones => 'Milníky';

  @override
  String get pivotWizardEdit => 'Pivot Wizard — upravit plán';

  @override
  String get launchSimulator => 'Spustit simulátor';

  @override
  String get noMicroTasks => 'Žádné micro-úkoly pro tento milník';

  @override
  String get markMilestoneComplete => 'Označit milník jako splněný';

  @override
  String get noCheckInsYet =>
      'Zatím žádné check-iny. Dokonči první denní check-in a začni deník.';

  @override
  String moodLabel(int mood) {
    return 'Nálada: $mood/5';
  }

  @override
  String tasksLabel(int completed, int total) {
    return 'Úkoly: $completed/$total';
  }

  @override
  String progressMilestones(int percent, int completed, int total) {
    return '$percent% · $completed/$total milníků';
  }

  @override
  String milestonesCount(int completed, int total) {
    return '$completed/$total milníků';
  }

  @override
  String get checkInPending => 'Check-in čeká';

  @override
  String focusLabel(String title) {
    return 'Fokus: $title';
  }

  @override
  String todayTasksDone(int completed, int total) {
    return 'Dnes: $completed/$total úkolů hotovo';
  }

  @override
  String get dailyCheckIn => 'Denní check-in';

  @override
  String get checkedInToday => 'Dnes check-in hotov';

  @override
  String get dailyTask => 'Denní úkol';

  @override
  String get oneTimeTask => 'Jednorázový úkol';

  @override
  String get addCustomTaskTitle => 'Přidat vlastní úkol';

  @override
  String get addCustomTaskDesc =>
      'Doplň plán od Pilota o své kroky k aktuálnímu milníku.';

  @override
  String get addCustomTaskHint => 'Na čem chceš pracovat?';

  @override
  String get addCustomTaskMilestone => 'Milník';

  @override
  String get addCustomTaskType => 'Typ úkolu';

  @override
  String get addCustomTaskButton => 'Přidat úkol';

  @override
  String get addCustomTaskAction => 'Přidat vlastní úkol';

  @override
  String get yourTaskLabel => 'Tvůj úkol';

  @override
  String get removeCustomTask => 'Odebrat úkol';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '${count}denní streak',
      few: '${count}denní streak',
      one: '1denní streak',
    );
    return '$_temp0';
  }

  @override
  String get checkInTitle => 'Denní check-in';

  @override
  String get howFeelingToday => 'Jak se dnes cítíš?';

  @override
  String get moodRough => 'Špatně';

  @override
  String get moodLow => 'Slabě';

  @override
  String get moodOkay => 'Ujde to';

  @override
  String get moodGood => 'Dobře';

  @override
  String get moodGreat => 'Skvěle';

  @override
  String get checkInNoteHint => 'Na čem jsi dnes pracoval/a? (volitelné)';

  @override
  String tasksTodayCompleted(int completed, int total) {
    return 'Dnešní úkoly: $completed/$total hotovo';
  }

  @override
  String get antiGoalSection => 'Antipolíčko sabotéra';

  @override
  String get antiGoalWhich => 'Kterému sabotérovi se vyhnout?';

  @override
  String antiGoalSurrenderedQuestion(String title) {
    return 'Podlehl/a jsi dnes sabotérovi $title?';
  }

  @override
  String get antiGoalYes => 'Ano, podlehl/a';

  @override
  String get antiGoalNo => 'Ne, udržel/a jsem se';

  @override
  String get pilotSays => 'Pilot říká';

  @override
  String get pilotThinking => 'Pilot přemýšlí…';

  @override
  String get completeCheckIn => 'Dokončit check-in';

  @override
  String get crisisDetectedSnack =>
      'Pilot detekoval krizi — zvaž aktivaci nouzového režimu v detailu cíle.';

  @override
  String get crisisMode => 'Krizový režim';

  @override
  String get activateEmergencyMode => 'Aktivovat nouzový režim';

  @override
  String get pilotPreparing => 'Pilot připravuje…';

  @override
  String get emergencyModeActivated =>
      'Nouzový režim aktivován — jen atomické kroky.';

  @override
  String get emergencyModeActive => 'Nouzový režim aktivní';

  @override
  String get emergencyModeHint =>
      'Dnes stačí tyto atomické kroky — žádný tlak navíc.';

  @override
  String get exitEmergencyMode => 'Ukončit nouzový režim';

  @override
  String get crisisReasonNote =>
      'V check-inu jsi signalizoval/a, že je toho moc. Pilot navrhuje nouzový režim s minimálními kroky.';

  @override
  String crisisReasonDays(int days, String title) {
    return 'U cíle $title chybí check-in $days dní. Než to vzdáš, zkus nouzový režim — jen atomické kroky.';
  }

  @override
  String get pivotWizard => 'Pivot Wizard';

  @override
  String get pivotContinue => 'Pokračovat';

  @override
  String get pivotDetected => 'Pilot detekoval opakované potíže';

  @override
  String get pivotReshaping => 'Pilot přetváří plán…';

  @override
  String get launchPivot => 'Spustit Pivot';

  @override
  String pivotSuccess(int streak) {
    return 'Plán upraven — streak $streak dní zůstává. Historie check-inů je zachovaná.';
  }

  @override
  String pivotReason(String moods, String notes) {
    return 'Poslední check-iny ukazují náladu $moods/5.$notes';
  }

  @override
  String pivotReasonNotes(String notes) {
    return ' Poznámky: $notes';
  }

  @override
  String get realityCheck => 'Reality Check';

  @override
  String realityCheckLocked(int days, int checkIns) {
    return 'Odemkne se po $days dnech nebo $checkIns check-inech.';
  }

  @override
  String get realityMirror => 'Zrcadlo reality';

  @override
  String get realityCheckReady =>
      'Pilot je připraven porovnat tvůj plán s reálnými daty z check-inů a deníku.';

  @override
  String get recommendations => 'Doporučení';

  @override
  String get pilotAnalyzing => 'Pilot analyzuje…';

  @override
  String get runRealityCheck => 'Spustit Reality Check';

  @override
  String get refreshAnalysis => 'Obnovit analýzu';

  @override
  String pilotWarns(String message) {
    return 'Pilot varuje: $message';
  }

  @override
  String get askPilot => 'Zeptat se Pilota';

  @override
  String get saboteurProfile => 'Profil sabotéra';

  @override
  String get saboteurDesc =>
      '3 věci, které tě zaručeně potopí — sleduj je v check-inech.';

  @override
  String triggerLabel(String trigger) {
    return 'Spouštíč: $trigger';
  }

  @override
  String costLabel(String cost) {
    return 'Cena: $cost';
  }

  @override
  String get pilotCoach => 'Pilot Coach';

  @override
  String pilotCoachEmpty(String title) {
    return 'Ahoj! Jsem Pilot. Jak ti mohu pomoci s $title dnes?';
  }

  @override
  String get messagePilotHint => 'Napiš Pilotovi…';

  @override
  String get roleplayUnavailable => 'Roleplay není k dispozici.';

  @override
  String roleplaySimulator(String title) {
    return 'Simulátor: $title';
  }

  @override
  String roleplayMessagesToEval(int count, int total) {
    return '$count/$total zpráv do hodnocení';
  }

  @override
  String roleplayScore(int score) {
    return 'Hodnocení: $score/100';
  }

  @override
  String get roleplayImprove => 'Co zlepšit:';

  @override
  String get roleplayEmpty => 'Napiš první zprávu a začni trénink.';

  @override
  String get roleplayReplyHint => 'Tvoje odpověď…';

  @override
  String get roleplayComplete => 'Trénink dokončen';

  @override
  String get doneWall => 'Zeď úspěchů';

  @override
  String get doneWallEmpty =>
      'Zeď úspěchů se plní — splň micro-úkoly nebo napiš skvělý check-in.';

  @override
  String doneWallMore(int count) {
    return '+$count';
  }

  @override
  String get doneWallLegendTask => 'Úkol';

  @override
  String get doneWallLegendCheckIn => 'Check-in';

  @override
  String get doneWallLegendTap => 'Klepni';

  @override
  String get pilotEmergencyHeadline => 'Nouzový režim — držíme tě ve hře';

  @override
  String pilotEmergencySubtitle(String title) {
    return 'U $title stačí atomické kroky. Žádný tlak navíc.';
  }

  @override
  String get pilotMissionCompleteHeadline => 'Mise splněna, kapitáne!';

  @override
  String pilotMissionCompleteSubtitle(String title) {
    return 'Pilot slaví tvůj úspěch u cíle $title.';
  }

  @override
  String get pilotClearSkiesHeadline => 'Letíme čistým nebem, kapitáne';

  @override
  String pilotClearSkiesSubtitle(int streak, String title) {
    return '${streak}denní streak u $title. Kokpit je v zeleném.';
  }

  @override
  String get pilotTurbulenceHeadline => 'Dnes chybí check-in';

  @override
  String pilotTurbulenceSubtitle(String title) {
    return 'U $title ještě nebyl dnešní check-in.';
  }

  @override
  String get pilotCheckInWaitingHeadline => 'Kokpit bliká — check-in čeká';

  @override
  String pilotCheckInWaitingSubtitle(int streak, String title) {
    return 'Streak $streak dní u $title. Neztrať momentum.';
  }

  @override
  String get pilotSteadyHeadline => 'Stabilní let';

  @override
  String pilotSteadySubtitle(String title) {
    return 'Pilot sleduje $title. Jsi na správné dráze.';
  }

  @override
  String get pilotReadyHeadline => 'Pilot je připraven';

  @override
  String get pilotReadySubtitle => 'Vytvoř první cíl a nastartuj misi.';

  @override
  String get pilotEmergencyBoardHeadline => 'Nouzový režim na palubě';

  @override
  String pilotEmergencyBoardSubtitle(int count) {
    return '$count cílů v krizovém režimu — atomické kroky stačí.';
  }

  @override
  String get pilotTurbulenceReportHeadline => 'Pilot hlásí turbulenci';

  @override
  String pilotTurbulenceReportSubtitle(int count) {
    return '$count cílů potřebuje nouzový režim. Neztrať momentum.';
  }

  @override
  String get pilotTurbulenceBoardHeadline => 'Turbulence na palubě';

  @override
  String pilotTurbulenceBoardSubtitle(int count) {
    return '$count cílů čeká na check-in. Pilot tě potřebuje.';
  }

  @override
  String get pilotAllCheckInsHeadline => 'Letíme čistým nebem, kapitáne';

  @override
  String get pilotAllCheckInsSubtitle =>
      'Všechny check-iny hotové. Disciplína na palubě.';

  @override
  String get pilotOneCheckInHeadline => 'Jeden check-in chybí';

  @override
  String get pilotOneCheckInSubtitle => 'Doplň ho dnes — Pilot drží kurz.';

  @override
  String pilotActiveGoalsSubtitle(int count) {
    return '$count aktivních cílů. Pokračuj v tempu.';
  }

  @override
  String get weeklyReview => 'Týdenní review';

  @override
  String get pilotWeeklyReview => 'Pilot Weekly Review';

  @override
  String get weeklyReviewDesc =>
      'Jednou týdně Pilot analyzuje check-iny, streaky a úkoly — a navrhne, na co se soustředit dál.';

  @override
  String get generating => 'Generuji…';

  @override
  String get generateWeeklyReview => 'Vygenerovat review tohoto týdne';

  @override
  String get noReviewsYet =>
      'Zatím žádná review. Vygeneruj první týdenní review výše.';

  @override
  String weekOf(String date) {
    return 'Týden od $date';
  }

  @override
  String get shareReview => 'Sdílet review';

  @override
  String get highlights => 'Highlighty';

  @override
  String get nextSteps => 'Další kroky';

  @override
  String get failureGeneric => 'Něco se pokazilo. Zkus to prosím znovu.';

  @override
  String get failureNetwork => 'Zkontroluj připojení a zkus to znovu.';

  @override
  String get failureParse => 'Nepodařilo se zpracovat odpověď AI.';

  @override
  String get failureCache => 'Nepodařilo se uložit nebo načíst data.';

  @override
  String get failureTimeout => 'Požadavek vypršel. Zkus to prosím znovu.';

  @override
  String get failureQuota =>
      'Kvóta Gemini API vyčerpána. Počkej minutu a zkus znovu, nebo povol billing v Google AI Studio.';

  @override
  String failureRetrySeconds(String message, int seconds) {
    return '$message\nZkus znovu za cca $seconds sekund.';
  }

  @override
  String get failureModelUnavailable =>
      'Model Gemini není dostupný. Zkus to později nebo aktualizuj API klíč v Nastavení.';

  @override
  String get failureMissingApiKey =>
      'Pro AI funkce přidej Gemini API klíč v Nastavení.';

  @override
  String get settingsApiKey => 'Gemini API klíč';

  @override
  String get settingsApiKeyDesc =>
      'Vlastní klíč — uložený bezpečně v tomto zařízení';

  @override
  String get settingsPersonalization => 'Můj profil pilota';

  @override
  String get settingsPersonalizationDesc =>
      'Volitelné — pomoz Pilotovi přizpůsobit koučink tvému životnímu stylu';

  @override
  String get personalizationTitle => 'Můj profil pilota';

  @override
  String get personalizationEnabled => 'Zapnout AI personalizaci';

  @override
  String get personalizationEnabledDesc =>
      'Vypnuto = výchozí koučink. Všechna pole níže jsou volitelná.';

  @override
  String get personalizationScheduleRhythm => 'Denní rytmus';

  @override
  String get personalizationCoachingStyle => 'Styl koučinku';

  @override
  String get personalizationOccupation => 'Současné zaměstnání';

  @override
  String get personalizationUserBio => 'O tobě';

  @override
  String get personalizationUserBioHint =>
      'Řekni AI kouči o své denní rutině, silných a slabých stránkách, motivacích nebo spouštěčích prokrastinace…';

  @override
  String get personalizationNotSpecified => 'Neuvedeno';

  @override
  String get personalizationSave => 'Uložit profil';

  @override
  String get personalizationSaved => 'Profil uložen';

  @override
  String get personalizationClear => 'Smazat všechna data';

  @override
  String get personalizationClearConfirm =>
      'Odstranit všechna personalizační data z tohoto zařízení?';

  @override
  String get personalizationClearDone => 'Personalizační data smazána';

  @override
  String get personalizationScheduleEarlyBird => 'Ranní ptáče';

  @override
  String get personalizationScheduleNightOwl => 'Noční sova';

  @override
  String get personalizationScheduleFlexible => 'Flexibilní';

  @override
  String get personalizationScheduleIrregular => 'Nepravidelný / měnící se';

  @override
  String get personalizationStyleEmpathetic => 'Empatický a podpůrný';

  @override
  String get personalizationStyleBalanced => 'Vyvážený';

  @override
  String get personalizationStyleDirect => 'Přímý a věcný';

  @override
  String get personalizationStyleMilitary => 'Vojenská disciplína';

  @override
  String get personalizationOccupationStudent => 'Student';

  @override
  String get personalizationOccupationEmployed => 'Zaměstnaný na plný úvazek';

  @override
  String get personalizationOccupationSelfEmployed => 'Podnikatel';

  @override
  String get personalizationOccupationFreelancing => 'Freelancer / brigádník';

  @override
  String get personalizationOccupationUnemployed => 'Mezi prací';

  @override
  String get personalizationOccupationCaregiving => 'Pečovatel';

  @override
  String get personalizationOccupationRetired => 'V důchodu';

  @override
  String get personalizationHeroSubtitle =>
      'Pomoz Pilotovi pochopit tvůj rytmus, výzvy a styl koučinku — vše zůstává v tomto zařízení.';

  @override
  String get personalizationCompletionLabel => 'vyplněno';

  @override
  String get personalizationStatusActive => 'Personalizace zapnuta';

  @override
  String get personalizationStatusInactive => 'Personalizace vypnuta';

  @override
  String get personalizationDisplayNameHint => 'Jak ti má Pilot říkat?';

  @override
  String get personalizationLifestyleSection => 'Životní styl';

  @override
  String get personalizationLifestyleSectionDesc =>
      'Kdy a jak ti to nejlíp funguje';

  @override
  String get personalizationCoachingSection => 'Preference koučinku';

  @override
  String get personalizationCoachingSectionDesc =>
      'Jak tě Pilot má motivovat a plánovat';

  @override
  String get personalizationAboutSection => 'Tvůj příběh';

  @override
  String get personalizationAboutSectionDesc =>
      'Volitelný kontext, na který Pilot může navázat';

  @override
  String get personalizationMilestoneGranularity => 'Velikost milníků';

  @override
  String get personalizationMilestoneMicro => 'Mikrokroky';

  @override
  String get personalizationMilestoneMicroDesc =>
      'Malé denní výhry, minimum tření';

  @override
  String get personalizationMilestoneBalanced => 'Vyvážené';

  @override
  String get personalizationMilestoneBalancedDesc =>
      'Mix rychlých výher a reálného pokroku';

  @override
  String get personalizationMilestoneAmbitious => 'Ambiciózní';

  @override
  String get personalizationMilestoneAmbitiousDesc =>
      'Větší skoky, stretch cíle';

  @override
  String get personalizationMotivationDriver => 'Co tě motivuje';

  @override
  String get personalizationMotivationEncouragement => 'Povzbuzení';

  @override
  String get personalizationMotivationEncouragementDesc =>
      'Teplá pochvala a pozitivní momentum';

  @override
  String get personalizationMotivationAccountability => 'Odpovědnost';

  @override
  String get personalizationMotivationAccountabilityDesc =>
      'Dodržování plánu a upřímné check-iny';

  @override
  String get personalizationMotivationAutonomy => 'Autonomie';

  @override
  String get personalizationMotivationAutonomyDesc =>
      'Řídíš ty — Pilot jen lehce naviguje';

  @override
  String get personalizationMotivationChallenge => 'Výzva';

  @override
  String get personalizationMotivationChallengeDesc =>
      'Tvrdší push, soutěživý přístup';

  @override
  String get personalizationChallengeAreas => 'Časté výzvy';

  @override
  String get personalizationChallengeProcrastination => 'Prokrastinace';

  @override
  String get personalizationChallengeInconsistency => 'Nekonzistence';

  @override
  String get personalizationChallengeOverwhelm => 'Přetížení';

  @override
  String get personalizationChallengePerfectionism => 'Perfekcionismus';

  @override
  String get personalizationChallengeTimeManagement => 'Time management';

  @override
  String get personalizationScheduleEarlyBirdDesc => 'Nejvíc energie ráno';

  @override
  String get personalizationScheduleNightOwlDesc => 'Nejproduktivnější večer';

  @override
  String get personalizationScheduleFlexibleDesc => 'Rozvrh se mění den od dne';

  @override
  String get personalizationScheduleIrregularDesc =>
      'Nepředvídatelné nebo směnné hodiny';

  @override
  String get personalizationStyleEmpatheticDesc =>
      'Validuje pocity, jemné podněty, bez výčitek';

  @override
  String get personalizationStyleBalancedDesc =>
      'Teplo i odpovědnost v rovnováze';

  @override
  String get personalizationStyleDirectDesc =>
      'Krátká, jasná, akční komunikace';

  @override
  String get personalizationStyleMilitaryDesc =>
      'Přísná disciplína, žádné výmluvy, mise na prvním místě';

  @override
  String get personalizationPreviewTitle => 'Náhled Pilota';

  @override
  String get personalizationPreviewActiveHint =>
      'Takto se Pilot přizpůsobí po uložení.';

  @override
  String get personalizationPreviewInactiveHint =>
      'Zapni personalizaci pro živý náhled.';

  @override
  String get personalizationPreviewInactive =>
      'Pilot použije výchozí hlas, dokud nezapneš personalizaci.';

  @override
  String get personalizationPreviewEmpty =>
      'Vyplň pár polí výše a Pilot přizpůsobí milníky, tón i motivaci.';

  @override
  String personalizationPreviewSample(String name, String style) {
    return 'Ahoj $name, připraven na dnešní let? Budu $style.';
  }

  @override
  String get personalizationPreviewStyleDefault => 'podpůrný, ale soustředěný';

  @override
  String get personalizationPreviewStyleEmpathetic => 'vlídný a chápavý';

  @override
  String get personalizationPreviewStyleBalanced => 'vyvážený a klidný';

  @override
  String get personalizationPreviewStyleDirect => 'přímý a efektivní';

  @override
  String get personalizationPreviewStyleMilitary => 'přísný a misijně zaměřený';

  @override
  String get personalizationPrivacyNote =>
      'Data profilu jsou uložena jen v tomto zařízení a odesílána do Google Gemini s AI požadavky. Na servery GoalPilot se nic nenahrává.';

  @override
  String get apiKeySetupTitle => 'Připoj Gemini AI';

  @override
  String get apiKeySetupSubtitle =>
      'GoalPilot používá tvůj osobní Gemini API klíč. Google nabízí bezplatnou úroveň — usage a billing máš pod kontrolou.';

  @override
  String get apiKeySetupHowToTitle => 'Jak získat bezplatný API klíč';

  @override
  String get apiKeySetupStep1Title => 'Otevři Google AI Studio';

  @override
  String get apiKeySetupStep1Desc =>
      'Přihlas se Google účtem a otevři stránku API klíčů.';

  @override
  String get apiKeySetupStep2Title => 'Vytvoř API klíč';

  @override
  String get apiKeySetupStep2Desc =>
      'Klikni na \"Create API key\" a vyber Google Cloud projekt (výchozí projekt stačí).';

  @override
  String get apiKeySetupStep3Title => 'Zkopíruj klíč';

  @override
  String get apiKeySetupStep3Desc =>
      'Zkopíruj vygenerovaný klíč — začíná \"AIza\". Uchovej ho v soukromí.';

  @override
  String get apiKeySetupStep4Title => 'Vlož a ověř';

  @override
  String get apiKeySetupStep4Desc =>
      'Vlož klíč níže a klepni na Ověřit a uložit. Otestujeme ho lehkým Gemini požadavkem.';

  @override
  String get apiKeySetupFieldLabel => 'Tvůj Gemini API klíč';

  @override
  String get apiKeySetupFieldHint => 'AIza...';

  @override
  String get apiKeySetupFieldRequired => 'Zadej API klíč.';

  @override
  String get apiKeySetupFieldTooShort =>
      'Klíč vypadá příliš krátce. Zkopíruj celý klíč z Google AI Studio.';

  @override
  String get apiKeySetupValidateSave => 'Ověřit a uložit';

  @override
  String get apiKeySetupClear => 'Odstranit klíč';

  @override
  String get apiKeySetupContinue => 'Pokračovat do GoalPilot';

  @override
  String get apiKeySetupSuccess => 'API klíč uložen a ověřen.';

  @override
  String get apiKeySetupCleared => 'API klíč odstraněn z tohoto zařízení.';

  @override
  String get apiKeySetupStatusConfigured =>
      'API klíč nastaven — AI funkce jsou připravené.';

  @override
  String get apiKeySetupStatusMissing =>
      'Zatím žádný API klíč — AI funkce potřebují tvůj klíč.';

  @override
  String get apiKeySetupOpenStudio => 'Otevřít Google AI Studio';

  @override
  String get apiKeySetupOpenStudioFailed =>
      'Nepodařilo se otevřít Google AI Studio v prohlížeči.';

  @override
  String get apiKeySetupPrivacyNote =>
      'Klíč je uložen pouze v zabezpečeném úložišti tohoto zařízení a posílá se přímo Googlu pro AI požadavky.';

  @override
  String get apiKeySetupClearConfirmTitle => 'Odstranit API klíč?';

  @override
  String get apiKeySetupClearConfirmDesc =>
      'AI funkce přestanou fungovat, dokud klíč znovu nepřidáš. Cíle a check-iny zůstanou v tomto zařízení.';

  @override
  String get notifChannelDaily => 'Denní check-in';

  @override
  String get notifChannelDailyDesc =>
      'Připomínky k dokončení GoalPilot check-inu';

  @override
  String get notifChannelSmart => 'Pilot Smart Alerts';

  @override
  String get notifChannelSmartDesc =>
      'Personalizované připomínky od Pilota podle tvého pokroku';

  @override
  String get notifCheckInTitle => 'Čas na check-in';

  @override
  String get notifCheckInBody =>
      'Otevři GoalPilot a řekni Pilotovi, jak jdou tvé cíle.';

  @override
  String get notifPermissionDenied => 'Oprávnění k notifikacím bylo zamítnuto.';

  @override
  String notifReminderSet(String time) {
    return 'Připomínka nastavena na $time.';
  }

  @override
  String notifScheduleFailed(String error) {
    return 'Nepodařilo se naplánovat připomínku: $error';
  }

  @override
  String get notifTestTitle => 'GoalPilot test';

  @override
  String get notifTestBody =>
      'Notifikace fungují. Denní připomínka je naplánovaná.';

  @override
  String get notifTestSent => 'Testovací notifikace odeslána.';

  @override
  String notifTestFailed(String error) {
    return 'Test selhal: $error';
  }

  @override
  String get notifPilotTitle => 'Pilot';

  @override
  String get notifDailyFuelTitle => 'Palivo na dnešní den';

  @override
  String get notifChannelDailyFuel => 'Palivo na den';

  @override
  String get notifChannelDailyFuelDesc =>
      'Ranní motivace od Pilota na míru tvým cílům';

  @override
  String get contextualPromptLabel => 'Micro-Dose';

  @override
  String motivationFallbackStreak(int streak) {
    return '$streak dní v řadě, kapitáne. Stavíš neprůstřelnou disciplínu. Dneska to dorazíme.';
  }

  @override
  String get motivationFallbackMissedCheckIn =>
      'Včerejšek je minulost. Důležitý je dnešní check-in. Stačí 1 % úsilí.';

  @override
  String get motivationFallbackLowMood =>
      'I pomalý krok vpřed je krok. Dneska netlač na pilu, jen otevři plán.';

  @override
  String motivationFallbackPending(int count) {
    return 'Čeká $count check-inů. Jeden tap a jsi zpátky v kokpitu.';
  }

  @override
  String get motivationFallbackAllDone =>
      'Všechny check-iny hotové. Disciplína na palubě. Užij si momentum.';

  @override
  String motivationFallbackSteady(String title) {
    return 'Stabilní let na \"$title\". Pilot drží kurz — udrž tempo.';
  }

  @override
  String get motivationFallbackDefault =>
      'Kapitáne, tvé cíle čekají. Jeden malý krok dnes porazí nulu.';

  @override
  String motivationFallbackDailyFuel(String goal, int day, String focus) {
    return '[$goal] Den $day. Dnes dobýváš $focus. Žádné výmluvy — letíme.';
  }

  @override
  String get motivationFallbackDailyFuelDefault =>
      'GoalPilot: Den 1. Otevři appku. Jeden krok. Bez výmluv.';

  @override
  String shareProgressLabel(int percent) {
    return 'Pokrok: $percent%';
  }

  @override
  String shareStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dní',
      few: 'dny',
      one: 'den',
    );
    return 'Streak: $count $_temp0';
  }

  @override
  String shareMilestones(int completed, int total) {
    return 'Milníky: $completed/$total';
  }

  @override
  String shareCurrentFocus(String title) {
    return 'Aktuální fokus: $title';
  }

  @override
  String shareDailyHabit(String habit) {
    return 'Denní návyk: $habit';
  }

  @override
  String get shareTrackedWith => 'Sledováno v GoalPilot ✈️';

  @override
  String get shareGettingStarted => 'Začínám s GoalPilot! ✈️';

  @override
  String get shareMyProgress => 'Můj GoalPilot pokrok ✈️';

  @override
  String shareAvgProgress(int percent) {
    return 'Průměrný pokrok: $percent%';
  }

  @override
  String get shareWeeklyReviewHeader => 'GoalPilot týdenní review ✈️';

  @override
  String shareActiveGoals(int count) {
    return 'Aktivní cíle: $count';
  }
}
