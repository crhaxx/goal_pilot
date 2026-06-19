import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/core/utils/failure_message.dart';
import 'package:goal_pilot/features/coach/presentation/widgets/pilot_coach_sheet.dart';
import 'package:goal_pilot/features/coach/presentation/widgets/roleplay_sheet.dart';
import 'package:goal_pilot/features/gamification/domain/pilot_status.dart';
import 'package:goal_pilot/features/gamification/presentation/widgets/done_wall_widget.dart';
import 'package:goal_pilot/features/gamification/presentation/widgets/pilot_cockpit_banner.dart';
import 'package:goal_pilot/features/goals/domain/entities/goal.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/add_task_sheet.dart';
import 'package:goal_pilot/features/goals/domain/entities/milestone.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/action_task_tile.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/anti_goal_card.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/crisis_mode_banner.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/worked_today_checkbox.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/extend_milestones_button.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/friction_warning_card.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_schedule_sheet.dart';
import 'package:goal_pilot/features/goals/domain/utils/goal_schedule_utils.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/milestone_completion_celebration.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/pivot_wizard_sheet.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/reality_check_card.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/streak_badge.dart';

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
        appBar: AppBar(leading: _goalDetailBackButton(context)),
        body: Center(child: Text(failureMessage(error, context.l10n))),
      ),
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(leading: _goalDetailBackButton(context)),
            body: Center(child: Text(context.l10n.goalNotFound)),
          );
        }
        return _GoalDetailScaffold(goal: goal);
      },
    );
  }
}

class _GoalDetailScaffold extends ConsumerStatefulWidget {
  const _GoalDetailScaffold({required this.goal});

  final Goal goal;

  @override
  ConsumerState<_GoalDetailScaffold> createState() => _GoalDetailScaffoldState();
}

class _GoalDetailScaffoldState extends ConsumerState<_GoalDetailScaffold> {
  bool _showCelebration = false;

  @override
  void didUpdateWidget(_GoalDetailScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.goal.isFullyComplete &&
        widget.goal.isFullyComplete &&
        !_showCelebration) {
      setState(() => _showCelebration = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final l10n = context.l10n;

    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(goal.title),
              leading: _goalDetailBackButton(context),
              actions: [
                IconButton(
                  onPressed: () => ShareService.shareGoal(goal, l10n),
                  icon: const Icon(Icons.share_outlined),
                  tooltip: l10n.shareProgress,
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.tabToday),
                  Tab(text: l10n.tabPlan),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _TodayTab(goal: goal),
                _PlanTab(goal: goal),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'coach',
              onPressed: () =>
                  showPilotCoachSheet(context: context, goal: goal),
              backgroundColor: AppColors.deepBlue,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
          ),
        ),
        if (_showCelebration)
          Positioned.fill(
            child: MilestoneCompletionCelebrationOverlay(
              title: l10n.milestoneCelebrationTitle,
              subtitle: l10n.milestoneCelebrationSubtitle(goal.title),
              onDismiss: () => setState(() => _showCelebration = false),
            ),
          ),
      ],
    );
  }
}

