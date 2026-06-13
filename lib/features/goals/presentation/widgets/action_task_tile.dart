import 'package:flutter/material.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/entities/action_task.dart';

class ActionTaskTile extends StatelessWidget {
  const ActionTaskTile({
    super.key,
    required this.task,
    required this.onChanged,
  });

  final ActionTask task;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final done = task.isDoneOn(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: done,
        onChanged: (value) => onChanged(value ?? false),
        title: Text(task.title),
        subtitle: Text(
          task.type.isDaily ? 'Daily task' : 'One-time task',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
        ),
      ),
    );
  }
}
