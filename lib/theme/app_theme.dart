import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/app_colors.dart';

// Kept for backward compatibility — maps to the green palette.
// Prefer using context.colors from SettingsProvider instead.
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
  static ThemeData get darkTheme => fromColors(AppColorPalettes.green);

  static ThemeData fromColors(AppColors c) {
    final brightness = c.isLight ? Brightness.light : Brightness.dark;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: c.scaffold,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.surface,
        secondary: c.accent,
        surface: c.card,
        onPrimary: c.bodyText,
        onSecondary: c.scaffold,
        onSurface: c.bodyText,
        error: Colors.red,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.amiri(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: c.accent,
        ),
        displayMedium: GoogleFonts.amiri(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c.accent,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: highEmphasis,
        ),
        titleLarge: GoogleFonts.amiri(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: highEmphasis,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.bodyText,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: c.accentLight,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: c.accentLight,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: c.accentLight,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
