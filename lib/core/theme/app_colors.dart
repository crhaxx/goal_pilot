import 'package:flutter/material.dart';

/// GoalPilot design tokens — deep blues, slate grays, cyan accents.
abstract final class AppColors {
  // Brand
  static const deepBlue = Color(0xFF1E3A5F);
  static const navy = Color(0xFF0F172A);
  static const cyan = Color(0xFF06B6D4);
  static const cyanLight = Color(0xFF22D3EE);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);

  // Semantic
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  // Light surfaces
  static const lightBackground = slate50;
  static const lightSurface = Colors.white;
  static const lightOnSurface = navy;

  // Dark surfaces
  static const darkBackground = Color(0xFF0B1120);
  static const darkSurface = Color(0xFF1E293B);
  static const darkSurfaceVariant = Color(0xFF334155);
  static const darkOnSurface = slate100;
}
