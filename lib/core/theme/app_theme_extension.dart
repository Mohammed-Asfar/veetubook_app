import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Custom design tokens that don't fit into [ColorScheme].
///
/// Access via `Theme.of(context).extension<AppThemeExtension>()!`.
/// This keeps app-specific semantic colors (e.g. price up/down, bought state)
/// in one place for both light and dark themes.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.border,
    required this.mutedText,
    required this.priceUp,
    required this.priceDown,
    required this.boughtOverlay,
  });

  final Color success;
  final Color danger;
  final Color warning;
  final Color info;
  final Color border;
  final Color mutedText;

  /// Spend increased month-over-month (bad for a budget).
  final Color priceUp;

  /// Spend decreased month-over-month (good).
  final Color priceDown;

  /// Overlay/strike color for a bought item in shopping mode.
  final Color boughtOverlay;

  static const light = AppThemeExtension(
    success: AppColors.success,
    danger: AppColors.danger,
    warning: AppColors.warning,
    info: AppColors.info,
    border: AppColors.border,
    mutedText: AppColors.onSurfaceMuted,
    priceUp: AppColors.danger,
    priceDown: AppColors.success,
    boughtOverlay: AppColors.onSurfaceMuted,
  );

  static const dark = AppThemeExtension(
    success: AppColors.success,
    danger: Color(0xFFEF5350),
    warning: AppColors.warning,
    info: Color(0xFF64B5F6),
    border: AppColors.borderDark,
    mutedText: AppColors.onSurfaceMutedDark,
    priceUp: Color(0xFFEF5350),
    priceDown: Color(0xFF66BB6A),
    boughtOverlay: AppColors.onSurfaceMutedDark,
  );

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? danger,
    Color? warning,
    Color? info,
    Color? border,
    Color? mutedText,
    Color? priceUp,
    Color? priceDown,
    Color? boughtOverlay,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      border: border ?? this.border,
      mutedText: mutedText ?? this.mutedText,
      priceUp: priceUp ?? this.priceUp,
      priceDown: priceDown ?? this.priceDown,
      boughtOverlay: boughtOverlay ?? this.boughtOverlay,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      border: Color.lerp(border, other.border, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      priceUp: Color.lerp(priceUp, other.priceUp, t)!,
      priceDown: Color.lerp(priceDown, other.priceDown, t)!,
      boughtOverlay: Color.lerp(boughtOverlay, other.boughtOverlay, t)!,
    );
  }
}

/// Convenience accessor: `context.appColors.priceUp`.
extension AppThemeX on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
