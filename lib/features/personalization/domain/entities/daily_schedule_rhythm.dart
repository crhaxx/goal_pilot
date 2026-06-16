enum DailyScheduleRhythm {
  earlyBird,
  nightOwl,
  flexible,
  irregular;

  String get promptLabel => switch (this) {
        earlyBird => 'early bird (most productive in the morning)',
        nightOwl => 'night owl (most productive in the evening)',
        flexible => 'flexible schedule',
        irregular => 'irregular or shifting schedule',
      };
}
