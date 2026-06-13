import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';

/// Large, tappable check control used for tasks and milestones.
class CompletionCircle extends StatelessWidget {
  const CompletionCircle({
    super.key,
    required this.isDone,
    this.size = 28,
    this.animate = false,
  });

  final bool isDone;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.64;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? AppColors.success : Colors.transparent,
        border: Border.all(
          color: isDone ? AppColors.success : AppColors.slate400,
          width: 2,
        ),
      ),
      child: AnimatedScale(
        scale: isDone ? 1.0 : 0.0,
        duration: Duration(milliseconds: animate ? 280 : 150),
        curve: animate ? Curves.elasticOut : Curves.easeOutCubic,
        child: isDone
            ? Icon(Icons.check_rounded, size: iconSize, color: Colors.white)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class ActionTaskTile extends StatefulWidget {
  const ActionTaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    this.onDelete,
    this.dense = false,
  });

  final ActionTask task;
  final Future<void> Function(bool isCompleted) onChanged;
  final VoidCallback? onDelete;
  final bool dense;

  @override
  State<ActionTaskTile> createState() => _ActionTaskTileState();
}

class _ActionTaskTileState extends State<ActionTaskTile> {
  bool? _optimisticDone;
  bool _isToggling = false;
  bool _justCompleted = false;

  bool get _done =>
      _optimisticDone ?? widget.task.isDoneOn(DateTime.now());

  @override
  void didUpdateWidget(ActionTaskTile oldWidget) {
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
    final typeLabel = widget.task.type.isDaily ? l10n.dailyTask : l10n.oneTimeTask;
    final subtitle = widget.task.isUserCreated
        ? '$typeLabel · ${l10n.yourTaskLabel}'
        : typeLabel;
    final verticalPadding = widget.dense ? 10.0 : 14.0;

    return Card(
      margin: EdgeInsets.only(bottom: widget.dense ? 4 : 8),
      color: _done
          ? AppColors.success.withValues(alpha: 0.06)
          : theme.cardTheme.color,
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, verticalPadding, 4, verticalPadding),
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
                            _done ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.slate400,
                        color: _done ? AppColors.slate500 : null,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(widget.task.title),
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
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.removeCustomTask,
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
