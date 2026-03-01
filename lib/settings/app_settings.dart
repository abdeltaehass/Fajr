import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/masjid.dart';
import '../models/iqama_times.dart';
import '../models/masjid_event.dart';
import 'app_colors.dart';

enum AppLanguage { english, arabic, french, turkish, urdu, malay, indonesian, bengali, persian }

class AppSettings extends ChangeNotifier {
  ColorTheme _colorTheme = ColorTheme.green;
  SeasonalTheme _seasonalTheme = SeasonalTheme.normal;
  AppLanguage _language = AppLanguage.english;
  Masjid? _selectedMasjid;
  // Iqama times and events stored per masjid placeId
  Map<String, IqamaTimes> _iqamaTimesMap = {};
  Map<String, List<MasjidEvent>> _masjidEventsMap = {};
  bool _adhanEnabled = false;
  bool _adhanSoundEnabled = false;
  bool _reminderEnabled = false;
  int _reminderMinutes = 10;
  bool _sunriseNotifEnabled = false;
  bool _tahajjudNotifEnabled = false;
  Set<String> _athkarNotifEnabled = {};
  String _reciterId = 'ar.alafasy';
  String _adhanSoundId = 'adhan_rabeh_ibn_darah.caf';

  AppColors get colors =>
      AppColorPalettes.withSeason(AppColorPalettes.forTheme(_colorTheme), _seasonalTheme);

  ColorTheme get colorTheme => _colorTheme;
  SeasonalTheme get seasonalTheme => _seasonalTheme;
  AppLanguage get language => _language;
  Masjid? get selectedMasjid => _selectedMasjid;
  IqamaTimes? get iqamaTimes =>
      _selectedMasjid != null ? _iqamaTimesMap[_selectedMasjid!.placeId] : null;
  List<MasjidEvent> get masjidEvents {
    if (_selectedMasjid == null) return [];
    return List.unmodifiable(_masjidEventsMap[_selectedMasjid!.placeId] ?? []);
  }
  bool get adhanEnabled => _adhanEnabled;
  bool get adhanSoundEnabled => _adhanSoundEnabled;
  bool get reminderEnabled => _reminderEnabled;
  int get reminderMinutes => _reminderMinutes;
  bool get sunriseNotifEnabled => _sunriseNotifEnabled;
  bool get tahajjudNotifEnabled => _tahajjudNotifEnabled;
  Set<String> get athkarNotifEnabled => Set.unmodifiable(_athkarNotifEnabled);
  String get reciterId => _reciterId;
  String get adhanSoundId => _adhanSoundId;

  bool get isRtl => _language == AppLanguage.arabic || _language == AppLanguage.urdu || _language == AppLanguage.persian;

  String get quranEdition {
    switch (_language) {
      case AppLanguage.arabic:
        return 'ar.muyassar';
      case AppLanguage.french:
        return 'fr.hamidullah';
      case AppLanguage.turkish:
        return 'tr.diyanet';
      case AppLanguage.urdu:
        return 'ur.jalandhry';
      case AppLanguage.malay:
        return 'ms.basmeih';
      case AppLanguage.indonesian:
        return 'id.indonesian';
      case AppLanguage.bengali:
        return 'bn.bengali';
      case AppLanguage.persian:
        return 'fa.ayati';
      case AppLanguage.english:
        return 'en.hilali';
    }
  }

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
      case AppLanguage.indonesian:
        return const Locale('id');
      case AppLanguage.bengali:
        return const Locale('bn');
      case AppLanguage.persian:
        return const Locale('fa');
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

    _adhanEnabled = prefs.getBool('adhanEnabled') ?? false;
    _adhanSoundEnabled = prefs.getBool('adhanSoundEnabled') ?? false;
    _reminderEnabled = prefs.getBool('reminderEnabled') ?? false;
    _reminderMinutes = prefs.getInt('reminderMinutes') ?? 10;
    _sunriseNotifEnabled = prefs.getBool('sunriseNotifEnabled') ?? false;
    _tahajjudNotifEnabled = prefs.getBool('tahajjudNotifEnabled') ?? false;
    _reciterId = prefs.getString('reciterId') ?? 'ar.alafasy';
    _adhanSoundId = (prefs.getString('adhanSoundId') ?? 'adhan_rabeh_ibn_darah.caf')
        .replaceAll('.mp3', '.caf');

    final athkarJson = prefs.getString('athkarNotifEnabled');
    if (athkarJson != null) {
      try {
        _athkarNotifEnabled =
            Set<String>.from(jsonDecode(athkarJson) as List);
      } catch (_) {}
    }