class _TodayTab extends ConsumerWidget {
  const _TodayTab({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final milestone = goal.currentMilestone;
    final friction = goal.activeFrictionPoint;
    final pivotSuggestion = ref.watch(pivotSuggestionProvider(goal.id));
    final crisisSuggestion = ref.watch(crisisSuggestionProvider(goal.id));
    final winBricksAsync = ref.watch(winBricksProvider(goal.id));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PilotCockpitBanner(
          status: PilotStatus.forGoal(goal, l10n),
          compact: true,
        ),
        if (goal.crisisModeActive) ...[
          const SizedBox(height: 12),
          ActiveCrisisBanner(goal: goal),
        ] else if (crisisSuggestion != null) ...[
          const SizedBox(height: 12),
          CrisisModeBanner(goal: goal, reason: crisisSuggestion.reason),
        ],
        if (pivotSuggestion != null) ...[
          const SizedBox(height: 12),
          Card(
            color: AppColors.error.withValues(alpha: 0.08),
            child: ListTile(
              leading: Icon(Icons.sync_alt, color: AppColors.error),
              title: Text(l10n.pivotSuggested),
              subtitle: Text(
                pivotSuggestion.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showPivotWizardSheet(
                context: context,
                ref: ref,
                goal: goal,
                reason: pivotSuggestion.reason,
              ),
            ),
          ),
        ],
        if (friction != null) ...[
          const SizedBox(height: 12),
          FrictionWarningCard(
            friction: friction,
            onAskPilot: () => showPilotCoachSheet(context: context, goal: goal),
          ),
        ],
        const SizedBox(height: 12),
        if (goal.isFullyComplete) ...[
          _MilestoneCompleteBanner(goal: goal),
          const SizedBox(height: 16),
        ],
        RealityCheckCard(goal: goal),
        if (goal.antiGoals.isNotEmpty) ...[
          const SizedBox(height: 12),
          AntiGoalCard(antiGoals: goal.antiGoals),
        ],
        if (goal.roleplayMilestone != null) ...[
          const SizedBox(height: 12),
          Card(
            color: AppColors.deepBlue.withValues(alpha: 0.06),
            child: ListTile(
              leading: Icon(Icons.theater_comedy, color: AppColors.deepBlue),
              title: Text(l10n.fireDrillSimulator),
              subtitle: Text(
                goal.roleplayMilestone!.roleplayScenario!.scenarioBrief,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showRoleplaySheet(context: context, goal: goal),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_today, color: theme.colorScheme.secondary),
            title: Text(l10n.scheduleSectionTitle),
            subtitle: Text(
              GoalScheduleUtils.formatScheduleSummary(goal.schedule, l10n),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showGoalScheduleSheet(
              context: context,
              ref: ref,
              goal: goal,
            ),
          ),
        ),
        const SizedBox(height: 16),
        WorkedTodayCheckbox(goal: goal),
        const SizedBox(height: 16),
        Row(
          children: [
            StreakBadge(streak: goal.streak),
            const Spacer(),
            if (goal.hasCheckedInToday)
              Chip(
                avatar: Icon(Icons.check, color: AppColors.success, size: 18),
                label: Text(l10n.checkedIn),
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
          l10n.progressMilestones(
            goal.progressPercent,
            goal.completedMilestoneCount,
            goal.totalMilestones,
          ),
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
                        l10n.dailyHabit,
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
            l10n.currentMilestone,
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
          goal.crisisModeActive ? l10n.emergencySteps : l10n.todaysTasks,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (goal.todayTasks.isEmpty)
          goal.isFullyComplete
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.allMilestonesComplete,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ExtendMilestonesButton(goal: goal),
                  ],
                )
              : Text(
                  milestone == null
                      ? l10n.allMilestonesComplete
                      : l10n.noTasksYet,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
                )
        else
          ...goal.todayTasks.map(
            (task) => ActionTaskTile(
              key: ValueKey(task.id),
              task: task,
              onChanged: (checked) => toggleGoalTask(
                ref,
                goalId: goal.id,
                taskId: task.id,
                isCompleted: checked,
              ),
              onDelete: task.isUserCreated
                  ? () async {
                      final repository =
                          ref.read(goalRepositoryProvider).requireValue;
                      await repository.removeTask(
                        goalId: goal.id,
                        taskId: task.id,
                      );
                      ref.invalidate(goalByIdProvider(goal.id));
                    }
                  : null,
            ),
          ),
        if (!goal.crisisModeActive &&
            !goal.isFullyComplete &&
            milestone != null) ...[
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => showAddTaskSheet(
              context: context,
              ref: ref,
              goal: goal,
              milestoneId: milestone.id,
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.addCustomTaskAction),
          ),
        ],
        if (goal.motivationalTips.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pilotTips,
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
        const SizedBox(height: 20),
        winBricksAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (bricks) => DoneWallWidget(
            bricks: bricks,
            title: l10n.doneWallThisGoal,
          ),
        ),
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
    final l10n = context.l10n;

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
        if (goal.antiGoals.isNotEmpty) ...[
          AntiGoalCard(antiGoals: goal.antiGoals),
          const SizedBox(height: 20),
        ],
        Text(
          l10n.milestones,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, _) {
            final pivot = ref.watch(pivotSuggestionProvider(goal.id));
            if (pivot == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton.icon(
                onPressed: () => showPivotWizardSheet(
                  context: context,
                  ref: ref,
                  goal: goal,
                  reason: pivot.reason,
                ),
                icon: const Icon(Icons.sync_alt),
                label: Text(l10n.pivotWizardEdit),
              ),
            );
          },
        ),
        ...goal.sortedMilestones.map(
          (milestone) => _MilestoneCard(
            goal: goal,
            milestone: milestone,
            initiallyExpanded: goal.currentMilestone?.id == milestone.id,
          ),
        ),
        if (goal.isFullyComplete) ...[
          const SizedBox(height: 8),
          ExtendMilestonesButton(goal: goal),
        ],
      ],
    );
  }
}

class _MilestoneCompleteBanner extends StatefulWidget {
  const _MilestoneCompleteBanner({required this.goal});

