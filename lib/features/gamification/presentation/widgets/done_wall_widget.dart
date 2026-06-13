import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';

class DoneWallWidget extends StatelessWidget {
  const DoneWallWidget({
    super.key,
    required this.bricks,
    this.title,
    this.maxVisible = 12,
  });

  final List<WinBrick> bricks;
  final String? title;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final visible = bricks.take(maxVisible).toList();
    final mutedText = theme.colorScheme.onSurfaceVariant;

    if (visible.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.grid_view, color: mutedText),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.doneWallEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: mutedText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? l10n.doneWall,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (bricks.length > maxVisible)
              Text(
                l10n.doneWallMore(bricks.length - maxVisible),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: visible.map((brick) => _WinBrickTile(brick: brick)).toList(),
        ),
      ],
    );
  }
}

class _WinBrickTile extends StatelessWidget {
  const _WinBrickTile({required this.brick});

  final WinBrick brick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.cyanLight : AppColors.deepBlue;
    final borderColor = isDark
        ? AppColors.cyanLight.withValues(alpha: 0.45)
        : AppColors.cyan.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.cyan.withValues(alpha: 0.22),
                  AppColors.darkSurfaceVariant,
                ]
              : [
                  AppColors.cyan.withValues(alpha: 0.18),
                  AppColors.success.withValues(alpha: 0.22),
                ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        brick.label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
