import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_keys.dart';
import '../models/masjid.dart';

class MasjidService {
  static const String _baseUrl = 'https://places.googleapis.com/v1';
  static const Map<String, String> _baseHeaders = {
    'X-Goog-Api-Key': ApiKeys.googlePlaces,
    'X-Ios-Bundle-Identifier': 'com.fajr.fajr',
  };

  static const Duration _cacheTtl = Duration(days: 7);

  // Round to nearest 0.25° ≈ 28 km grid, matching the 30 km location threshold
  static String _nearbyKey(double lat, double lng) {
    final rLat = (lat * 4).round() / 4;
    final rLng = (lng * 4).round() / 4;
    return 'masjids_nearby_${rLat}_$rLng';
  }

  static String _detailKey(String placeId) => 'masjids_detail_$placeId';
  static String _timestampKey(String key) => '${key}_ts';

  Future<List<Masjid>> searchNearbyMasjids({
    required double latitude,
    required double longitude,
    int radiusMeters = 15000,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _nearbyKey(latitude, longitude);
    final cached = _loadListFromCache(prefs, cacheKey);
    if (cached != null) return cached;

    final uri = Uri.parse('$_baseUrl/places:searchNearby');
    final body = jsonEncode({
      'includedTypes': ['mosque'],
      'maxResultCount': 20,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radiusMeters.toDouble(),
        },
      },
    });

    final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {
              ..._baseHeaders,
              'Content-Type': 'application/json',
              'X-Goog-FieldMask':
                  'places.id,places.displayName,places.location,'
                  'places.rating,places.userRatingCount,'
                  'places.regularOpeningHours,places.photos',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw MasjidServiceException('Request timed out. Check your connection.');
    } on SocketException {
      throw MasjidServiceException('No internet connection.');
    }

    if (response.statusCode != 200) {
      throw MasjidServiceException(
        'API ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final places = json['places'] as List<dynamic>? ?? [];

    if (places.isEmpty) return [];

    final masjids = places
        .map((p) => Masjid.fromNearbySearch(p as Map<String, dynamic>))
        .map((m) => m.copyWithDistance(
              _calculateDistance(latitude, longitude, m.latitude, m.longitude),
            ))
        .toList();

    masjids.sort((a, b) =>
        (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    _saveListToCache(prefs, cacheKey, masjids);
    return masjids;
  }

  Future<Masjid> getMasjidDetails(Masjid masjid) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _detailKey(masjid.placeId);
    final cached = _loadMasjidFromCache(prefs, cacheKey);
    if (cached != null) return cached;

    final uri = Uri.parse('$_baseUrl/places/${masjid.placeId}');
    final http.Response detailResponse;
    try {
      detailResponse = await http.get(
        uri,
        headers: {
          ..._baseHeaders,
          'X-Goog-FieldMask':
              'nationalPhoneNumber,websiteUri,regularOpeningHours,photos',
        },
      ).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw MasjidServiceException('Request timed out. Check your connection.');
    } on SocketException {
      throw MasjidServiceException('No internet connection.');
    }

    if (detailResponse.statusCode != 200) {
      throw MasjidServiceException(
        'API returned status ${detailResponse.statusCode}',
      );
    }

    final result = jsonDecode(detailResponse.body) as Map<String, dynamic>;
    final photos = result['photos'] as List<dynamic>? ?? [];
    final hours =
        result['regularOpeningHours']?['weekdayDescriptions'] as List<dynamic>?
            ?? [];

    final detailed = masjid.copyWithDetails(
      phoneNumber: result['nationalPhoneNumber'] as String?,
      website: result['websiteUri'] as String?,
      openingHours: hours.map((h) => h as String).toList(),
      photoReferences: photos.isNotEmpty
          ? photos.map((p) => p['name'] as String).toList()
          : const [],
    );

    _saveMasjidToCache(prefs, cacheKey, detailed);
    return detailed;
  }

  String getPhotoUrl(String photoName, {int maxWidth = 400}) {
    return '$_baseUrl/$photoName/media'
        '?maxWidthPx=$maxWidth'
        '&key=${ApiKeys.googlePlaces}';
  }

  // ── Cache helpers ──────────────────────────────────────────────────────────

  bool _isFresh(SharedPreferences prefs, String key) {
    final ts = prefs.getInt(_timestampKey(key));
    if (ts == null) return false;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age < _cacheTtl.inMilliseconds;
  }

  List<Masjid>? _loadListFromCache(SharedPreferences prefs, String key) {
    if (!_isFresh(prefs, key)) return null;
    final raw = prefs.getString(key);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Masjid.fromJson(e as Map<String, dynamic>)).toList();
  }

  void _saveListToCache(
      SharedPreferences prefs, String key, List<Masjid> masjids) {
    prefs.setString(key, jsonEncode(masjids.map((m) => m.toJson()).toList()));
    prefs.setInt(_timestampKey(key), DateTime.now().millisecondsSinceEpoch);
  }

  Masjid? _loadMasjidFromCache(SharedPreferences prefs, String key) {
    if (!_isFresh(prefs, key)) return null;
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return Masjid.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void _saveMasjidToCache(
      SharedPreferences prefs, String key, Masjid masjid) {
    prefs.setString(key, jsonEncode(masjid.toJson()));
    prefs.setInt(_timestampKey(key), DateTime.now().millisecondsSinceEpoch);
  }

  // ── Distance ───────────────────────────────────────────────────────────────

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 3958.8;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}

class MasjidServiceException implements Exception {
  final String message;
  MasjidServiceException(this.message);

  @override
  String toString() => message;
}
