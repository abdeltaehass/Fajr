import 'dart:convert';
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

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

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
