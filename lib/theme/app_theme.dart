import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicColors {
  static const Color deepGreen = Color(0xFF0D4A2E);
  static const Color darkGreen = Color(0xFF0A3D24);
  static const Color forestGreen = Color(0xFF1B6B42);
  static const Color gold = Color(0xFFC9A84C);
  static const Color lightGold = Color(0xFFE8D5A3);
  static const Color cream = Color(0xFFF5F0E1);
  static const Color activeGlow = Color(0xFFFFD700);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: IslamicColors.deepGreen,
      colorScheme: const ColorScheme.dark(
        primary: IslamicColors.forestGreen,
        secondary: IslamicColors.gold,
        surface: IslamicColors.darkGreen,
      ),
      cardTheme: CardThemeData(
        color: IslamicColors.darkGreen,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.amiri(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: IslamicColors.gold,
        ),
        displayMedium: GoogleFonts.amiri(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: IslamicColors.gold,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.amiri(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: IslamicColors.cream,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: IslamicColors.lightGold,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: IslamicColors.lightGold,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: IslamicColors.lightGold,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
