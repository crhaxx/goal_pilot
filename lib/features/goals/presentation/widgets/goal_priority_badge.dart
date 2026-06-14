import 'package:flutter/material.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_priority.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

extension GoalPriorityUi on GoalPriority {
  String label(AppLocalizations l10n) => switch (this) {
        GoalPriority.low => l10n.goalPriorityLow,
        GoalPriority.medium => l10n.goalPriorityMedium,
        GoalPriority.high => l10n.goalPriorityHigh,
        GoalPriority.critical => l10n.goalPriorityCritical,
      };

  String description(AppLocalizations l10n) => switch (this) {
        GoalPriority.low => l10n.goalPriorityLowDesc,
        GoalPriority.medium => l10n.goalPriorityMediumDesc,
        GoalPriority.high => l10n.goalPriorityHighDesc,
        GoalPriority.critical => l10n.goalPriorityCriticalDesc,
      };

  Color get color => switch (this) {
        GoalPriority.low => AppColors.slate400,
        GoalPriority.medium => AppColors.cyan,
        GoalPriority.high => AppColors.warning,
        GoalPriority.critical => AppColors.error,
      };

  IconData get icon => switch (this) {
        GoalPriority.low => Icons.low_priority,
        GoalPriority.medium => Icons.drag_handle,
        GoalPriority.high => Icons.label_important,
        GoalPriority.critical => Icons.priority_high,
      };
}

class GoalPriorityBadge extends StatelessWidget {
  const GoalPriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  final GoalPriority priority;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = priority.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: compact ? 14 : 16, color: color),
          const SizedBox(width: 4),
          Text(
            priority.label(l10n),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class GoalPriorityPicker extends StatelessWidget {
  const GoalPriorityPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
  });

  final GoalPriority selected;
  final ValueChanged<GoalPriority> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: GoalPriority.values.map((priority) {
        final isSelected = priority == selected;
        final color = priority.color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: isSelected
                ? color.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: enabled ? () => onChanged(priority) : null,
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : AppColors.slate200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(priority.icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            priority.label(l10n),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isSelected ? color : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            priority.description(l10n),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: color, size: 22),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class GoalPriorityCard extends StatelessWidget {
  const GoalPriorityCard({
    super.key,
    required this.priority,
    required this.onPriorityChanged,
    this.enabled = true,
    this.embedded = false,
  });

  final GoalPriority priority;
  final ValueChanged<GoalPriority> onPriorityChanged;
  final bool enabled;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.flag_outlined, color: AppColors.deepBlue, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.goalPriorityLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.goalPriorityDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GoalPriorityPicker(
          selected: priority,
          enabled: enabled,
          onChanged: onPriorityChanged,
        ),
      ],
    );

    if (embedded) return content;

    return Card(
      color: AppColors.deepBlue.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}

Future<GoalPriority?> showGoalPrioritySheet({
  required BuildContext context,
  required GoalPriority current,
}) {
  return showModalBottomSheet<GoalPriority>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      var selected = current;
      final l10n = sheetContext.l10n;
      final theme = Theme.of(sheetContext);

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              24 + MediaQuery.paddingOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.goalPriorityLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.goalPriorityDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 16),
                GoalPriorityPicker(
                  selected: selected,
                  onChanged: (value) => setState(() => selected = value),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: selected == current
                      ? null
                      : () => Navigator.pop(sheetContext, selected),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.done),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
