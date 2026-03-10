import 'package:flutter/material.dart';
import 'package:fresh_check/app/theme/app_colors.dart';
import 'package:fresh_check/app/theme/app_text_theme.dart';

/// App-wide Material 3 theme configuration.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        textTheme: AppTextTheme.textTheme,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primaryLight,
          selectionHandleColor: AppColors.primary,
        ),
      );
}
