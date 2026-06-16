import 'package:goal_pilot/features/personalization/domain/entities/coaching_focus_style.dart';
import 'package:goal_pilot/features/personalization/domain/entities/user_personalization.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

abstract final class ProfilePreviewBuilder {
  static String build(AppLocalizations l10n, UserPersonalization profile) {
    if (!profile.enabled) {
      return l10n.personalizationPreviewInactive;
    }
    if (!profile.hasContent) {
      return l10n.personalizationPreviewEmpty;
    }

    final name =
        profile.hasDisplayName ? profile.displayName!.trim() : 'Captain';
    final style = profile.coachingStyle != null
        ? _coachingSnippet(l10n, profile.coachingStyle!)
        : l10n.personalizationPreviewStyleDefault;

    return l10n.personalizationPreviewSample(name, style);
  }

  static String _coachingSnippet(
    AppLocalizations l10n,
    CoachingFocusStyle style,
  ) {
    return switch (style) {
      CoachingFocusStyle.empathetic =>
        l10n.personalizationPreviewStyleEmpathetic,
      CoachingFocusStyle.balanced => l10n.personalizationPreviewStyleBalanced,
      CoachingFocusStyle.direct => l10n.personalizationPreviewStyleDirect,
      CoachingFocusStyle.military =>
        l10n.personalizationPreviewStyleMilitary,
    };
  }
}
