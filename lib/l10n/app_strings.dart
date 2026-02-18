import '../settings/app_settings.dart';
import 'strings/en.dart';
import 'strings/ar.dart';
import 'strings/fr.dart';
import 'strings/tr.dart';
import 'strings/ur.dart';
import 'strings/ms.dart';

abstract class AppStrings {
  // Navigation
  String get prayerTimes;
  String get hadithAthkar;
  String get settings;

  // Dashboard
  String get appTitle;
  String get nextPrayer;
  String get hours;
  String get minutes;
  String get seconds;
  String get findingLocation;
  String get retry;
  String get couldNotLoad;

  // Qibla
  String get qiblaDirection;
  String get fromNorth;
  String get highAccuracy;
  String get mediumAccuracy;
  String get lowAccuracy;
  String get noCompass;

  // Hadith & Athkar
  String get hadithOfTheDay;
  String get dailyAthkar;
  String get morningAthkar;
  String get athkarAlSabah;
  String get eveningAthkar;
  String get athkarAlMasa;
  String get afterPrayerAthkar;
  String get athkarBadSalah;
  String get sleepAthkar;
  String get athkarAnNawm;
  String get tapForExplanation;
  String get explanation;

  // Athkar screen
  String get tapAnywhere;
  String get completed;
  String get acceptanceMessage;
  String get done;

  // Settings
  String get colorTheme;
  String get seasonalTheme;
  String get language;
  String get normal;
  String get ramadan;
  String get eid;
  String get hajj;
  String get laylatulQadr;

  // Masjid
  String get masjid;
  String get nearbyMasjids;
  String get searchingMasjids;
  String get noMasjidsFound;
  String get distance;
  String get openNow;
  String get closed;
  String get getDirections;
  String get call;
  String get websiteLabel;
  String get openingHours;
  String get km;
  String get noDetails;
  String get apiKeyMissing;
  String get myMasjid;
  String get setAsMyMasjid;
  String get removeMyMasjid;
  String get myMasjidSet;
  String get selectYourMasjid;
  String get masjidPrayerTimes;

  // Quran
  String get quran;
  String get searchSurahs;
  String get verses;
  String get meccan;
  String get medinan;
  String get loadingVerses;
  String get couldNotLoadSurah;
  String get showTranslation;
  String get hideTranslation;

  static AppStrings of(AppLanguage language) {
    switch (language) {
      case AppLanguage.arabic:
        return ArabicStrings();
      case AppLanguage.french:
        return FrenchStrings();
      case AppLanguage.turkish:
        return TurkishStrings();
      case AppLanguage.urdu:
        return UrduStrings();
      case AppLanguage.malay:
        return MalayStrings();
      case AppLanguage.english:
        return EnglishStrings();
    }
  }
}
