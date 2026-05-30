import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
        if (!e.transient) rethrow;
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
    // Same retry pattern as fetchPrayerTimes so a transient blip doesn't
    // silently kill the widget pre-fetch.
    const delays = [Duration.zero, Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)];
    PrayerTimeServiceException? lastError;
    for (final delay in delays) {
      if (delay > Duration.zero) await Future.delayed(delay);
      try {
        return await _fetchMonthOnce(uri);
      } on PrayerTimeServiceException catch (e) {
        lastError = e;
        if (!e.transient) rethrow;
      }
    }
    throw lastError!;
  }

  Future<List<PrayerTimesResponse>> _fetchMonthOnce(Uri uri) async {
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 25));
    } on TimeoutException {
      throw PrayerTimeServiceException.network();
    } on SocketException {
      throw PrayerTimeServiceException.network();
    }
    if (response.statusCode != 200) {
      debugPrint('PrayerTimeService fetchMonth ${response.statusCode}: ${response.body}');
      throw PrayerTimeServiceException.fromStatus(response.statusCode);
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200 || json['status'] != 'OK') {
      debugPrint('PrayerTimeService fetchMonth API status: ${json['status']}');
      throw PrayerTimeServiceException.apiError();
    }
    final data = json['data'] as List<dynamic>;
    return data
        .map((day) => PrayerTimesResponse.fromJson({'data': day}))
        .toList();
  }

  Future<PrayerTimesResponse> _fetchOnce(Uri uri) async {
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw PrayerTimeServiceException.network();
    } on SocketException {
      throw PrayerTimeServiceException.network();
    }

    if (response.statusCode != 200) {
      debugPrint('PrayerTimeService fetch ${response.statusCode}: ${response.body}');
      throw PrayerTimeServiceException.fromStatus(response.statusCode);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['code'] != 200 || json['status'] != 'OK') {
      debugPrint('PrayerTimeService fetch API status: ${json['status']}');
      throw PrayerTimeServiceException.apiError();
    }

    return PrayerTimesResponse.fromJson(json);
  }
}

class PrayerTimeServiceException implements Exception {
  final String message;
  /// True when retrying might help (timeout, socket error, 5xx). Drives the
  /// service's internal retry loop and the dashboard's "service unavailable"
  /// UI vs. generic error UI.
  final bool transient;

  PrayerTimeServiceException(this.message, {this.transient = false});

  /// Connectivity or timeout — almost always recovers on retry.
  factory PrayerTimeServiceException.network() =>
      PrayerTimeServiceException(
        "Couldn't reach the prayer times service. Please check your connection.",
        transient: true,
      );

  /// HTTP error from the upstream API. 5xx is treated as transient.
  factory PrayerTimeServiceException.fromStatus(int code) =>
      PrayerTimeServiceException(
        code >= 500
            ? 'Prayer times service is temporarily unavailable.'
            : "Couldn't load prayer times. Please try again later.",
        transient: code >= 500,
      );

  /// The API returned a 200 but the response payload signals an error.
  factory PrayerTimeServiceException.apiError() => PrayerTimeServiceException(
        "Couldn't load prayer times. Please try again later.",
      );

  @override
  String toString() => message;
}
