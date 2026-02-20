import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/masjid.dart';

class MasjidService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<Masjid>> searchNearbyMasjids({
    required double latitude,
    required double longitude,
    int radiusMeters = 10000,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/nearbysearch/json'
      '?location=$latitude,$longitude'
      '&radius=$radiusMeters'
      '&type=mosque'
      '&key=${ApiKeys.googlePlaces}',
    );

    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw MasjidServiceException('Request timed out. Check your connection.');
    } on SocketException {
      throw MasjidServiceException('No internet connection.');
    }

    if (response.statusCode != 200) {
      throw MasjidServiceException(
        'API returned status ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final status = json['status'] as String;

    if (status == 'ZERO_RESULTS') {
      return [];
    }

    if (status != 'OK') {
      throw MasjidServiceException('Places API error: $status');
    }

    final results = json['results'] as List<dynamic>;
    final masjids = results
        .map((r) => Masjid.fromNearbySearch(r as Map<String, dynamic>))
        .map((m) => m.copyWithDistance(
              _calculateDistance(latitude, longitude, m.latitude, m.longitude),
            ))
        .toList();

    masjids.sort((a, b) =>
        (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    return masjids;
  }

  Future<Masjid> getMasjidDetails(Masjid masjid) async {
    final uri = Uri.parse(
      '$_baseUrl/details/json'
      '?place_id=${masjid.placeId}'
      '&fields=formatted_phone_number,website,opening_hours,photos'
      '&key=${ApiKeys.googlePlaces}',
    );

    final http.Response detailResponse;
    try {
      detailResponse = await http.get(uri).timeout(const Duration(seconds: 15));
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

    final json = jsonDecode(detailResponse.body) as Map<String, dynamic>;
    final status = json['status'] as String;

    if (status != 'OK') {
      throw MasjidServiceException('Places API error: $status');
    }

    final result = (json['result'] ?? {}) as Map<String, dynamic>;
    final photos = result['photos'] as List<dynamic>? ?? [];
    final hours = result['opening_hours']?['weekday_text'] as List<dynamic>? ?? [];

    return masjid.copyWithDetails(
      phoneNumber: result['formatted_phone_number'] as String?,
      website: result['website'] as String?,
      openingHours: hours.map((h) => h as String).toList(),
      photoReferences: photos.isNotEmpty
          ? photos.map((p) => p['photo_reference'] as String).toList()
          : const [],
    );
  }

  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_baseUrl/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=${ApiKeys.googlePlaces}';
  }

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
