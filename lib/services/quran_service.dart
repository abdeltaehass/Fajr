import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../data/surah_list.dart';
import '../models/quran_models.dart';

class QuranService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  final Map<String, SurahContent> _cache = {};

  Future<SurahContent> getSurah(int number, {String edition = 'en.sahih'}) async {
    final cacheKey = '$number:$edition';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    final info = surahList[number - 1];

    final uri = Uri.parse(
      '$_baseUrl/surah/$number/editions/quran-uthmani,$edition',
    );

    // Retry transient failures (timeout, socket, 5xx) with exponential backoff.
    const delays = [Duration.zero, Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)];
    QuranServiceException? lastError;
    for (final delay in delays) {
      if (delay > Duration.zero) await Future.delayed(delay);
      try {
        final content = await _fetchOnce(uri, info);
        _cache[cacheKey] = content;
        return content;
      } on QuranServiceException catch (e) {
        lastError = e;
        if (!_isTransient(e.message)) rethrow;
      }
    }
    throw lastError!;
  }

  bool _isTransient(String message) =>
      message.contains('timeout') ||
      message.contains('network') ||
      message.contains('500') ||
      message.contains('502') ||
      message.contains('503') ||
      message.contains('504');

  Future<SurahContent> _fetchOnce(Uri uri, SurahInfo info) async {
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw QuranServiceException('Request timeout');
    } on SocketException {
      throw QuranServiceException('Network unavailable');
    }

    if (response.statusCode != 200) {
      throw QuranServiceException('API returned status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) {
      throw QuranServiceException('Quran API error: ${json['status']}');
    }

    final data = json['data'] as List<dynamic>;
    final arabicAyahs = data[0]['ayahs'] as List<dynamic>;
    final translationAyahs = data[1]['ayahs'] as List<dynamic>;

    final ayahs = List<Ayah>.generate(arabicAyahs.length, (i) {
      return Ayah(
        number: arabicAyahs[i]['numberInSurah'] as int,
        globalNumber: arabicAyahs[i]['number'] as int,
        arabic: arabicAyahs[i]['text'] as String,
        translation: translationAyahs[i]['text'] as String,
      );
    });

    return SurahContent(info: info, ayahs: ayahs);
  }
}

class QuranServiceException implements Exception {
  final String message;
  QuranServiceException(this.message);

  @override
  String toString() => message;
}
