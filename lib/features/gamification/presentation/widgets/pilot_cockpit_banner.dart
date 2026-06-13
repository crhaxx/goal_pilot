import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/gamification/domain/pilot_status.dart';

class PilotCockpitBanner extends StatelessWidget {
  const PilotCockpitBanner({
    super.key,
    required this.status,
    this.compact = false,
  });

  final PilotStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _colorsFor(status.mood);

    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: status.isAlert
            ? [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          _PilotIcon(iconName: status.iconName, alert: status.isAlert),
          SizedBox(width: compact ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.headline,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 4),
                  Text(
                    status.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _colorsFor(PilotMood mood) {
    return switch (mood) {
      PilotMood.cruising => [AppColors.deepBlue, AppColors.cyan],
      PilotMood.steady => [AppColors.navy, AppColors.deepBlue],
      PilotMood.turbulence => [const Color(0xFF7C2D12), AppColors.warning],
      PilotMood.emergency => [const Color(0xFF450A0A), AppColors.error],
    };
  }
}

class _PilotIcon extends StatelessWidget {
  const _PilotIcon({required this.iconName, required this.alert});

  final String iconName;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final icon = switch (iconName) {
      'flight' => Icons.flight,
      'warning' => Icons.warning_amber_rounded,
      'radar' => Icons.radar,
      'celebration' => Icons.celebration,
      'rocket' => Icons.rocket_launch,
      _ => Icons.explore,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: alert ? 0.25 : 0.18),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
