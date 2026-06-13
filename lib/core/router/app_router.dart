import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/presentation/main_shell.dart';
import 'package:goal_pilot/features/goals/presentation/screens/create_goal_screen.dart';
import 'package:goal_pilot/features/goals/presentation/screens/goals_list_screen.dart';
import 'package:goal_pilot/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:goal_pilot/features/home/presentation/screens/home_screen.dart';
import 'package:goal_pilot/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:goal_pilot/features/onboarding/presentation/screens/language_selection_screen.dart';
import 'package:goal_pilot/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:goal_pilot/features/review/presentation/screens/review_screen.dart';
import 'package:goal_pilot/features/settings/presentation/providers/settings_providers.dart';
import 'package:goal_pilot/features/settings/presentation/screens/settings_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const languageSelect = '/language';
  static const home = '/home';
  static const goals = '/goals';
  static const review = '/review';
  static const settings = '/settings';
  static const createGoal = '/goals/create';

  static String goalDetail(String id) => '/goal/$id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final completed = ref.read(onboardingCompletedProvider);
      final hasLocale = ref.read(hasSelectedLocaleProvider);
      final location = state.matchedLocation;
      final onOnboarding = location == AppRoutes.onboarding;
      final onLanguageSelect = location == AppRoutes.languageSelect;

      if (!completed && !onOnboarding) return AppRoutes.onboarding;
      if (completed && !hasLocale && !onLanguageSelect) {
        return AppRoutes.languageSelect;
      }
      if (hasLocale && (onOnboarding || onLanguageSelect)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelect,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
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
});
