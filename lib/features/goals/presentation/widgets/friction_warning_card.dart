import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/friction_point.dart';

class FrictionWarningCard extends StatelessWidget {
  const FrictionWarningCard({
    super.key,
    required this.friction,
    this.onAskPilot,
  });

  final FrictionPoint friction;
  final VoidCallback? onAskPilot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      color: AppColors.warning.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.radar, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.pilotWarns(friction.title),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              friction.warning,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              friction.tip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (onAskPilot != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onAskPilot,
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: Text(l10n.askPilot),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
