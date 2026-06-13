import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/anti_goal.dart';

class AntiGoalCard extends StatelessWidget {
  const AntiGoalCard({super.key, required this.antiGoals});

  final List<AntiGoal> antiGoals;

  @override
  Widget build(BuildContext context) {
    if (antiGoals.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      color: const Color(0xFF1A1A2E).withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.error.withValues(alpha: 0.8)),
                const SizedBox(width: 8),
                Text(
                  l10n.saboteurProfile,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.saboteurDesc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
            const SizedBox(height: 12),
            ...antiGoals.asMap().entries.map((entry) {
              final anti = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${entry.key + 1}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anti.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (anti.trigger.isNotEmpty)
                            Text(
                              l10n.triggerLabel(anti.trigger),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.slate500,
                              ),
                            ),
                          if (anti.consequence.isNotEmpty)
                            Text(
                              l10n.costLabel(anti.consequence),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.error.withValues(alpha: 0.85),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
