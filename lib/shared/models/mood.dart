import 'package:flutter/material.dart';

/// Mood — mix'in karakteri. UI tema (gradient + accent) bu değere göre değişir.
enum Mood {
  fruity(
    label: 'Meyveli',
    color: Color(0xFFE9B040), // amber-gold
    gradientStart: Color(0xFF1F1A0E),
    gradientEnd: Color(0xFF3E2F12),
  ),
  berry(
    label: 'Berry',
    color: Color(0xFFE85A8C), // pink
    gradientStart: Color(0xFF1E0E14),
    gradientEnd: Color(0xFF3B1A27),
  ),
  mint(
    label: 'Ferah',
    color: Color(0xFF6BD7E0), // ice cyan
    gradientStart: Color(0xFF0B1A1E),
    gradientEnd: Color(0xFF15323A),
  ),
  tobacco(
    label: 'Tütünlü',
    color: Color(0xFFC79256), // bronze
    gradientStart: Color(0xFF1A130C),
    gradientEnd: Color(0xFF332618),
  ),
  sweet(
    label: 'Tatlı',
    color: Color(0xFFF5A769), // honey
    gradientStart: Color(0xFF1F140A),
    gradientEnd: Color(0xFF3D2614),
  ),
  cool(
    label: 'Serin',
    color: Color(0xFFA88BE8), // lavender
    gradientStart: Color(0xFF120E1A),
    gradientEnd: Color(0xFF241B36),
  );

  const Mood({
    required this.label,
    required this.color,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final String label;
  final Color color;
  final Color gradientStart;
  final Color gradientEnd;
}
