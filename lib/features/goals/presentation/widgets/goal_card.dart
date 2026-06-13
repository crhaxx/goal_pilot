import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  final Goal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  StreakBadge(streak: goal.streak, compact: true),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.milestonesCount(
                  goal.completedMilestoneCount,
                  goal.totalMilestones,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.slate500,
                ),
              ),
              if (goal.needsCheckInToday) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: AppColors.cyan),
                    const SizedBox(width: 6),
                    Text(
                      l10n.checkInPending,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: goal.progress,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${goal.progressPercent}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
