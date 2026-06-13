import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/presentation/widgets/app_logo.dart';
import 'package:goal_pilot/core/router/app_router.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';
import 'package:goal_pilot/features/onboarding/presentation/providers/onboarding_providers.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
}

const _pageCount = 6;

List<_OnboardingPage> _onboardingPages(AppLocalizations l10n) => [
  _OnboardingPage(
    icon: Icons.flight_takeoff_rounded,
    title: l10n.onboardingWelcomeTitle(l10n.appName),
    description: l10n.onboardingWelcomeDesc,
    iconColor: AppColors.cyan,
  ),
  _OnboardingPage(
    icon: Icons.flag_rounded,
    title: l10n.onboardingGoalTitle,
    description: l10n.onboardingGoalDesc,
    iconColor: AppColors.deepBlue,
  ),
  _OnboardingPage(
    icon: Icons.task_alt_rounded,
    title: l10n.onboardingDailyTitle,
    description: l10n.onboardingDailyDesc,
    iconColor: AppColors.success,
  ),
  _OnboardingPage(
    icon: Icons.psychology_rounded,
    title: l10n.onboardingCoachTitle,
    description: l10n.onboardingCoachDesc,
    iconColor: AppColors.cyan,
  ),
  _OnboardingPage(
    icon: Icons.insights_rounded,
    title: l10n.onboardingReviewTitle,
    description: l10n.onboardingReviewDesc,
    iconColor: AppColors.warning,
  ),
  _OnboardingPage(
    icon: Icons.rocket_launch_rounded,
    title: l10n.onboardingReadyTitle,
    description: l10n.onboardingReadyDesc(l10n.appName),
    iconColor: AppColors.cyan,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _pageCount - 1;

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider).complete();
    if (!mounted) return;
    context.go(AppRoutes.languageSelect);
  }

  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;
    final pages = _onboardingPages(l10n);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  l10n.skip,
                  style: TextStyle(color: AppColors.slate500),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (index == 0 || index == pages.length - 1)
                          const AppLogo(size: 140, borderRadius: 28)
                        else
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: (page.iconColor ?? AppColors.cyan)
                                  .withValues(alpha: isDark ? 0.2 : 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              page.icon,
                              size: 56,
                              color: page.iconColor ?? AppColors.cyan,
                            ),
                          ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.slate500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.cyan
                              : AppColors.slate400.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _isLastPage ? l10n.getStarted : l10n.next,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