    final iqamaMapJson = prefs.getString('iqamaTimesMap');
    if (iqamaMapJson != null) {
      try {
        final map = jsonDecode(iqamaMapJson) as Map<String, dynamic>;
        _iqamaTimesMap = map.map((k, v) =>
            MapEntry(k, IqamaTimes.fromJson(v as Map<String, dynamic>)));
      } catch (_) {}
    }
    // Migrate old single-masjid iqama format
    if (_iqamaTimesMap.isEmpty && _selectedMasjid != null) {
      final oldJson = prefs.getString('iqamaTimes');
      if (oldJson != null) {
        try {
          _iqamaTimesMap[_selectedMasjid!.placeId] =
              IqamaTimes.fromJson(jsonDecode(oldJson) as Map<String, dynamic>);
        } catch (_) {}
      }
    }

    final eventsMapJson = prefs.getString('masjidEventsMap');
    if (eventsMapJson != null) {
      try {
        final map = jsonDecode(eventsMapJson) as Map<String, dynamic>;
        _masjidEventsMap = map.map((k, v) {
          final list = (v as List<dynamic>)
              .map((e) => MasjidEvent.fromJson(e as Map<String, dynamic>))
              .toList();
          return MapEntry(k, list);
        });
      } catch (_) {}
    }
    // Migrate old single-masjid events format
    if (_masjidEventsMap.isEmpty && _selectedMasjid != null) {
      final oldJson = prefs.getString('masjidEvents');
      if (oldJson != null) {
        try {
          final list = (jsonDecode(oldJson) as List<dynamic>)
              .map((e) => MasjidEvent.fromJson(e as Map<String, dynamic>))
              .toList();
          _masjidEventsMap[_selectedMasjid!.placeId] = list;
        } catch (_) {}
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
    // Iqama times and events are retained per placeId for if the masjid is re-selected
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedMasjid');
  }

  Future<void> setIqamaTimes(IqamaTimes times) async {
    final id = _selectedMasjid?.placeId;
    if (id == null) return;
    _iqamaTimesMap[id] = times;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'iqamaTimesMap',
      jsonEncode(_iqamaTimesMap.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  Future<void> clearIqamaTimes() async {
    final id = _selectedMasjid?.placeId;
    if (id == null) return;
    _iqamaTimesMap.remove(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'iqamaTimesMap',
      jsonEncode(_iqamaTimesMap.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  Future<void> addMasjidEvent(MasjidEvent event) async {
    final id = _selectedMasjid?.placeId;
    if (id == null) return;
    final events = List<MasjidEvent>.from(_masjidEventsMap[id] ?? []);
    events.add(event);
    events.sort((a, b) => a.date.compareTo(b.date));
    _masjidEventsMap[id] = events;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'masjidEventsMap',
      jsonEncode(_masjidEventsMap
          .map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()))),
    );
  }

  Future<void> removeMasjidEvent(String eventId) async {
    final id = _selectedMasjid?.placeId;
    if (id == null) return;
    final events = List<MasjidEvent>.from(_masjidEventsMap[id] ?? []);
    events.removeWhere((e) => e.id == eventId);
    _masjidEventsMap[id] = events;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'masjidEventsMap',
      jsonEncode(_masjidEventsMap
          .map((k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()))),
    );
  }

  Future<void> setAdhanEnabled(bool value) async {
    _adhanEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhanEnabled', value);
  }

  Future<void> setAdhanSoundEnabled(bool value) async {
    _adhanSoundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhanSoundEnabled', value);
  }

  Future<void> setReminderEnabled(bool value) async {
    _reminderEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminderEnabled', value);
  }

  Future<void> setReminderMinutes(int minutes) async {
    _reminderMinutes = minutes;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderMinutes', minutes);
  }

  Future<void> setSunriseNotifEnabled(bool value) async {
    _sunriseNotifEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sunriseNotifEnabled', value);
  }

  Future<void> setTahajjudNotifEnabled(bool value) async {
    _tahajjudNotifEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tahajjudNotifEnabled', value);
  }

  Future<void> setAthkarNotifEnabled(String key, bool enabled) async {
    if (enabled) {
      _athkarNotifEnabled.add(key);
    } else {
      _athkarNotifEnabled.remove(key);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'athkarNotifEnabled', jsonEncode(_athkarNotifEnabled.toList()));
  }

  Future<void> setReciter(String id) async {
    _reciterId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reciterId', id);
  }

  Future<void> setAdhanSound(String id) async {
    _adhanSoundId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanSoundId', id);
  }
}
