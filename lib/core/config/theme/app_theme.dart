import 'package:flutter/material.dart';
import 'text_styles.dart';
import 'app_colors.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData get standard {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory, // Disable all ripple splashes
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.black),
        backgroundColor: AppColors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: AppColors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
      ),
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headlineLarge: AppTextStyle.headlineLarge,
      headlineMedium: AppTextStyle.headlineMedium,
      headlineSmall: AppTextStyle.headlineSmall,
      displayMedium: AppTextStyle.displayMedium,
      bodySmall: AppTextStyle.bodySmall,
      titleMedium: AppTextStyle.titleMedium,
    );
  }
}
