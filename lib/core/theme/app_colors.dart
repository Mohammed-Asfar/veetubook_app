import 'package:flutter/material.dart';

/// Single source of truth for all colors used in veetubook.
///
/// Do NOT hardcode `Color(0xFF...)` anywhere in feature code.
/// Reference these tokens (via the theme) instead so that light/dark and
/// future re-skinning change in exactly one place.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF2E7D32); // green — groceries/fresh
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFFF9A825); // amber accent

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFC62828);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1565C0);

  // Neutrals (light)
  static const Color background = Color(0xFFF7F8F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1B1C1A);
  static const Color onSurfaceMuted = Color(0xFF6B6F69);
  static const Color border = Color(0xFFE2E5DF);

  // Neutrals (dark)
  static const Color backgroundDark = Color(0xFF121412);
  static const Color surfaceDark = Color(0xFF1D201C);
  static const Color onSurfaceDark = Color(0xFFECEFE9);
  static const Color onSurfaceMutedDark = Color(0xFF9BA093);
  static const Color borderDark = Color(0xFF33372F);
}
