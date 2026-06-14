import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_priority_badge.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';

class TodayFocusCard extends StatelessWidget {
  const TodayFocusCard({
    super.key,
    required this.goal,
    this.onCheckIn,
    this.onOpen,
  });

  final Goal goal;
  final VoidCallback? onCheckIn;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final milestone = goal.currentMilestone;
    final completed = goal.todayTasksCompleted();
    final total = goal.todayTasksTotal;

    return Card(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
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
                  if (goal.priority != GoalPriority.medium) ...[
                    const SizedBox(width: 8),
                    GoalPriorityBadge(priority: goal.priority, compact: true),
                  ],
                  StreakBadge(streak: goal.streak, compact: true),
                ],
              ),
              if (milestone != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.focusLabel(milestone.title),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (goal.dailyHabit.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.repeat, size: 16, color: AppColors.slate500),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        goal.dailyHabit,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (total > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : completed / total,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.todayTasksDone(completed, total),
                  style: theme.textTheme.labelMedium,
                ),
              ],
              if (goal.needsCheckInToday && onCheckIn != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onCheckIn,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(l10n.dailyCheckIn),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ] else if (goal.hasCheckedInToday) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      l10n.checkedInToday,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
