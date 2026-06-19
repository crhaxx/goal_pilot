import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

class WorkedTodayCheckbox extends ConsumerWidget {
  const WorkedTodayCheckbox({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isLoading = ref.watch(checkInControllerProvider).isLoading;

    if (goal.isFullyComplete || !goal.isActiveDayToday) {
      return const SizedBox.shrink();
    }

    return Card(
      child: CheckboxListTile(
        value: goal.hasCheckedInToday,
        onChanged: isLoading
            ? null
            : (value) async {
                if (value == null) return;
                try {
                  await ref
                      .read(checkInControllerProvider.notifier)
                      .setWorkedToday(goalId: goal.id, worked: value);
                  ref.invalidate(goalByIdProvider(goal.id));
                  ref.invalidate(checkInsProvider(goal.id));
                  ref.invalidate(winBricksProvider(goal.id));
                  ref.invalidate(allWinBricksProvider);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(failureMessage(e, l10n)),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
        title: Text(
          l10n.workedOnGoalToday,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: goal.needsCheckInToday
            ? Text(
                l10n.checkInPending,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.cyan,
                ),
              )
            : null,
        activeColor: AppColors.cyan,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
