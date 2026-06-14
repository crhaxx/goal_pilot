import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/gamification/domain/entities/win_brick.dart';
import 'package:goal_pilot/features/gamification/presentation/widgets/done_wall_network.dart';

class DoneWallWidget extends StatefulWidget {
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
  State<DoneWallWidget> createState() => _DoneWallWidgetState();
}

class _DoneWallWidgetState extends State<DoneWallWidget> {
  WinBrick? _highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final visible = widget.bricks.take(widget.maxVisible).toList();
    final mutedText = theme.colorScheme.onSurfaceVariant;

    if (visible.isEmpty) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: DoneWallNetworkPlaceholder(isDark: isDark),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.hub_outlined, color: mutedText),
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
            ],
          ),
        ),
      );
    }

    final highlighted = _highlighted;
    final hasValidHighlight =
        highlighted != null && visible.any((b) => b.id == highlighted.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title ?? l10n.doneWall,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.bricks.length > widget.maxVisible)
              Text(
                l10n.doneWallMore(widget.bricks.length - widget.maxVisible),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.darkSurface,
                        AppColors.darkSurfaceVariant.withValues(alpha: 0.65),
                      ]
                    : [
                        Colors.white,
                        AppColors.cyan.withValues(alpha: 0.06),
                      ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: doneWallNetworkHeightFor(visible.length),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DoneWallNetwork(
                      bricks: visible,
                      selectedBrickId: _highlighted?.id,
                      onBrickTap: (brick) {
                        setState(() {
                          _highlighted =
                              _highlighted?.id == brick.id ? null : brick;
                        });
                      },
                    ),
                  ),
                ),
                if (hasValidHighlight)
                  _SelectedBrickBanner(brick: highlighted, isDark: isDark)
                else
                  _NetworkLegend(l10n: l10n, isDark: isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedBrickBanner extends StatelessWidget {
  const _SelectedBrickBanner({
    required this.brick,
    required this.isDark,
  });

  final WinBrick brick;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = brick.source == WinBrickSource.checkIn
        ? AppColors.warning
        : AppColors.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: accent.withValues(alpha: isDark ? 0.35 : 0.25),
          ),
        ),
        color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
      ),
      child: Row(
        children: [
          Icon(
            brick.source == WinBrickSource.checkIn
                ? Icons.auto_awesome
                : Icons.bolt_rounded,
            size: 20,
            color: accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              brick.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkLegend extends StatelessWidget {
  const _NetworkLegend({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            icon: Icons.bolt_rounded,
            label: l10n.doneWallLegendTask,
            color: AppColors.success,
            muted: muted,
          ),
          const SizedBox(width: 20),
          _LegendItem(
            icon: Icons.auto_awesome,
            label: l10n.doneWallLegendCheckIn,
            color: AppColors.warning,
            muted: muted,
          ),
          const SizedBox(width: 20),
          _LegendItem(
            icon: Icons.touch_app_outlined,
            label: l10n.doneWallLegendTap,
            color: isDark ? AppColors.cyanLight : AppColors.cyan,
            muted: muted,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.muted,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}
