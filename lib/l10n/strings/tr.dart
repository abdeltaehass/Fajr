import '../app_strings.dart';

class TurkishStrings extends AppStrings {
  @override String get prayerTimes => 'Namaz Vakitleri';
  @override String get hadithAthkar => 'Hadis ve Zikirler';
  @override String get settings => 'Ayarlar';

  @override String get appTitle => 'Fajr';
  @override String get nextPrayer => 'Sonraki Namaz';
  @override String get hours => 'SAAT';
  @override String get minutes => 'DAK';
  @override String get seconds => 'SAN';
  @override String get findingLocation => 'Konumunuz bulunuyor...';
  @override String get retry => 'Tekrar Dene';
  @override String get couldNotLoad => 'Namaz vakitleri yüklenemedi';

  @override String get qiblaDirection => 'KIBLE YÖNÜ';
  @override String get fromNorth => 'Kuzeyden';
  @override String get highAccuracy => 'Yüksek doğruluk';
  @override String get mediumAccuracy => 'Orta doğruluk';
  @override String get lowAccuracy => 'Düşük doğruluk — telefonunuzu 8 şeklinde hareket ettirin';
  @override String get noCompass => 'Pusula sensörü algılanmadı';

  @override String get hadithOfTheDay => 'GÜNÜN HADİSİ';
  @override String get dailyAthkar => 'GÜNLÜK ZİKİRLER';
  @override String get morningAthkar => 'Sabah Zikirleri';
  @override String get athkarAlSabah => 'Ezkâr-ı Sabah';
  @override String get eveningAthkar => 'Akşam Zikirleri';
  @override String get athkarAlMasa => 'Ezkâr-ı Mesâ';
  @override String get afterPrayerAthkar => 'Namaz Sonrası Zikirler';
  @override String get athkarBadSalah => 'Namazdan Sonra';
  @override String get sleepAthkar => 'Uyku Zikirleri';
  @override String get athkarAnNawm => 'Uyku Duaları';
  @override String get tapForExplanation => 'Açıklama için dokunun';
  @override String get explanation => 'Açıklama';

  @override String get tapAnywhere => 'Saymak için herhangi bir yere dokunun';
  @override String get completed => 'Tamamlandı';
  @override String get acceptanceMessage => 'Allah zikirlerinizi kabul etsin';
  @override String get done => 'Bitti';

  @override String get colorTheme => 'Renk Teması';
  @override String get seasonalTheme => 'Mevsimsel Tema';
  @override String get language => 'Dil';
  @override String get normal => 'Normal';
  @override String get ramadan => 'Ramazan';
  @override String get eid => 'Bayram';
  @override String get hajj => 'Hac';
  @override String get laylatulQadr => 'Kadir Gecesi';

  @override String get masjid => 'Cami';
  @override String get nearbyMasjids => 'Yakındaki Camiler';
  @override String get searchingMasjids => 'Yakındaki camiler aranıyor...';
  @override String get noMasjidsFound => 'Yakında cami bulunamadı';
  @override String get distance => 'Mesafe';
  @override String get openNow => 'Açık';
  @override String get closed => 'Kapalı';
  @override String get getDirections => 'Yol Tarifi';
  @override String get call => 'Ara';
  @override String get websiteLabel => 'Web Sitesi';
  @override String get openingHours => 'Çalışma Saatleri';
  @override String get km => 'mi';
  @override String get noDetails => 'Ek bilgi mevcut değil';
  @override String get apiKeyMissing => 'Lütfen api_keys.dart dosyasına Google Places API anahtarınızı ekleyin';

  @override String get myMasjid => 'Camim';
  @override String get setAsMyMasjid => 'Camim olarak ayarla';
  @override String get removeMyMasjid => 'Camimi kaldır';
  @override String get myMasjidSet => 'Caminiz olarak ayarlandı';
  @override String get selectYourMasjid => 'Seçmek için aşağıdaki bir camiye dokunun';
  @override String get masjidPrayerTimes => 'Namaz Vakitleri';
}
