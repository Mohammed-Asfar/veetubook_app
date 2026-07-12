import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_theme_extension.dart';

/// Assembles the light and dark [ThemeData] from the design tokens.
///
/// This is the ONLY place ThemeData is constructed. Feature widgets consume it
/// via `Theme.of(context)` / `context.appColors` and never build their own.
abstract final class AppTheme {
  /// Tamil-capable font family. Currently null so the platform default font
  /// (which renders Tamil on Android/iOS) is used. To ship a consistent glyph
  /// set, bundle Noto Sans Tamil via pubspec `fonts:` and set this to
  /// 'NotoSansTamil'. Kept as a single constant so it changes in one place.
  static const String? _fontFamily = null;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: isLight ? AppColors.danger : const Color(0xFFEF5350),
      onError: Colors.white,
      surface: isLight ? AppColors.surface : AppColors.surfaceDark,
      onSurface: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
    );

    final onSurface = colorScheme.onSurface;
    final muted =
        isLight ? AppColors.onSurfaceMuted : AppColors.onSurfaceMutedDark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isLight ? AppColors.background : AppColors.backgroundDark,
      textTheme: AppTextStyles.textTheme(onSurface, muted),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: AppSpacing.elevationCard,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.label,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.border : AppColors.borderDark,
        space: 1,
        thickness: 1,
      ),
      extensions: <ThemeExtension<dynamic>>[
        isLight ? AppThemeExtension.light : AppThemeExtension.dark,
      ],
    );
  }
}
