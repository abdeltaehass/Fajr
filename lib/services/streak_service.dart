import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/streak.dart';

class StreakService {
  static const _key = 'streaks_v1';

  static Future<List<Streak>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    final streaks = list.map((e) => Streak.fromJson(e as Map<String, dynamic>)).toList();
    var dirty = false;
    for (final s in streaks) {
      if (s.recalculateOnOpen()) dirty = true;
    }
    if (dirty) await _save(prefs, streaks);
    return streaks;
  }

  static Future<void> save(List<Streak> streaks) async {
    final prefs = await SharedPreferences.getInstance();
    await _save(prefs, streaks);
  }

  static Future<void> _save(SharedPreferences prefs, List<Streak> streaks) async {
    await prefs.setString(_key, jsonEncode(streaks.map((s) => s.toJson()).toList()));
  }
}
