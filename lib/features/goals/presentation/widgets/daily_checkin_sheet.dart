import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/domain/utils/crisis_detector.dart';
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
  bool? _antiGoalSurrendered;
  int _selectedAntiGoalIndex = 0;

  String _moodLabel(AppLocalizations l10n, int mood) {
    switch (mood) {
      case 1:
        return l10n.moodRough;
      case 2:
        return l10n.moodLow;
      case 3:
        return l10n.moodOkay;
      case 4:
        return l10n.moodGood;
      case 5:
        return l10n.moodGreat;
      default:
        return '';
    }
  }

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
            antiGoalSurrendered: widget.goal.antiGoals.isNotEmpty
                ? _antiGoalSurrendered
                : null,
            antiGoalIndex: widget.goal.antiGoals.isNotEmpty
                ? _selectedAntiGoalIndex
                : null,
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
      ref.invalidate(winBricksProvider(widget.goal.id));
      ref.invalidate(allWinBricksProvider);

      if (CrisisDetector.noteSignalsCrisis(_noteController.text) &&
          !widget.goal.crisisModeActive &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.crisisDetectedSnack),
            action: SnackBarAction(
              label: context.l10n.ok,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(e, context.l10n)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
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
            l10n.checkInTitle,
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
            l10n.howFeelingToday,
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
                  label: _moodLabel(l10n, _mood.round()),
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
              _moodLabel(l10n, _mood.round()),
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
            decoration: InputDecoration(
              hintText: l10n.checkInNoteHint,
            ),
          ),
          if (total > 0) ...[
            const SizedBox(height: 12),
            Text(
              l10n.tasksTodayCompleted(completed, total),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
          if (goal.antiGoals.isNotEmpty && _pilotMessage == null) ...[
            const SizedBox(height: 16),
            Text(
              l10n.antiGoalSection,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedAntiGoalIndex.clamp(0, goal.antiGoals.length - 1),
              decoration: InputDecoration(
                labelText: l10n.antiGoalWhich,
              ),
              items: goal.antiGoals.asMap().entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedAntiGoalIndex = value);
                      }
                    },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.antiGoalSurrenderedQuestion(
                goal.antiGoals[
                    _selectedAntiGoalIndex.clamp(0, goal.antiGoals.length - 1)]
                    .title,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() => _antiGoalSurrendered = true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _antiGoalSurrendered == true
                          ? AppColors.error
                          : null,
                      side: _antiGoalSurrendered == true
                          ? BorderSide(color: AppColors.error)
                          : null,
                    ),
                    child: Text(l10n.antiGoalYes),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() => _antiGoalSurrendered = false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _antiGoalSurrendered == false
                          ? AppColors.success
                          : null,
                      side: _antiGoalSurrendered == false
                          ? BorderSide(color: AppColors.success)
                          : null,
                    ),
                    child: Text(l10n.antiGoalNo),
                  ),
                ),
              ],
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
                          l10n.pilotSays,
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
              child: Text(l10n.done),
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
              label: Text(
                isLoading ? l10n.pilotThinking : l10n.completeCheckIn,
              ),
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
