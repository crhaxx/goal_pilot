import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/goal_card.dart';

class GoalsListScreen extends ConsumerWidget {
  const GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final goalsAsync = ref.watch(goalsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myGoals),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.createGoal),
            icon: const Icon(Icons.add),
            tooltip: l10n.newGoalTooltip,
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorPrefix('$error'))),
        data: (goals) {
          Future<void> onRefresh() async {
            ref.invalidate(goalsStreamProvider);
          }

          if (goals.isEmpty) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag_outlined,
                              size: 56, color: theme.colorScheme.secondary),
                          const SizedBox(height: 16),
                          Text(l10n.noGoalsYet,
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            l10n.noGoalsDesc,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.slate500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.createGoal),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.newGoal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final goal = goals[index];
                return GoalCard(
                  goal: goal,
                  onTap: () => context.push(AppRoutes.goalDetail(goal.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
