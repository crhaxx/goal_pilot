import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';

Future<void> showDailyCheckInSheet({
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
    builder: (context) => DailyCheckInSheet(goal: goal),
  );
}

class DailyCheckInSheet extends ConsumerStatefulWidget {
  const DailyCheckInSheet({super.key, required this.goal});

  final Goal goal;

  @override
  ConsumerState<DailyCheckInSheet> createState() => _DailyCheckInSheetState();
}

class _DailyCheckInSheetState extends ConsumerState<DailyCheckInSheet> {
  double _mood = 3;
  final _noteController = TextEditingController();
  String? _pilotMessage;

  static const _moodLabels = ['', 'Rough', 'Low', 'Okay', 'Good', 'Great'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final updated = await ref.read(checkInControllerProvider.notifier).submit(
            goalId: widget.goal.id,
            mood: _mood.round(),
            note: _noteController.text,
          );

      if (!mounted || updated == null) return;

      final checkIns = await ref.read(goalRepositoryProvider.future).then(
            (repo) => repo.getCheckIns(widget.goal.id),
          );
      final todayCheckIn = checkIns.isNotEmpty ? checkIns.first : null;

      setState(() {
        _pilotMessage = todayCheckIn?.pilotMessage;
      });

      ref.invalidate(goalByIdProvider(widget.goal.id));
      ref.invalidate(checkInsProvider(widget.goal.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(checkInControllerProvider);
    final isLoading = state.isLoading;
    final goal = widget.goal;
    final completed = goal.todayTasksCompleted();
    final total = goal.todayTasksTotal;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Daily Check-in',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            goal.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'How are you feeling today?',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('😔', style: theme.textTheme.titleMedium),
              Expanded(
                child: Slider(
                  value: _mood,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _moodLabels[_mood.round()],
                  onChanged: _pilotMessage == null
                      ? (value) => setState(() => _mood = value)
                      : null,
                ),
              ),
              Text('🔥', style: theme.textTheme.titleMedium),
            ],
          ),
          Center(
            child: Text(
              _moodLabels[_mood.round()],
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.cyan,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            enabled: _pilotMessage == null && !isLoading,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'What did you work on today? (optional)',
            ),
          ),
          if (total > 0) ...[
            const SizedBox(height: 12),
            Text(
              'Tasks today: $completed/$total completed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
          const SizedBox(height: 20),
          if (_pilotMessage != null) ...[
            Card(
              color: AppColors.cyan.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy_outlined,
                            color: theme.colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Pilot says',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_pilotMessage!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ] else ...[
            FilledButton.icon(
              onPressed: isLoading ? null : _submit,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(isLoading ? 'Pilot is thinking…' : 'Complete Check-in'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
