import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_priority_badge.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';

class GoalCard extends ConsumerWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  final Goal goal;
  final VoidCallback onTap;

  static const _actionPriority = 'priority';
  static const _actionDelete = 'delete';

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final l10n = context.l10n;

    switch (action) {
      case _actionPriority:
        final selected = await showGoalPrioritySheet(
          context: context,
          current: goal.priority,
        );
        if (selected == null || selected == goal.priority || !context.mounted) {
          return;
        }
        try {
          await updateGoalPriority(
            ref,
            goalId: goal.id,
            priority: selected,
          );
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.goalPriorityUpdated)),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(e, l10n)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      case _actionDelete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.deleteGoalTitle),
            content: Text(l10n.deleteGoalConfirm(goal.title)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.deleteGoalButton),
              ),
            ],
          ),
        );
        if (confirmed != true || !context.mounted) return;
        try {
          await deleteGoal(ref, goalId: goal.id);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleteGoalSuccess)),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(e, l10n)),
              backgroundColor: AppColors.error,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    ref.watch(todayProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
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
                    const SizedBox(height: 8),
                    GoalPriorityBadge(priority: goal.priority, compact: true),
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
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.slate500),
              tooltip: l10n.goalActionsTooltip,
              onSelected: (action) => _handleMenuAction(context, ref, action),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _actionPriority,
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.changeGoalPriority),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: _actionDelete,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.deleteGoal,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
