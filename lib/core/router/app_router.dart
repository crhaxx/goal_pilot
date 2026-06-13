import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/presentation/main_shell.dart';
import 'package:goal_pilot/features/goals/presentation/screens/create_goal_screen.dart';
import 'package:goal_pilot/features/goals/presentation/screens/goals_list_screen.dart';
import 'package:goal_pilot/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:goal_pilot/features/home/presentation/screens/home_screen.dart';
import 'package:goal_pilot/features/review/presentation/screens/review_screen.dart';
import 'package:goal_pilot/features/settings/presentation/screens/settings_screen.dart';

abstract final class AppRoutes {
  static const home = '/home';
  static const goals = '/goals';
  static const review = '/review';
  static const settings = '/settings';
  static const createGoal = '/goals/create';

  static String goalDetail(String id) => '/goal/$id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.goals,
              builder: (context, state) => const GoalsListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.review,
              builder: (context, state) => const ReviewScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.createGoal,
      builder: (context, state) => const CreateGoalScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/goal/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GoalDetailScreen(goalId: id);
      },
    ),
  ],
);
