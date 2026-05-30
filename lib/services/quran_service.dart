import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/surah_list.dart';
import '../models/quran_models.dart';
import '../utils/request_deduper.dart';

class QuranService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _diskCacheKeyPrefix = 'quran_surah_v1_';

  final Map<String, SurahContent> _memCache = {};
  final RequestDeduper<SurahContent> _deduper = RequestDeduper();

  Future<SurahContent> getSurah(int number, {String edition = 'en.sahih'}) async {
    final cacheKey = '$number:$edition';
    // 1. In-memory cache hit — instant.
    final mem = _memCache[cacheKey];
    if (mem != null) return mem;

    // 2. Disk cache hit — much faster than network, instant on second open.
    final disk = await _loadFromDisk(cacheKey);
    if (disk != null) {
      _memCache[cacheKey] = disk;
      return disk;
    }

    // 3. Network — deduped so rapid taps don't fire duplicate requests.
    return _deduper.run(cacheKey, () => _fetchAndCache(number, edition, cacheKey));
  }

  Future<SurahContent> _fetchAndCache(
      int number, String edition, String cacheKey) async {
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
        _memCache[cacheKey] = content;
        // Persist in background; the user doesn't wait for it.
        unawaited(_saveToDisk(cacheKey, content));
        return content;
      } on QuranServiceException catch (e) {
        lastError = e;
        if (!_isTransient(e.message)) rethrow;
      }
    }
    throw lastError!;
  }

  Future<SurahContent?> _loadFromDisk(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_diskCacheKeyPrefix$cacheKey');
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final number = json['s'] as int;
      final ayahsList = json['v'] as List<dynamic>;
      return SurahContent(
        info: surahList[number - 1],
        ayahs: ayahsList
            .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      // Corrupt cache entry — ignore and let the network path overwrite.
      return null;
    }
  }

  Future<void> _saveToDisk(String cacheKey, SurahContent content) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode({
        's': content.info.number,
        'v': content.ayahs.map((a) => a.toJson()).toList(),
      });
      await prefs.setString('$_diskCacheKeyPrefix$cacheKey', payload);
    } catch (_) {
      // Disk write failure is non-fatal — memory cache still works.
    }
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
      throw QuranServiceException(
        "Couldn't reach the Quran service. Please check your connection.",
      );
    } on SocketException {
      throw QuranServiceException(
        "Couldn't reach the Quran service. Please check your connection.",
      );
    }

    if (response.statusCode != 200) {
      debugPrint('QuranService ${response.statusCode}: ${response.body}');
      throw QuranServiceException(
        "Couldn't load the Quran right now. Please try again later.",
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) {
      debugPrint('QuranService API status: ${json['status']}');
      throw QuranServiceException(
        "Couldn't load the Quran right now. Please try again later.",
      );
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
