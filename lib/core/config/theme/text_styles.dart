import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTextStyle {
  AppTextStyle._();

  static TextStyle headlineLarge = GoogleFonts.fredoka(
    fontSize: 46.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle headlineMedium = GoogleFonts.fredoka(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 16.sp,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.white,
  );

  static TextStyle headlineSmall = GoogleFonts.fredoka(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: 0.0,
    color: AppColors.white,
  );

  static TextStyle displayMedium = GoogleFonts.fredoka(
    fontWeight: FontWeight.w500,
    fontSize: 24.sp,
    height: 1,
    letterSpacing: 0,
    color: AppColors.black,
  );

  static TextStyle bodySmall = GoogleFonts.fredoka(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: 'SfPro',
    fontWeight: FontWeight.w600,
    fontSize: 17.sp,
    height: 22 / 17,
    letterSpacing: -0.41,
    color: AppColors.black,
  );
}
