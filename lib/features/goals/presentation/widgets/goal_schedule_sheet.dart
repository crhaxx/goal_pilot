import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal_schedule.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_schedule_picker.dart';

Future<void> showGoalScheduleSheet({
  required BuildContext context,
  required WidgetRef ref,
  required Goal goal,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => GoalScheduleSheet(goal: goal),
  );
}

class GoalScheduleSheet extends ConsumerStatefulWidget {
  const GoalScheduleSheet({super.key, required this.goal});

  final Goal goal;

  @override
  ConsumerState<GoalScheduleSheet> createState() => _GoalScheduleSheetState();
}

class _GoalScheduleSheetState extends ConsumerState<GoalScheduleSheet> {
  late GoalSchedule _schedule;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.goal.schedule;
  }

  bool get _hasChanges => _schedule != widget.goal.schedule;

  Future<void> _submit() async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await updateGoalSchedule(
        ref,
        goalId: widget.goal.id,
        schedule: _schedule,
      );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.scheduleUpdated)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage(error, context.l10n)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
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
                  color: AppColors.slate400.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scheduleSectionTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.scheduleSectionDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.slate500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: GoalScheduleCard(
                  schedule: _schedule,
                  enabled: !_isSubmitting,
                  showHeader: false,
                  onScheduleChanged: (value) =>
                      setState(() => _schedule = value),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.done),
            ),
          ],
        ),
      ),
    );
  }
}
