import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keychain-backed storage for the cached coordinates and city label.
/// Location is the only personal data the app persists, so it lives in the
/// iOS Keychain (encrypted at rest) instead of plain-text UserDefaults.
class LocationCache {
  // first_unlock: readable after the first unlock following a reboot, so
  // early launches (e.g. from a notification tap) still get cached coords.
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _latKey = 'cachedLat';
  static const _lngKey = 'cachedLng';
  static const _nameKey = 'cachedLocationName';

  static bool _migrationChecked = false;

  /// Moves any pre-Keychain values out of SharedPreferences exactly once,
  /// deleting the plain-text copies. Cheap no-op on every later call.
  static Future<void> _ensureMigrated() async {
    if (_migrationChecked) return;
    _migrationChecked = true;
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    final name = prefs.getString(_nameKey);
    if (lat != null && lng != null) {
      await writeCoords(lat, lng);
    }
    if (name != null) {
      await writeName(name);
    }
    await Future.wait([
      prefs.remove(_latKey),
      prefs.remove(_lngKey),
      prefs.remove(_nameKey),
    ]);
  }

  static Future<(double, double)?> readCoords() async {
    await _ensureMigrated();
    try {
      final lat = double.tryParse(await _storage.read(key: _latKey) ?? '');
      final lng = double.tryParse(await _storage.read(key: _lngKey) ?? '');
      if (lat == null || lng == null) return null;
      return (lat, lng);
    } catch (_) {
      return null;
    }
  }

  static Future<void> writeCoords(double lat, double lng) async {
    try {
      await _storage.write(key: _latKey, value: lat.toString());
      await _storage.write(key: _lngKey, value: lng.toString());
    } catch (_) {
      // Keychain write failure is non-fatal — coords are re-fetched from GPS.
    }
  }

  static Future<String?> readName() async {
    await _ensureMigrated();
    try {
      return await _storage.read(key: _nameKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> writeName(String name) async {
    try {
      await _storage.write(key: _nameKey, value: name);
    } catch (_) {}
  }
}
