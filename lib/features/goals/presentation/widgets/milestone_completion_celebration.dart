import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_pilot/core/theme/app_colors.dart';

class MilestoneCompletionCelebrationOverlay extends StatefulWidget {
  const MilestoneCompletionCelebrationOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onDismiss,
  });

  final String title;
  final String subtitle;
  final VoidCallback onDismiss;

  @override
  State<MilestoneCompletionCelebrationOverlay> createState() =>
      _MilestoneCompletionCelebrationOverlayState();
}

class _MilestoneCompletionCelebrationOverlayState
    extends State<MilestoneCompletionCelebrationOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _burstController;
  late final AnimationController _cardController;
  late final AnimationController _fadeController;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    final random = Random();
    _particles = List.generate(18, (index) {
      final angle = (index / 18) * 2 * pi + random.nextDouble() * 0.4;
      return _Particle(
        angle: angle,
        distance: 80 + random.nextDouble() * 60,
        size: 6 + random.nextDouble() * 6,
        color: [
          AppColors.success,
          AppColors.cyan,
          AppColors.deepBlue,
          const Color(0xFFFFD166),
        ][index % 4],
      );
    });

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    Future<void>.delayed(const Duration(milliseconds: 2800), () async {
      if (!mounted) return;
      await _fadeController.forward();
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _burstController.dispose();
    _cardController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
      ),
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        child: GestureDetector(
          onTap: () async {
            if (_fadeController.isAnimating) return;
            await _fadeController.forward();
            if (mounted) widget.onDismiss();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _burstController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _BurstPainter(
                      progress: Curves.easeOutCubic.transform(
                        _burstController.value,
                      ),
                      particles: _particles,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _cardController,
                  curve: Curves.elasticOut,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _cardController,
                    curve: const Interval(0, 0.6, curve: Curves.easeOut),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.success.withValues(alpha: 0.15),
                          AppColors.cyan.withValues(alpha: 0.12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.25),
                          blurRadius: 32,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.celebration,
                                  color: AppColors.success,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.slate500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
  });

  final double angle;
  final double distance;
  final double size;
  final Color color;
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.progress, required this.particles});

  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final dx = cos(particle.angle) * particle.distance * progress;
      final dy = sin(particle.angle) * particle.distance * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity * 0.9)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center + Offset(dx, dy),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
