import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimeService {
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimesResponse> fetchPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 2,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final uri = Uri.parse(
      '$_baseUrl/timings/$timestamp'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&method=$method',
    );

    // Retry with exponential backoff: 0s, 1s, 2s, 4s — only on transient errors
    // (timeout, socket, 5xx). 4xx and parse errors fail fast.
    const delays = [Duration.zero, Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)];
    PrayerTimeServiceException? lastError;
    for (final delay in delays) {
      if (delay > Duration.zero) await Future.delayed(delay);
      try {
        return await _fetchOnce(uri);
      } on PrayerTimeServiceException catch (e) {
        lastError = e;
        if (!_isTransient(e.message)) rethrow;
      }
    }
    throw lastError!;
  }

  /// Fetch a whole month of prayer times in one call. Used to pre-populate
  /// the widget timeline so the home-screen widget stays accurate even when
  /// iOS doesn't run the app in the background for several days.
  Future<List<PrayerTimesResponse>> fetchMonth({
    required double latitude,
    required double longitude,
    int method = 2,
    required int year,
    required int month,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/calendar/$year/$month'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&method=$method',
    );
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 25));
    } on TimeoutException {
      throw PrayerTimeServiceException('503');
    } on SocketException {
      throw PrayerTimeServiceException('503');
    }
    if (response.statusCode != 200) {
      throw PrayerTimeServiceException('API returned status ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200 || json['status'] != 'OK') {
      throw PrayerTimeServiceException('API error: ${json['status']}');
    }
    final data = json['data'] as List<dynamic>;
    return data
        .map((day) => PrayerTimesResponse.fromJson({'data': day}))
        .toList();
  }

  bool _isTransient(String message) =>
      message == '503' ||
      message.contains('502') ||
      message.contains('504') ||
      message.contains('500');

  Future<PrayerTimesResponse> _fetchOnce(Uri uri) async {
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw PrayerTimeServiceException('503');
    } on SocketException {
      throw PrayerTimeServiceException('503');
    }

    if (response.statusCode != 200) {
      throw PrayerTimeServiceException(
        'API returned status ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['code'] != 200 || json['status'] != 'OK') {
      throw PrayerTimeServiceException('API error: ${json['status']}');
    }

    return PrayerTimesResponse.fromJson(json);
  }
}

class PrayerTimeServiceException implements Exception {
  final String message;
  PrayerTimeServiceException(this.message);

  @override
  String toString() => message;
}