  final Goal goal;

  @override
  State<_MilestoneCompleteBanner> createState() =>
      _MilestoneCompleteBannerState();
}

class _MilestoneCompleteBannerState extends State<_MilestoneCompleteBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: 1.02).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.success.withValues(alpha: 0.14),
              AppColors.cyan.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: AppColors.success),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.milestoneCelebrationTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.milestoneCelebrationBannerSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.slate500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneCard extends ConsumerStatefulWidget {
  const _MilestoneCard({
    required this.goal,
    required this.milestone,
    required this.initiallyExpanded,
  });

  final Goal goal;
  final Milestone milestone;
  final bool initiallyExpanded;

  @override
  ConsumerState<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends ConsumerState<_MilestoneCard> {
  late bool _expanded;
  bool _justCompleted = false;

  bool get _isCompleted => widget.milestone.isCompleted;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(_MilestoneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.milestone.isCompleted && widget.milestone.isCompleted) {
      _justCompleted = true;
      HapticFeedback.mediumImpact();
    } else if (oldWidget.milestone.isCompleted != widget.milestone.isCompleted) {
      _justCompleted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final milestone = widget.milestone;
    final goal = widget.goal;
    final tasks = goal.tasksForMilestone(milestone.id);
    final hasRoleplay =
        milestone.hasRoleplay && goal.currentMilestone?.id == milestone.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: _isCompleted
          ? AppColors.success.withValues(alpha: 0.06)
          : theme.cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CompletionCircle(
                        isDone: _isCompleted,
                        size: 32,
                        animate: _justCompleted,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: _isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppColors.slate400,
                              color: _isCompleted ? AppColors.slate500 : null,
                            ),
                            child: Text(milestone.title),
                          ),
                          if (milestone.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              milestone.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.slate500,
                              ),
                            ),
                          ],
                        ],
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
          if (_expanded) ...[
            const Divider(height: 1),
            if (hasRoleplay)
              ListTile(
                leading: Icon(Icons.theater_comedy, color: AppColors.deepBlue),
                title: Text(l10n.launchSimulator),
                subtitle: Text(milestone.roleplayScenario!.characterRole),
                onTap: () => showRoleplaySheet(context: context, goal: goal),
              ),
            if (tasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  children: tasks
                      .map(
                        (task) => ActionTaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          dense: true,
                          onChanged: (checked) => toggleGoalTask(
                            ref,
                            goalId: goal.id,
                            taskId: task.id,
                            isCompleted: checked,
                          ),
                          onDelete: task.isUserCreated
                              ? () async {
                                  final repository = ref
                                      .read(goalRepositoryProvider)
                                      .requireValue;
                                  await repository.removeTask(
                                    goalId: goal.id,
                                    taskId: task.id,
                                  );
                                  ref.invalidate(goalByIdProvider(goal.id));
                                }
                              : null,
                        ),
                      )
                      .toList(),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.noMicroTasks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
            if (!_isCompleted)
              ListTile(
                leading: Icon(Icons.add, color: AppColors.cyan),
                title: Text(l10n.addCustomTaskAction),
                onTap: () => showAddTaskSheet(
                  context: context,
                  ref: ref,
                  goal: goal,
                  milestoneId: milestone.id,
                ),
              ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

Widget? _goalDetailBackButton(BuildContext context) {
  if (context.canPop()) return null;

  return IconButton(
    icon: const Icon(Icons.arrow_back),
    tooltip: context.l10n.back,
    onPressed: () => context.go(AppRoutes.home),
  );
}
