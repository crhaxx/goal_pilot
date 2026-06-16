import 'package:flutter/material.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class ProfilePreviewCard extends StatelessWidget {
  const ProfilePreviewCard({
    super.key,
    required this.title,
    required this.previewText,
    required this.isActive,
    required this.activeHint,
    required this.inactiveHint,
  });

  final String title;
  final String previewText;
  final bool isActive;
  final String activeHint;
  final String inactiveHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.slate400 : AppColors.slate500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cyan.withValues(alpha: 0.12),
            AppColors.deepBlue.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.record_voice_over_outlined,
                size: 18,
                color: AppColors.cyan.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            previewText,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isActive ? activeHint : inactiveHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: mutedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePrivacyNote extends StatelessWidget {
  const ProfilePrivacyNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.65)
        : AppColors.slate100.withValues(alpha: 0.65);
    final foregroundColor =
        isDark ? AppColors.slate400 : AppColors.slate500;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.slate200.withValues(alpha: 0.9);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, size: 18, color: foregroundColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foregroundColor,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSaveBar extends StatelessWidget {
  const ProfileSaveBar({
    super.key,
    required this.saveLabel,
    required this.onSave,
    required this.saving,
  });

  final String saveLabel;
  final VoidCallback onSave;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 12,
      shadowColor: Colors.black26,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.4)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: FilledButton(
            onPressed: saving ? null : onSave,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.cyan,
            ),
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    saveLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}
