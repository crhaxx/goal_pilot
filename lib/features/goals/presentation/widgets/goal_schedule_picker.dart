import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

extension GoalScheduleTypeUi on GoalScheduleType {
  String label(AppLocalizations l10n) => switch (this) {
        GoalScheduleType.everyDay => l10n.scheduleEveryDay,
        GoalScheduleType.timesPerWeek => l10n.scheduleTimesPerWeek,
        GoalScheduleType.weekendsOnly => l10n.scheduleWeekendsOnly,
      };

  String description(AppLocalizations l10n) => switch (this) {
        GoalScheduleType.everyDay => l10n.scheduleEveryDayDesc,
        GoalScheduleType.timesPerWeek => l10n.scheduleTimesPerWeekDesc,
        GoalScheduleType.weekendsOnly => l10n.scheduleWeekendsOnlyDesc,
      };

  IconData get icon => switch (this) {
        GoalScheduleType.everyDay => Icons.calendar_today,
        GoalScheduleType.timesPerWeek => Icons.date_range,
        GoalScheduleType.weekendsOnly => Icons.weekend,
      };
}

class GoalScheduleCard extends StatelessWidget {
  const GoalScheduleCard({
    super.key,
    required this.schedule,
    required this.onScheduleChanged,
    this.embedded = false,
    this.enabled = true,
    this.showHeader = true,
  });

  final GoalSchedule schedule;
  final ValueChanged<GoalSchedule> onScheduleChanged;
  final bool embedded;
  final bool enabled;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          Text(
            l10n.scheduleSectionTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.scheduleSectionDesc,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...GoalScheduleType.values.map((type) {
          final selected = schedule.type == type;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ScheduleOptionTile(
              selected: selected,
              enabled: enabled,
              icon: type.icon,
              title: type.label(l10n),
              subtitle: type.description(l10n),
              onTap: () => _selectType(type),
            ),
          );
        }),
        if (schedule.type.isTimesPerWeek) ...[
          const SizedBox(height: 8),
          Text(
            l10n.scheduleTimesLabel(schedule.timesPerWeek),
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: schedule.timesPerWeek.toDouble(),
            min: 2,
            max: 6,
            divisions: 4,
            label: '${schedule.timesPerWeek}',
            onChanged: enabled
                ? (value) {
                    final count = value.round();
                    onScheduleChanged(
                      GoalSchedule.timesPerWeek(count),
                    );
                  }
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.schedulePickDays,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: GoalScheduleUtils.weekdayKeys.map((weekday) {
              final selected = schedule.activeWeekdays.contains(weekday);
              return FilterChip(
                label: Text(GoalScheduleUtils.weekdayShort(weekday, l10n)),
                selected: selected,
                onSelected: enabled
                    ? (_) => _toggleWeekday(weekday)
                    : null,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _selectType(GoalScheduleType type) {
    switch (type) {
      case GoalScheduleType.everyDay:
        onScheduleChanged(GoalSchedule.everyDay);
      case GoalScheduleType.weekendsOnly:
        onScheduleChanged(GoalSchedule.weekendsOnly);
      case GoalScheduleType.timesPerWeek:
        onScheduleChanged(GoalSchedule.timesPerWeek(3));
    }
  }

  void _toggleWeekday(int weekday) {
    final current = Set<int>.from(schedule.activeWeekdays);
    if (current.contains(weekday)) {
      if (current.length <= 1) return;
      current.remove(weekday);
    } else {
      current.add(weekday);
    }
    onScheduleChanged(
      GoalSchedule(
        type: GoalScheduleType.timesPerWeek,
        timesPerWeek: current.length.clamp(1, 7),
        activeWeekdays: current,
      ),
    );
  }
}

class _ScheduleOptionTile extends StatelessWidget {
  const _ScheduleOptionTile({
    required this.selected,
    required this.enabled,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final bool enabled;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? AppColors.cyan : AppColors.slate400;

    return Material(
      color: selected
          ? AppColors.cyan.withValues(alpha: 0.08)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.cyan : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: AppColors.cyan, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
