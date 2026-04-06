import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lavender,
        secondary: AppColors.softPink,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.lavender,
        inactiveTrackColor: AppColors.textHint,
        thumbColor: Colors.white,
        overlayColor: AppColors.lavender.withOpacity(0.2),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 52,
          fontWeight: FontWeight.w300,
          letterSpacing: 8,
          height: 1.0,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
          height: 1.15,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.dmSans(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleMedium: GoogleFonts.dmSans(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.dmSans(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.dmSans(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.dmSans(
          color: AppColors.gold,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.5,
        ),
        labelSmall: GoogleFonts.dmSans(
          color: AppColors.textHint,
          fontSize: 10,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
