import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

Future<void> showAddTaskSheet({
  required BuildContext context,
  required WidgetRef ref,
  required Goal goal,
  String? milestoneId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AddTaskSheet(
      goal: goal,
      initialMilestoneId: milestoneId ?? goal.currentMilestone?.id,
    ),
  );
}

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({
    super.key,
    required this.goal,
    this.initialMilestoneId,
  });

  final Goal goal;
  final String? initialMilestoneId;

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  late String? _milestoneId;
  TaskType _taskType = TaskType.once;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _milestoneId = widget.initialMilestoneId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final milestoneId = _milestoneId;
    if (milestoneId == null) return;

    setState(() => _isSubmitting = true);
    try {
      final repository = await ref.read(goalRepositoryProvider.future);
      await repository.addTask(
        goalId: widget.goal.id,
        milestoneId: milestoneId,
        title: _titleController.text,
        type: _taskType,
      );
      ref.invalidate(goalByIdProvider(widget.goal.id));
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage(error, l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final openMilestones = widget.goal.sortedMilestones
        .where((milestone) => !milestone.isCompleted)
        .toList();
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate500.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.addCustomTaskTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addCustomTaskDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 20),
          if (openMilestones.length > 1) ...[
            DropdownButtonFormField<String>(
              value: _milestoneId,
              decoration: InputDecoration(
                labelText: l10n.addCustomTaskMilestone,
                border: const OutlineInputBorder(),
              ),
              items: openMilestones
                  .map(
                    (milestone) => DropdownMenuItem(
                      value: milestone.id,
                      child: Text(
                        milestone.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _isSubmitting
                  ? null
                  : (value) => setState(() => _milestoneId = value),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _titleController,
            enabled: !_isSubmitting,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.addCustomTaskHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.addCustomTaskType,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<TaskType>(
            segments: [
              ButtonSegment(
                value: TaskType.once,
                label: Text(l10n.oneTimeTask),
                icon: const Icon(Icons.looks_one_outlined),
              ),
              ButtonSegment(
                value: TaskType.daily,
                label: Text(l10n.dailyTask),
                icon: const Icon(Icons.repeat),
              ),
            ],
            selected: {_taskType},
            onSelectionChanged: _isSubmitting
                ? null
                : (selection) => setState(() => _taskType = selection.first),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSubmitting || _milestoneId == null ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.addCustomTaskButton),
          ),
        ],
      ),
    );
  }
}
