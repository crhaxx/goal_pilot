import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/coach/presentation/widgets/pilot_coach_sheet.dart';
import 'package:goal_pilot/features/goals/domain/entities/daily_checkin.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/action_task_tile.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/daily_checkin_sheet.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';
import 'package:intl/intl.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalByIdProvider(goalId));

    return goalAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(failureMessage(error))),
      ),
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Goal not found.')),
          );
        }
        return _GoalDetailScaffold(goal: goal);
      },
    );
  }
}

class _GoalDetailScaffold extends ConsumerWidget {
  const _GoalDetailScaffold({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInsAsync = ref.watch(checkInsProvider(goal.id));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(goal.title),
          actions: [
            IconButton(
              onPressed: () => ShareService.shareGoal(goal),
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share progress',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Plan'),
              Tab(text: 'Journal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TodayTab(goal: goal),
            _PlanTab(goal: goal),
            checkInsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(failureMessage(e))),
              data: (checkIns) => _JournalTab(checkIns: checkIns),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (goal.needsCheckInToday)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FloatingActionButton.extended(
                  heroTag: 'checkin',
                  onPressed: () => showDailyCheckInSheet(
                    context: context,
                    ref: ref,
                    goal: goal,
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Check-in'),
                  backgroundColor: AppColors.cyan,
                  foregroundColor: Colors.white,
                ),
              ),
            FloatingActionButton(
              heroTag: 'coach',
              onPressed: () => showPilotCoachSheet(context: context, goal: goal),
              backgroundColor: AppColors.deepBlue,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayTab extends ConsumerWidget {
  const _TodayTab({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final milestone = goal.currentMilestone;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            StreakBadge(streak: goal.streak),
            const Spacer(),
            if (goal.hasCheckedInToday)
              Chip(
                avatar: Icon(Icons.check, color: AppColors.success, size: 18),
                label: const Text('Checked in'),
                backgroundColor: AppColors.success.withValues(alpha: 0.12),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: goal.progress, minHeight: 8),
        ),
        const SizedBox(height: 8),
        Text(
          '${goal.progressPercent}% · '
          '${goal.completedMilestoneCount}/${goal.totalMilestones} milestones',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.cyan,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (goal.dailyHabit.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            color: AppColors.cyan.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.repeat, color: theme.colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Habit',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(goal.dailyHabit),
                ],
              ),
            ),
          ),
        ],
        if (milestone != null) ...[
          const SizedBox(height: 20),
          Text(
            'Current Milestone',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            milestone.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (milestone.description != null) ...[
            const SizedBox(height: 4),
            Text(
              milestone.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
        ],
        const SizedBox(height: 20),
        Text(
          'Today\'s Tasks',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (goal.todayTasks.isEmpty)
          Text(
            milestone == null
                ? 'All milestones complete!'
                : 'No tasks yet — create a new goal for AI-generated daily steps.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
            ),
          )
        else
          ...goal.todayTasks.map(
            (task) => ActionTaskTile(
              task: task,
              onChanged: (checked) async {
                final repository =
                    await ref.read(goalRepositoryProvider.future);
                await repository.toggleTask(
                  goalId: goal.id,
                  taskId: task.id,
                  isCompleted: checked,
                );
                ref.invalidate(goalByIdProvider(goal.id));
              },
            ),
          ),
        if (goal.motivationalTips.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilot Tips',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(goal.motivationalTips),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlanTab extends ConsumerWidget {
  const _PlanTab({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          goal.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Milestones',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...goal.sortedMilestones.map((milestone) {
          final tasks = goal.tasksForMilestone(milestone.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(
                milestone.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: milestone.isCompleted
                    ? AppColors.success
                    : AppColors.slate500,
              ),
              title: Text(milestone.title),
              subtitle: milestone.description == null
                  ? null
                  : Text(milestone.description!),
              initiallyExpanded: goal.currentMilestone?.id == milestone.id,
              children: [
                if (tasks.isNotEmpty)
                  ...tasks.map(
                    (task) => ListTile(
                      dense: true,
                      leading: Icon(
                        task.isDoneOn(DateTime.now())
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: AppColors.cyan,
                      ),
                      title: Text(task.title),
                    ),
                  )
                else
                  const ListTile(
                    dense: true,
                    title: Text('No micro-tasks for this milestone'),
                  ),
                CheckboxListTile(
                  value: milestone.isCompleted,
                  onChanged: (checked) async {
                    final repository =
                        await ref.read(goalRepositoryProvider.future);
                    await repository.toggleMilestone(
                      goalId: goal.id,
                      milestoneId: milestone.id,
                      isCompleted: checked ?? false,
                    );
                    ref.invalidate(goalByIdProvider(goal.id));
                  },
                  title: const Text('Mark milestone complete'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _JournalTab extends StatelessWidget {
  const _JournalTab({required this.checkIns});

  final List<DailyCheckIn> checkIns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.MMMd();

    if (checkIns.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No check-ins yet.\nComplete your first daily check-in to '
            'start building your streak and journal.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.slate500,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: checkIns.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final checkIn = checkIns[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dateFormat.format(checkIn.date),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text('Mood: ${checkIn.mood}/5'),
                  ],
                ),
                if (checkIn.tasksTotal > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tasks: ${checkIn.tasksCompleted}/${checkIn.tasksTotal}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                ],
                if (checkIn.note != null && checkIn.note!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(checkIn.note!),
                ],
                if (checkIn.pilotMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(checkIn.pilotMessage!),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
