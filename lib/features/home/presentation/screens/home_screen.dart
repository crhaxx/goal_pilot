import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/goals/domain/utils/crisis_detector.dart';
import 'package:goal_pilot/features/goals/presentation/providers/goal_providers.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/crisis_mode_banner.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/daily_checkin_sheet.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/rest_day_card.dart';
import 'package:goal_pilot/features/goals/presentation/widgets/today_focus_card.dart';
import 'package:goal_pilot/features/gamification/domain/pilot_status.dart';
import 'package:goal_pilot/features/gamification/presentation/widgets/done_wall_widget.dart';
import 'package:goal_pilot/features/gamification/presentation/widgets/pilot_cockpit_banner.dart';
import 'package:goal_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:goal_pilot/features/home/presentation/providers/motivation_providers.dart';
import 'package:goal_pilot/features/home/presentation/widgets/contextual_prompt_banner.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_empty_state.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_hero_header.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:goal_pilot/features/home/presentation/widgets/home_stats_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.watch(todayProvider);
    final goalsAsync = ref.watch(goalsStreamProvider);
    final pendingCheckIns = ref.watch(pendingCheckInGoalsProvider);
    final restDayGoals = ref.watch(restDayGoalsProvider);
    final crisisGoals = ref.watch(crisisGoalsProvider);
    final statsAsync = ref.watch(homeStatsProvider);
    final winBricksAsync = ref.watch(allWinBricksProvider);
    final contextualPromptAsync = ref.watch(contextualPromptProvider);
    ref.watch(homeWidgetStartupProvider);

    return Scaffold(
      body: SafeArea(
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text(l10n.couldNotLoad('$error'))),
          data: (goals) {
            if (goals.isEmpty) {
              return HomeEmptyState(
                onCreate: () => context.push(AppRoutes.createGoal),
              );
            }

            final averageProgress = statsAsync.valueOrNull?.averageProgress ?? 0;

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeStatsProvider);
                ref.invalidate(contextualPromptProvider);
                ref.invalidate(goalsStreamProvider);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeHeroHeader(averageProgress: averageProgress),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: contextualPromptAsync.when(
                        loading: () => ContextualPromptBanner(
                          label: l10n.contextualPromptLabel,
                          slogan: '',
                          loading: true,
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (slogan) {
                          if (slogan.trim().isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return ContextualPromptBanner(
                            label: l10n.contextualPromptLabel,
                            slogan: slogan,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: PilotCockpitBanner(
                        status: PilotStatus.aggregate(goals, l10n),
                      ),
                    ),
                  ),
                  if (crisisGoals.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverList.separated(
                        itemCount: crisisGoals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final goal = crisisGoals[index];
                          return CrisisModeBanner(
                            goal: goal,
                            reason: CrisisDetector.crisisReason(goal, l10n),
                          );
                        },
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeSectionHeader(
                        title: l10n.todaysFocus,
                        trailing: pendingCheckIns.isNotEmpty
                            ? HomePendingBadge(
                                label: l10n.pendingCount(pendingCheckIns.length),
                              )
                            : null,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: pendingCheckIns.isNotEmpty
                        ? SliverList.separated(
                            itemCount: pendingCheckIns.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final goal = pendingCheckIns[index];
                              return TodayFocusCard(
                                goal: goal,
                                onOpen: () =>
                                    context.push(AppRoutes.goalDetail(goal.id)),
                                onCheckIn: () => showDailyCheckInSheet(
                                  context: context,
                                  ref: ref,
                                  goal: goal,
                                ),
                              );
                            },
                          )
                        : SliverToBoxAdapter(
                            child: _AllDoneCard(message: l10n.allCheckInsDone),
                          ),
                  ),
                  if (restDayGoals.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: HomeSectionHeader(title: l10n.restDaySection),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverList.separated(
                        itemCount: restDayGoals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final goal = restDayGoals[index];
                          return RestDayCard(
                            goal: goal,
                            onOpen: () =>
                                context.push(AppRoutes.goalDetail(goal.id)),
                          );
                        },
                      ),
                    ),
                  ],
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeSectionHeader(title: l10n.homeOverview),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: statsAsync.when(
                        loading: () => const HomeStatsGridSkeleton(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (stats) => HomeStatsGrid(stats: stats),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeSectionHeader(title: l10n.homeQuickActions),
                          const SizedBox(height: 12),
                          HomeQuickActions(
                            onNewGoal: () => context.push(AppRoutes.createGoal),
                            onShare: () =>
                                ShareService.shareAllGoals(goals, l10n),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: winBricksAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (bricks) => DoneWallWidget(bricks: bricks),
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AllDoneCard extends StatelessWidget {
  const _AllDoneCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.12),
            AppColors.cyan.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
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
            child: const Icon(Icons.celebration, color: AppColors.success),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
