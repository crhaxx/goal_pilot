import 'package:flutter/widgets.dart';
import 'package:goal_pilot/l10n/app_localizations.dart';

export 'package:goal_pilot/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

AppLocalizations l10nForLocale(String localeCode) {
  return lookupAppLocalizations(Locale(localeCode));
}
