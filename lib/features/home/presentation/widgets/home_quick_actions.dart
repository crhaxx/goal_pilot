import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.onNewGoal,
    required this.onShare,
    this.newGoalEnabled = true,
  });

  final VoidCallback onNewGoal;
  final VoidCallback onShare;
  final bool newGoalEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.add_rounded,
            label: l10n.newGoal,
            gradient: const [AppColors.cyan, Color(0xFF0891B2)],
            onTap: newGoalEnabled ? onNewGoal : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.share_outlined,
            label: l10n.share,
            outlined: true,
            onTap: onShare,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.gradient,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final List<Color>? gradient;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final enabled = onTap != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
          decoration: BoxDecoration(
            gradient: outlined
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient!,
                  ),
            color: outlined
                ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                : null,
            borderRadius: BorderRadius.circular(16),
            border: outlined
                ? Border.all(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.slate200,
                  )
                : null,
            boxShadow: outlined
                ? null
                : [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: outlined ? theme.colorScheme.onSurface : Colors.white,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: outlined ? theme.colorScheme.onSurface : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
