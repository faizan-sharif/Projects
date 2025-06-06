// themes.dart

import 'package:flutter/material.dart';
import 'package:weatherapp/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // Light Theme
  final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      secondary: AppColors.inversePrimaryColor,
      inversePrimary: AppColors.inversePrimaryColor,
      tertiary: AppColors.textPrimaryColor,
      onSecondary: AppColors.secondaryButtonColor,
    ),
    cardColor: AppColors.cardColor,

    textTheme: TextTheme(
      displayLarge: GoogleFonts.dancingScript(
        fontSize: 64,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryColor,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryColor,
      ),
      displaySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryColor,
      ),
      headlineLarge: GoogleFonts.bitter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryColor,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryColor,
      ),
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppDarkColors.scaffoldBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppDarkColors.primaryColor,
      primary: AppDarkColors.primaryColor,
      secondary: AppDarkColors.inversePrimaryColor,
      inversePrimary: AppDarkColors.inversePrimaryColor,
      tertiary: AppDarkColors.textPrimaryColor,
      onSecondary: AppColors.secondaryButtonColor,
    ),
    cardColor: AppDarkColors.cardColor,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.dancingScript(
        fontSize: 64,
        fontWeight: FontWeight.w400,
        color: AppDarkColors.textPrimaryColor,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppDarkColors.textPrimaryColor,
      ),
      displaySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppDarkColors.textPrimaryColor,
      ),
      headlineLarge: GoogleFonts.bitter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppDarkColors.textPrimaryColor,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppDarkColors.textPrimaryColor,
      ),
    ),
    // ... other dark theme properties
  );
}
