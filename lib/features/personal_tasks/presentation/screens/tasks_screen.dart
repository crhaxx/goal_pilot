import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/providers/today_provider.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/providers/personal_task_providers.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/widgets/personal_task_sheet.dart';
import 'package:goal_pilot/features/personal_tasks/presentation/widgets/todays_tasks_section.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    ref.watch(todayProvider);
    ref.watch(personalTasksStartupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTasks),
        actions: [
          IconButton(
            onPressed: () => showPersonalTaskSheet(context: context, ref: ref),
            icon: const Icon(Icons.add),
            tooltip: l10n.personalTaskAddButton,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(personalTasksStreamProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.todaysTasksDesc,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverToBoxAdapter(
                child: TodaysTasksSection(showHeader: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
