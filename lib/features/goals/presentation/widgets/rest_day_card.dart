import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';
import 'package:intl/intl.dart';

class RestDayCard extends StatelessWidget {
  const RestDayCard({
    super.key,
    required this.goal,
    this.onOpen,
  });

  final Goal goal;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final nextDay = goal.nextActiveDay;
    final isTomorrow = nextDay != null &&
        nextDay.difference(DateTime.now()).inDays <= 1;

    final subtitle = isTomorrow
        ? l10n.restDayNextStepTomorrow
        : nextDay == null
            ? l10n.restDayPaused
            : l10n.restDayNextStepOn(
                DateFormat.yMMMd(l10n.localeName).format(nextDay),
              );

    return Opacity(
      opacity: 0.72,
      child: Card(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.slate400.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.nightlight_round,
                    color: AppColors.slate500,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                      if (goal.schedule.type.isTimesPerWeek ||
                          goal.schedule.type.isWeekendsOnly) ...[
                        const SizedBox(height: 4),
                        Text(
                          GoalScheduleUtils.formatActiveDays(goal.schedule, l10n),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                StreakBadge(streak: goal.streak, compact: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
