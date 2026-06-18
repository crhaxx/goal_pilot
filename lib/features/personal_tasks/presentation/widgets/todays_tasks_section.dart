import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:goal_pilot/features/personal_tasks/domain/entities/personal_task.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/providers/personal_task_providers.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/widgets/personal_task_sheet.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/widgets/personal_task_tile.dart';

class TodaysTasksSection extends ConsumerWidget {
  const TodaysTasksSection({super.key, this.showHeader = true});

  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasks = ref.watch(todaysPersonalTasksProvider);
    final completedTasks = ref.watch(todaysCompletedPersonalTasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          HomeSectionHeader(
            title: l10n.todaysTasks,
            subtitle: l10n.todaysTasksDesc,
            trailing: IconButton.filledTonal(
              onPressed: () => showPersonalTaskSheet(context: context, ref: ref),
              icon: const Icon(Icons.add_rounded),
              tooltip: l10n.personalTaskAddButton,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.cyan.withValues(alpha: 0.12),
                foregroundColor: AppColors.cyan,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (tasks.isEmpty && completedTasks.isEmpty)
          _EmptyTodaysTasks(
            onAdd: () => showPersonalTaskSheet(context: context, ref: ref),
          )
        else ...[
          ...tasks.map(
            (task) => PersonalTaskTile(
              task: task,
              onChanged: (isCompleted) => togglePersonalTask(
                ref,
                taskId: task.id,
                isCompleted: isCompleted,
              ),
              onEdit: () => showPersonalTaskSheet(
                context: context,
                ref: ref,
                existing: task,
              ),
              onDelete: () => deletePersonalTask(ref, task.id),
            ),
          ),
          if (completedTasks.isNotEmpty)
            _CompletedPersonalTasksSection(
              tasks: completedTasks,
              onToggle: (task, isCompleted) => togglePersonalTask(
                ref,
                taskId: task.id,
                isCompleted: isCompleted,
              ),
              onEdit: (task) => showPersonalTaskSheet(
                context: context,
                ref: ref,
                existing: task,
              ),
              onDelete: (task) => deletePersonalTask(ref, task.id),
            ),
        ],
      ],
    );
  }
}

class _CompletedPersonalTasksSection extends StatefulWidget {
  const _CompletedPersonalTasksSection({
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PersonalTask> tasks;
  final Future<void> Function(PersonalTask task, bool isCompleted) onToggle;
  final void Function(PersonalTask task) onEdit;
  final void Function(PersonalTask task) onDelete;

  @override
  State<_CompletedPersonalTasksSection> createState() =>
      _CompletedPersonalTasksSectionState();
}

class _CompletedPersonalTasksSectionState
    extends State<_CompletedPersonalTasksSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 4),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.completedPersonalTasksCount(widget.tasks.length),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate500,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.slate500,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded)
          ...widget.tasks.map(
            (task) => PersonalTaskTile(
              task: task,
              muted: true,
              onChanged: (isCompleted) => widget.onToggle(task, isCompleted),
              onEdit: () => widget.onEdit(task),
              onDelete: () => widget.onDelete(task),
            ),
          ),
      ],
    );
  }
}

class _EmptyTodaysTasks extends StatelessWidget {
  const _EmptyTodaysTasks({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate500.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 36,
            color: AppColors.slate500.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.todaysTasksEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.personalTaskAddButton),
          ),
        ],
      ),
    );
  }
}
