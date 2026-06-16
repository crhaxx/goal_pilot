enum MotivationDriver {
  encouragement,
  accountability,
  autonomy,
  challenge;

  String get promptLabel => switch (this) {
        encouragement =>
          'encouragement and positive reinforcement',
        accountability =>
          'accountability and follow-through pressure',
        autonomy =>
          'autonomy — user chooses the path, Pilot guides lightly',
        challenge =>
          'challenge and competitive edge',
      };
}
