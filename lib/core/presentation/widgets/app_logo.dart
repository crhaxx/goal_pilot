import 'package:flutter/material.dart';

/// GoalPilot brand logo used across onboarding, home, and settings.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.borderRadius = 20,
  });

  static const assetPath = 'assets/images/logo.png';

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
