import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

class ExtendMilestonesButton extends ConsumerWidget {
  const ExtendMilestonesButton({super.key, required this.goal});

  final Goal goal;

  Future<void> _extend(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    try {
      await ref.read(extendMilestonesControllerProvider.notifier).apply(
            goalId: goal.id,
          );

      if (!context.mounted) return;

      ref.invalidate(goalByIdProvider(goal.id));
      ref.invalidate(goalsStreamProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.extendMilestonesSuccess),
          backgroundColor: AppColors.success,
        ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isLoading = ref.watch(extendMilestonesControllerProvider).isLoading;

    return FilledButton.icon(
      onPressed: isLoading ? null : () => _extend(context, ref),
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(l10n.addMoreMilestones),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }
}
