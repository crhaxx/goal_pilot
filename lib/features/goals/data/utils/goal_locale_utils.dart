/// Normalizes app locale codes to supported AI locales.
String normalizeGoalLocale(String? code) {
  if (code == null || code.isEmpty) return 'en';
  return code.toLowerCase().startsWith('cs') ? 'cs' : 'en';
}

bool goalNeedsLocaleSync({
  required String? contentLocaleCode,
  required String targetLocaleCode,
}) {
  return normalizeGoalLocale(contentLocaleCode) !=
      normalizeGoalLocale(targetLocaleCode);
}
