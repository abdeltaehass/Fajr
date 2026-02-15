import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

enum AppLanguage { english, arabic, french, turkish, urdu, malay }

class AppSettings extends ChangeNotifier {
  ColorTheme _colorTheme = ColorTheme.green;
  SeasonalTheme _seasonalTheme = SeasonalTheme.normal;
  AppLanguage _language = AppLanguage.english;

  AppColors get colors =>
      AppColorPalettes.withSeason(AppColorPalettes.forTheme(_colorTheme), _seasonalTheme);

  ColorTheme get colorTheme => _colorTheme;
  SeasonalTheme get seasonalTheme => _seasonalTheme;
  AppLanguage get language => _language;

  bool get isRtl => _language == AppLanguage.arabic || _language == AppLanguage.urdu;

  Locale get locale {
    switch (_language) {
      case AppLanguage.arabic:
        return const Locale('ar');
      case AppLanguage.french:
        return const Locale('fr');
      case AppLanguage.turkish:
        return const Locale('tr');
      case AppLanguage.urdu:
        return const Locale('ur');
      case AppLanguage.malay:
        return const Locale('ms');
      case AppLanguage.english:
        return const Locale('en');
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt('colorTheme') ?? 0;
    final seasonIndex = prefs.getInt('seasonalTheme') ?? 0;
    final langIndex = prefs.getInt('language') ?? 0;

    _colorTheme = ColorTheme.values[colorIndex.clamp(0, ColorTheme.values.length - 1)];
    _seasonalTheme = SeasonalTheme.values[seasonIndex.clamp(0, SeasonalTheme.values.length - 1)];
    _language = AppLanguage.values[langIndex.clamp(0, AppLanguage.values.length - 1)];
    notifyListeners();
  }

  Future<void> setColorTheme(ColorTheme theme) async {
    _colorTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('colorTheme', theme.index);
  }

  Future<void> setSeasonalTheme(SeasonalTheme theme) async {
    _seasonalTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seasonalTheme', theme.index);
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', language.index);
  }
}
