import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/masjid.dart';
import '../models/iqama_times.dart';
import '../models/masjid_event.dart';
import 'app_colors.dart';

enum AppLanguage { english, arabic, french, turkish, urdu, malay }

class AppSettings extends ChangeNotifier {
  ColorTheme _colorTheme = ColorTheme.green;
  SeasonalTheme _seasonalTheme = SeasonalTheme.normal;
  AppLanguage _language = AppLanguage.english;
  Masjid? _selectedMasjid;
  IqamaTimes? _iqamaTimes;
  List<MasjidEvent> _masjidEvents = [];

  AppColors get colors =>
      AppColorPalettes.withSeason(AppColorPalettes.forTheme(_colorTheme), _seasonalTheme);

  ColorTheme get colorTheme => _colorTheme;
  SeasonalTheme get seasonalTheme => _seasonalTheme;
  AppLanguage get language => _language;
  Masjid? get selectedMasjid => _selectedMasjid;
  IqamaTimes? get iqamaTimes => _iqamaTimes;
  List<MasjidEvent> get masjidEvents => List.unmodifiable(_masjidEvents);

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
      } catch (_) {}
    }

    final iqamaJson = prefs.getString('iqamaTimes');
    if (iqamaJson != null) {
      try {
        _iqamaTimes = IqamaTimes.fromJson(jsonDecode(iqamaJson) as Map<String, dynamic>);
      } catch (_) {}
    }

    final eventsJson = prefs.getString('masjidEvents');
    if (eventsJson != null) {
      try {
        final list = jsonDecode(eventsJson) as List<dynamic>;
        _masjidEvents = list
            .map((e) => MasjidEvent.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
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
    _iqamaTimes = null;
    _masjidEvents = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedMasjid');
    await prefs.remove('iqamaTimes');
    await prefs.remove('masjidEvents');
  }

  Future<void> setIqamaTimes(IqamaTimes times) async {
    _iqamaTimes = times;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('iqamaTimes', jsonEncode(times.toJson()));
  }

  Future<void> addMasjidEvent(MasjidEvent event) async {
    _masjidEvents.add(event);
    _masjidEvents.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'masjidEvents',
      jsonEncode(_masjidEvents.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> removeMasjidEvent(String id) async {
    _masjidEvents.removeWhere((e) => e.id == id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'masjidEvents',
      jsonEncode(_masjidEvents.map((e) => e.toJson()).toList()),
    );
  }
}
