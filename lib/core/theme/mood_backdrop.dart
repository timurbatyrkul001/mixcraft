import 'package:flutter/material.dart';

import '../../shared/models/mood.dart';
import 'app_colors.dart';

/// Mood'a göre tam ekran gradient arka plan.
/// AnimatedContainer ile mood değişimleri yumuşak geçer.
class MoodBackdrop extends StatelessWidget {
  const MoodBackdrop({
    super.key,
    required this.mood,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
  });

  final Mood mood;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            mood.gradientStart,
            AppColors.background,
            mood.gradientEnd.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Mood'un vurgu rengi ile küçük bir glow halo.
class MoodGlow extends StatelessWidget {
  const MoodGlow({
    super.key,
    required this.mood,
    this.size = 240,
    this.opacity = 0.3,
  });

  final Mood mood;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              mood.color.withValues(alpha: opacity),
              mood.color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
