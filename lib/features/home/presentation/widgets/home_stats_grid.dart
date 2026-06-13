import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:goal_pilot/features/home/presentation/widgets/stat_card.dart';

class HomeStatsGrid extends StatelessWidget {
  const HomeStatsGrid({super.key, required this.stats});

  final HomeStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                StatCard(
                  label: l10n.statActiveGoals,
                  value: '${stats.activeGoals}',
                  icon: Icons.flag_outlined,
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.slate200.withValues(alpha: 0.8),
                ),
                StatCard(
                  label: l10n.statBestStreak,
                  value: '${stats.bestStreak}',
                  icon: Icons.local_fire_department,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.slate200.withValues(alpha: 0.8),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                StatCard(
                  label: l10n.statCheckIns7d,
                  value: '${stats.checkInsThisWeek}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.slate200.withValues(alpha: 0.8),
                ),
                StatCard(
                  label: l10n.statAvgProgress,
                  value: '${stats.averageProgress}%',
                  icon: Icons.trending_up,
                  color: AppColors.deepBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeStatsGridSkeleton extends StatelessWidget {
  const HomeStatsGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkSurfaceVariant : AppColors.slate200;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _SkeletonCell(base: base)),
                const SizedBox(width: 12),
                Expanded(child: _SkeletonCell(base: base)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _SkeletonCell(base: base)),
                const SizedBox(width: 12),
                Expanded(child: _SkeletonCell(base: base)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCell extends StatelessWidget {
  const _SkeletonCell({required this.base});

  final Color base;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: base.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 48,
          height: 20,
          decoration: BoxDecoration(
            color: base.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 72,
          height: 12,
          decoration: BoxDecoration(
            color: base.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
