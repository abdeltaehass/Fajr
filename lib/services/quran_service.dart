import 'dart:convert';
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

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

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

    final content = SurahContent(info: info, ayahs: ayahs);
    _cache[cacheKey] = content;
    return content;
  }
}

class QuranServiceException implements Exception {
  final String message;
  QuranServiceException(this.message);

  @override
  String toString() => message;
}
