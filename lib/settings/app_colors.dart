import 'package:flutter/material.dart';

class AppColors {
  final Color scaffold;
  final Color card;
  final Color surface;
  final Color accent;
  final Color accentLight;
  final Color bodyText;
  final Color activeGlow;
  final bool isLight;

  const AppColors({
    required this.scaffold,
    required this.card,
    required this.surface,
    required this.accent,
    required this.accentLight,
    required this.bodyText,
    required this.activeGlow,
    this.isLight = false,
  });

  AppColors copyWith({
    Color? scaffold,
    Color? card,
    Color? surface,
    Color? accent,
    Color? accentLight,
    Color? bodyText,
    Color? activeGlow,
    bool? isLight,
  }) {
    return AppColors(
      scaffold: scaffold ?? this.scaffold,
      card: card ?? this.card,
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      bodyText: bodyText ?? this.bodyText,
      activeGlow: activeGlow ?? this.activeGlow,
      isLight: isLight ?? this.isLight,
    );
  }
}

enum ColorTheme { green, blue, black, white, pink, yellow, purple, teal, crimson }

enum SeasonalTheme { normal, ramadan, eid, hajj, laylatulQadr }

class AppColorPalettes {
  static const green = AppColors(
    scaffold: Color(0xFF0D4A2E),
    card: Color(0xFF0A3D24),
    surface: Color(0xFF1B6B42),
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFE8D5A3),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const blue = AppColors(
    scaffold: Color(0xFF0D2B4A),
    card: Color(0xFF0A2440),
    surface: Color(0xFF1B4A6B),
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFE8D5A3),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const black = AppColors(
    scaffold: Color(0xFF121212),
    card: Color(0xFF1E1E1E),
    surface: Color(0xFF2C2C2C),
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFE8D5A3),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const white = AppColors(
    scaffold: Color(0xFFF5F5F0),
    card: Color(0xFFFFFFFF),
    surface: Color(0xFFE8E8E0),
    accent: Color(0xFF0D4A2E),
    accentLight: Color(0xFF2E7D52),
    bodyText: Color(0xFF1A1A1A),
    activeGlow: Color(0xFFC9A84C),
    isLight: true,
  );

  static const pink = AppColors(
    scaffold: Color(0xFFB03060),
    card: Color(0xFF963050),
    surface: Color(0xFFCC4878),
    accent: Color(0xFFFACCE0),
    accentLight: Color(0xFFFDE8F2),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const yellow = AppColors(
    scaffold: Color(0xFFC89020),
    card: Color(0xFFA87818),
    surface: Color(0xFFE0A828),
    accent: Color(0xFFFFF080),
    accentLight: Color(0xFFFFFAC8),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const purple = AppColors(
    scaffold: Color(0xFF4A1E7A),
    card: Color(0xFF3D1866),
    surface: Color(0xFF6930A8),
    accent: Color(0xFFCAAFF5),
    accentLight: Color(0xFFE2D4FA),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const teal = AppColors(
    scaffold: Color(0xFF0A3D3A),
    card: Color(0xFF073330),
    surface: Color(0xFF1A6058),
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFE8D5A3),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static const crimson = AppColors(
    scaffold: Color(0xFF4A0D1E),
    card: Color(0xFF3D0A18),
    surface: Color(0xFF6B1A30),
    accent: Color(0xFFC9A84C),
    accentLight: Color(0xFFE8D5A3),
    bodyText: Color(0xFFF5F0E1),
    activeGlow: Color(0xFFFFD700),
  );

  static AppColors forTheme(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.green:
        return green;
      case ColorTheme.blue:
        return blue;
      case ColorTheme.black:
        return black;
      case ColorTheme.white:
        return white;
      case ColorTheme.pink:
        return pink;
      case ColorTheme.yellow:
        return yellow;
      case ColorTheme.purple:
        return purple;
      case ColorTheme.teal:
        return teal;
      case ColorTheme.crimson:
        return crimson;
    }
  }

  static AppColors withSeason(AppColors base, SeasonalTheme season) {
    switch (season) {
      case SeasonalTheme.normal:
        return base;
      case SeasonalTheme.ramadan:
        return base.copyWith(
          accent: const Color(0xFFC0C0C0),
          accentLight: const Color(0xFFD8D8D8),
          activeGlow: const Color(0xFFE8E8E8),
        );
      case SeasonalTheme.eid:
        return base.copyWith(
          accent: const Color(0xFFFFD700),
          accentLight: const Color(0xFFFFF0C0),
          activeGlow: const Color(0xFFFFE44D),
        );
      case SeasonalTheme.hajj:
        return base.copyWith(
          surface: Color.lerp(base.surface, const Color(0xFF8B7355), 0.4)!,
          accent: const Color(0xFFD4A847),
          accentLight: const Color(0xFFE8CFA0),
        );
      case SeasonalTheme.laylatulQadr:
        return base.copyWith(
          surface: Color.lerp(base.surface, const Color(0xFF2E1B5C), 0.4)!,
          accent: const Color(0xFFD4C4A0),
          accentLight: const Color(0xFFE0D8C8),
          activeGlow: const Color(0xFFE8DFC0),
        );
    }
  }

  static Color previewColor(ColorTheme theme) {
    return forTheme(theme).scaffold;
  }

  static String themeName(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.green:
        return 'Green';
      case ColorTheme.blue:
        return 'Blue';
      case ColorTheme.black:
        return 'Black';
      case ColorTheme.white:
        return 'White';
      case ColorTheme.pink:
        return 'Pink';
      case ColorTheme.yellow:
        return 'Yellow';
      case ColorTheme.purple:
        return 'Purple';
      case ColorTheme.teal:
        return 'Teal';
      case ColorTheme.crimson:
        return 'Crimson';
    }
  }

  static String seasonName(SeasonalTheme season) {
    switch (season) {
      case SeasonalTheme.normal:
        return 'Normal';
      case SeasonalTheme.ramadan:
        return 'Ramadan';
      case SeasonalTheme.eid:
        return 'Eid';
      case SeasonalTheme.hajj:
        return 'Hajj';
      case SeasonalTheme.laylatulQadr:
        return 'Laylatul Qadr';
    }
  }
}
