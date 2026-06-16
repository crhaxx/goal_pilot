enum ChallengeArea {
  procrastination,
  inconsistency,
  overwhelm,
  perfectionism,
  timeManagement;

  String get promptLabel => switch (this) {
        procrastination => 'procrastination',
        inconsistency => 'inconsistency / broken streaks',
        overwhelm => 'feeling overwhelmed',
        perfectionism => 'perfectionism / all-or-nothing thinking',
        timeManagement => 'time management',
      };
}
