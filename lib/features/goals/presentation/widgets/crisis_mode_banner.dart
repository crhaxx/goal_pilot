import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

class CrisisModeBanner extends ConsumerWidget {
  const CrisisModeBanner({
    super.key,
    required this.goal,
    required this.reason,
  });

  final Goal goal;
  final String reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isLoading = ref.watch(crisisModeControllerProvider).isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF450A0A), AppColors.error],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emergency, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.crisisMode,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(crisisModeControllerProvider.notifier)
                            .activate(goal.id);
                        ref.invalidate(goalByIdProvider(goal.id));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.emergencyModeActivated),
                            ),
                          );
                        }
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
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shield),
              label: Text(
                isLoading ? l10n.pilotPreparing : l10n.activateEmergencyMode,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveCrisisBanner extends ConsumerWidget {
  const ActiveCrisisBanner({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency_outlined, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  l10n.emergencyModeActive,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            if (goal.crisisMessage != null) ...[
              const SizedBox(height: 8),
              Text(goal.crisisMessage!),
            ],
            const SizedBox(height: 12),
            Text(
              l10n.emergencyModeHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await ref
                    .read(crisisModeControllerProvider.notifier)
                    .exit(goal.id);
                ref.invalidate(goalByIdProvider(goal.id));
              },
              child: Text(l10n.exitEmergencyMode),
            ),
          ],
        ),
      ),
    );
  }
}
