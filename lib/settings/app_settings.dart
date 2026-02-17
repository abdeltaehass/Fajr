import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/masjid.dart';
import 'app_colors.dart';

enum AppLanguage { english, arabic, french, turkish, urdu, malay }

class AppSettings extends ChangeNotifier {
  ColorTheme _colorTheme = ColorTheme.green;
  SeasonalTheme _seasonalTheme = SeasonalTheme.normal;
  AppLanguage _language = AppLanguage.english;
  Masjid? _selectedMasjid;

  AppColors get colors =>
      AppColorPalettes.withSeason(AppColorPalettes.forTheme(_colorTheme), _seasonalTheme);

  ColorTheme get colorTheme => _colorTheme;
  SeasonalTheme get seasonalTheme => _seasonalTheme;
  AppLanguage get language => _language;

  Masjid? get selectedMasjid => _selectedMasjid;

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

    final masjidJson = prefs.getString('selectedMasjid');
    if (masjidJson != null) {
      try {
        _selectedMasjid = Masjid.fromJson(jsonDecode(masjidJson) as Map<String, dynamic>);
      } catch (_) {
        // Ignore corrupted data
      }
    }

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

  Future<void> setSelectedMasjid(Masjid masjid) async {
    _selectedMasjid = masjid;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMasjid', jsonEncode(masjid.toJson()));
  }

  Future<void> clearSelectedMasjid() async {
    _selectedMasjid = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedMasjid');
  }
}
