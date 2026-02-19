class SurahInfo {
  final int number;
  final String name;
  final String arabicName;
  final String meaning;
  final int totalVerses;
  final bool isMeccan;

  const SurahInfo({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.totalVerses,
    required this.isMeccan,
  });
}

class Ayah {
  final int number;
  final int globalNumber;
  final String arabic;
  final String translation;

  const Ayah({
    required this.number,
    required this.globalNumber,
    required this.arabic,
    required this.translation,
  });
}

class SurahContent {
  final SurahInfo info;
  final List<Ayah> ayahs;

  const SurahContent({required this.info, required this.ayahs});
}
