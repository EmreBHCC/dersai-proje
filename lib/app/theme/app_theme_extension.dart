import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.surfaceMuted,
    required this.border,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.courseColors,
  });

  final Color surfaceMuted;
  final Color border;
  final Color textSecondary;
  final Color textTertiary;
  final Color success;
  final Color warning;
  final List<Color> courseColors;

  static const AppThemeExtension light = AppThemeExtension(
    surfaceMuted: AppColors.lightSurfaceMuted,
    border: AppColors.lightBorder,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
    success: AppColors.success,
    warning: AppColors.warning,
    courseColors: [
      AppColors.courseBlue,
      AppColors.coursePurple,
      AppColors.courseOrange,
      AppColors.courseGreen,
      AppColors.coursePink,
      AppColors.courseTeal,
    ],
  );

  static const AppThemeExtension dark = AppThemeExtension(
    surfaceMuted: AppColors.darkSurfaceMuted,
    border: AppColors.darkBorder,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    success: AppColors.success,
    warning: AppColors.warning,
    courseColors: [
      AppColors.courseBlue,
      AppColors.coursePurple,
      AppColors.courseOrange,
      AppColors.courseGreen,
      AppColors.coursePink,
      AppColors.courseTeal,
    ],
  );

  @override
  AppThemeExtension copyWith({
    Color? surfaceMuted,
    Color? border,
    Color? textSecondary,
    Color? textTertiary,
    Color? success,
    Color? warning,
    List<Color>? courseColors,
  }) {
    return AppThemeExtension(
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      courseColors: courseColors ?? this.courseColors,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      courseColors: courseColors,
    );
  }
}

extension AppThemeExtensionGetter on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
