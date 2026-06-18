import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class ApiKeyMissingBanner extends StatelessWidget {
  const ApiKeyMissingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Material(
      color: AppColors.warning.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: () => context.push('/settings/api-key'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.key_outlined, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.homeApiKeyMissingBanner,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.homeApiKeyMissingAction,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppColors.cyan, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
