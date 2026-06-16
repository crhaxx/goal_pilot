enum MilestoneGranularity {
  microSteps,
  balanced,
  ambitious;

  String get promptLabel => switch (this) {
        microSteps =>
          'micro-steps — prefer tiny, low-friction daily actions',
        balanced =>
          'balanced — mix of quick wins and meaningful milestones',
        ambitious =>
          'ambitious — larger milestones with stretch goals',
      };
}
