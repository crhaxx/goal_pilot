import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/presentation/widgets/app_logo.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({
    super.key,
    required this.onCreate,
    this.enabled = true,
  });

  final VoidCallback onCreate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: isDark ? 0.15 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const AppLogo(size: 100, borderRadius: 22),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.emptyHomeWelcome(l10n.appName),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.emptyHomeDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _FeatureRow(
            icon: Icons.auto_awesome,
            title: l10n.emptyHomeFeaturePlan,
            color: AppColors.cyan,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.flight_takeoff,
            title: l10n.emptyHomeFeatureCheckIn,
            color: AppColors.deepBlue,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.insights_outlined,
            title: l10n.emptyHomeFeatureReview,
            color: AppColors.success,
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: enabled ? onCreate : null,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.createFirstGoal),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.slate400,
            ),
          ],
        ),
      ),
    );
  }
}
