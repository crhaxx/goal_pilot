import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/daily_checkin_sheet.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/today_focus_card.dart';
import 'package:goal_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:goal_pilot/features/home/presentation/widgets/stat_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsStreamProvider);
    final pendingCheckIns = ref.watch(pendingCheckInGoalsProvider);
    final statsAsync = ref.watch(homeStatsProvider);

    return Scaffold(
      body: SafeArea(
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Could not load: $error')),
          data: (goals) {
            if (goals.isEmpty) {
              return _EmptyHome(onCreate: () => context.push(AppRoutes.createGoal));
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeStatsProvider);
                ref.invalidate(goalsStreamProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  Text(
                    homeGreeting(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConfig.appTagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  statsAsync.when(
                    loading: () => const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (stats) => Row(
                      children: [
                        StatCard(
                          label: 'Active goals',
                          value: '${stats.activeGoals}',
                          icon: Icons.flag_outlined,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'Best streak',
                          value: '${stats.bestStreak}',
                          icon: Icons.local_fire_department,
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  statsAsync.maybeWhen(
                    data: (stats) => Row(
                      children: [
                        StatCard(
                          label: 'Check-ins (7d)',
                          value: '${stats.checkInsThisWeek}',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'Avg progress',
                          value: '${stats.averageProgress}%',
                          icon: Icons.trending_up,
                          color: AppColors.deepBlue,
                        ),
                      ],
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context.push(AppRoutes.createGoal),
                          icon: const Icon(Icons.add),
                          label: const Text('New Goal'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => ShareService.shareAllGoals(goals),
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                  if (pendingCheckIns.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s Focus',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${pendingCheckIns.length} pending',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...pendingCheckIns.map(
                      (goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TodayFocusCard(
                          goal: goal,
                          onOpen: () =>
                              context.push(AppRoutes.goalDetail(goal.id)),
                          onCheckIn: () => showDailyCheckInSheet(
                            context: context,
                            ref: ref,
                            goal: goal,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 28),
                    Card(
                      color: AppColors.success.withValues(alpha: 0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.celebration, color: AppColors.success),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'All check-ins done for today. Great work!',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flight_takeoff, size: 72, color: theme.colorScheme.secondary),
          const SizedBox(height: 20),
          Text(
            'Welcome to ${AppConfig.appName}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Set a goal, get a daily plan, check in with Pilot, '
            'and review your progress every week.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.slate500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create your first goal'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
