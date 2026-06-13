import 'dart:convert';

import 'package:goal_pilot/core/error/exceptions.dart';

/// Utilities for parsing Gemini API JSON responses.
abstract final class JsonUtils {
  /// Strips markdown code fences and parses JSON from AI output.
  static Map<String, dynamic> parseAiJson(String raw) {
    final cleaned = _stripCodeFences(raw.trim());
    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is! Map<String, dynamic>) {
        throw ParseException(
          'Expected JSON object, got ${decoded.runtimeType}',
          rawContent: raw,
        );
      }
      return decoded;
    } on FormatException catch (e) {
      throw ParseException(
        'Invalid JSON: ${e.message}',
        rawContent: raw,
      );
    }
  }

  static String _stripCodeFences(String input) {
    var text = input;
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      text = text.replaceFirst(RegExp(r'\s*```$'), '');
    }
    return text.trim();
  }
}
