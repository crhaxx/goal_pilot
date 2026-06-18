import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/action_task_tile.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';
import 'package:intl/intl.dart';

class PersonalTaskTile extends StatefulWidget {
  const PersonalTaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    this.onEdit,
    this.onDelete,
    this.muted = false,
  });

  final PersonalTask task;
  final Future<void> Function(bool isCompleted) onChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool muted;

  @override
  State<PersonalTaskTile> createState() => _PersonalTaskTileState();
}

class _PersonalTaskTileState extends State<PersonalTaskTile> {
  bool? _optimisticDone;
  bool _isToggling = false;
  bool _justCompleted = false;

  bool get _done => _optimisticDone ?? widget.task.isCompleted;

  @override
  void didUpdateWidget(PersonalTaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.completedOn != widget.task.completedOn) {
      _optimisticDone = null;
      _justCompleted = false;
    }
  }

  Future<void> _toggle() async {
    if (_isToggling) return;

    final newValue = !_done;
    setState(() {
      _optimisticDone = newValue;
      _justCompleted = newValue;
    });

    if (newValue) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    _isToggling = true;
    try {
      await widget.onChanged(newValue);
    } catch (_) {
      if (mounted) {
        setState(() {
          _optimisticDone = !newValue;
          _justCompleted = false;
        });
      }
    } finally {
      _isToggling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final reminderLabel = widget.task.reminderAt == null
        ? null
        : DateFormat.yMMMd(locale).add_Hm().format(widget.task.reminderAt!);

    final cardColor = widget.muted
        ? AppColors.slate500.withValues(alpha: 0.08)
        : _done
            ? AppColors.success.withValues(alpha: 0.06)
            : theme.cardTheme.color;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: cardColor,
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CompletionCircle(
                isDone: _done,
                animate: _justCompleted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        decoration:
                            (_done || widget.muted) ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.slate400,
                        color: (_done || widget.muted) ? AppColors.slate500 : null,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(widget.task.title),
                    ),
                    if (reminderLabel != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_active_outlined,
                            size: 14,
                            color: AppColors.cyan,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              l10n.personalTaskReminderAt(reminderLabel),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.slate500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: l10n.personalTaskEdit,
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onEdit,
                ),
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.personalTaskDelete,
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
