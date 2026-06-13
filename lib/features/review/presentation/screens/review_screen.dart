import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/review/domain/entities/weekly_review.dart';
import 'package:goal_pilot/features/review/presentation/providers/review_providers.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reviewsAsync = ref.watch(reviewsStreamProvider);
    final generateState = ref.watch(weeklyReviewControllerProvider);
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Review'),
      ),
      body: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(failureMessage(error))),
        data: (reviews) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Card(
                color: AppColors.deepBlue.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilot Weekly Review',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Once a week, Pilot analyzes your check-ins, streaks, '
                        'and tasks — then suggests what to focus on next.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: generateState.isLoading || goals.isEmpty
                              ? null
                              : () => _generateReview(context, ref),
                          icon: generateState.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome),
                          label: Text(
                            generateState.isLoading
                                ? 'Generating…'
                                : 'Generate This Week\'s Review',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (reviews.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No reviews yet. Generate your first weekly review above.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                )
              else
                ...reviews.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ReviewCard(review: review, goals: goals),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _generateReview(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(weeklyReviewControllerProvider.notifier).generate();
      ref.invalidate(reviewsStreamProvider);
      ref.invalidate(latestReviewProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.goals});

  final WeeklyReview review;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Week of ${dateFormat.format(review.weekStart)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => ShareService.shareWeeklyReview(
                    reviewText: review.summary,
                    goals: goals,
                  ),
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'Share review',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.summary),
            if (review.highlights.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Highlights',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...review.highlights.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✓ '),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ],
            if (review.nextSteps.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Next Steps',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...review.nextSteps.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right, size: 18, color: AppColors.cyan),
                      const SizedBox(width: 4),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
