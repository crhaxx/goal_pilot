import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/utils/reality_check_detector.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

class RealityCheckCard extends ConsumerWidget {
  const RealityCheckCard({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.cyanLight : AppColors.deepBlue;
    final mutedColor = isDark ? AppColors.slate400 : AppColors.slate500;
    final unlocked = ref.watch(realityCheckUnlockedProvider(goal.id));
    final isLoading = ref.watch(realityCheckControllerProvider).isLoading;
    final report = goal.realityCheckReport;

    if (!unlocked) {
      return Card(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.slate100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: mutedColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.realityCheck,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.realityCheckLocked(
                        RealityCheckDetector.minDays,
                        RealityCheckDetector.minCheckIns,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: isDark
          ? AppColors.cyanLight.withValues(alpha: 0.1)
          : AppColors.deepBlue.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_alt, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  l10n.realityCheck,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const Spacer(),
                if (report != null)
                  Text(
                    l10n.realityMirror,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (report == null)
              Text(
                l10n.realityCheckReady,
                style: theme.textTheme.bodyMedium,
              )
            else ...[
              Text(
                report.insight,
                style: theme.textTheme.bodyMedium,
              ),
              if (report.recommendations.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.recommendations,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                ...report.recommendations.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('→ '),
                        Expanded(child: Text(r)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 12),
            if (report == null || RealityCheckDetector.needsRefresh(goal))
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(realityCheckControllerProvider.notifier)
                                .generate(goal.id);
                            ref.invalidate(goalByIdProvider(goal.id));
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(failureMessage(e, context.l10n)),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    isLoading
                        ? l10n.pilotAnalyzing
                        : report == null
                            ? l10n.runRealityCheck
                            : l10n.refreshAnalysis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
