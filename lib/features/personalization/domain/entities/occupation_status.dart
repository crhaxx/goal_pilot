enum OccupationStatus {
  student,
  employed,
  selfEmployed,
  freelancing,
  unemployed,
  caregiving,
  retired;

  String get promptLabel => switch (this) {
        student => 'student',
        employed => 'employed full-time',
        selfEmployed => 'self-employed / entrepreneur',
        freelancing => 'freelancer / gig worker',
        unemployed => 'between jobs / seeking work',
        caregiving => 'primary caregiver',
        retired => 'retired',
      };
}
