import 'package:flutter/material.dart';

/// Single source of truth for typography.
///
/// Sizes use logical pixels and scale with the system text scaler.
/// `fontFamily` is left null so the app-wide font (incl. Tamil fallback via
/// Noto Sans Tamil) resolves from the theme. Do not inline `TextStyle` in
/// feature widgets — reference `Theme.of(context).textTheme` or these tokens.
abstract final class AppTextStyles {
  static const TextStyle displayLarge =
      TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2);
  static const TextStyle titleLarge =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.25);
  static const TextStyle titleMedium =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle bodyLarge =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle bodyMedium =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle label =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.3);
  static const TextStyle caption =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.3);

  /// Emphasised style for prices / running totals.
  static const TextStyle price =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  static TextTheme textTheme(Color onSurface, Color muted) => TextTheme(
        displayLarge: displayLarge.copyWith(color: onSurface),
        titleLarge: titleLarge.copyWith(color: onSurface),
        titleMedium: titleMedium.copyWith(color: onSurface),
        bodyLarge: bodyLarge.copyWith(color: onSurface),
        bodyMedium: bodyMedium.copyWith(color: onSurface),
        labelLarge: label.copyWith(color: onSurface),
        bodySmall: caption.copyWith(color: muted),
      );
}
