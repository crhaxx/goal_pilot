enum CoachingFocusStyle {
  empathetic,
  balanced,
  direct,
  military;

  String get promptLabel => switch (this) {
        empathetic =>
          'empathetic and supportive — validate feelings, gentle encouragement',
        balanced =>
          'balanced — mix of warmth and accountability',
        direct => 'direct and no-nonsense — concise, action-oriented',
        military =>
          'military-style coaching — strict, disciplined, high accountability',
      };
}
