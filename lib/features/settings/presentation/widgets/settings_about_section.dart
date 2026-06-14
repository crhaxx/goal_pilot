import 'package:flutter/material.dart';
import 'package:goal_pilot/core/config/app_config.dart';
import 'package:goal_pilot/core/l10n/l10n.dart';
import 'package:goal_pilot/core/presentation/widgets/app_logo.dart';
import 'package:goal_pilot/core/services/share_service.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AboutHeroCard(l10n: l10n, isDark: isDark),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsAboutFeaturesTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _FeatureChip(
                  icon: Icons.auto_awesome,
                  label: l10n.emptyHomeFeaturePlan,
                  color: AppColors.cyan,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _FeatureChip(
                  icon: Icons.flight_takeoff,
                  label: l10n.emptyHomeFeatureCheckIn,
                  color: AppColors.deepBlue,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _FeatureChip(
                  icon: Icons.psychology_outlined,
                  label: l10n.onboardingCoachTitle,
                  color: AppColors.warning,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _FeatureChip(
                  icon: Icons.insights_outlined,
                  label: l10n.emptyHomeFeatureReview,
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.shield_outlined,
                  color: isDark ? AppColors.cyanLight : AppColors.cyan,
                ),
                title: Text(l10n.settingsAboutPrivacyTitle),
                subtitle: Text(l10n.settingsAboutPrivacyDesc),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.psychology_outlined,
                  color: isDark ? AppColors.cyanLight : AppColors.deepBlue,
                ),
                title: Text(l10n.settingsPoweredByGemini),
                subtitle: Text(
                  '${l10n.settingsPoweredByGeminiDesc}\n'
                  '${l10n.settingsGeminiModel(AppConfig.geminiModels.first)}',
                ),
                isThreeLine: true,
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.ios_share_outlined,
                  color: isDark ? AppColors.cyanLight : AppColors.cyan,
                ),
                title: Text(l10n.settingsShareApp),
                subtitle: Text(l10n.settingsShareAppDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ShareService.shareApp(l10n),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutHeroCard extends StatelessWidget {
  const _AboutHeroCard({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkSurface,
                  AppColors.deepBlue.withValues(alpha: 0.85),
                  const Color(0xFF1E4D7B),
                ]
              : const [AppColors.navy, AppColors.deepBlue, Color(0xFF1E4D7B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: isDark ? 0.25 : 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -18,
            right: -10,
            child: Icon(
              Icons.flight,
              size: 96,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            child: Column(
              children: [
                const AppLogo(size: 72, borderRadius: 18),
                const SizedBox(height: 16),
                Text(
                  l10n.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.appTagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    l10n.settingsVersion(AppConfig.version),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
