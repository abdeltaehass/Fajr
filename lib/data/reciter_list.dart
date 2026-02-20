import '../models/quran_reciter.dart';

const List<QuranReciter> reciters = [
  QuranReciter(
    id: 'ar.alafasy',
    name: 'Mishary Rashid Al-Afasy',
    arabicName: 'مشاري راشد العفاسي',
  ),
  QuranReciter(
    id: 'ar.abdurrahmaansudais',
    name: 'Abdul Rahman Al-Sudais',
    arabicName: 'عبد الرحمن السديس',
  ),
  QuranReciter(
    id: 'ar.husary',
    name: 'Mahmoud Khalil Al-Husary',
    arabicName: 'محمود خليل الحصري',
  ),
  QuranReciter(
    id: 'ar.minshawi',
    name: 'Mohamed Siddiq El-Minshawi',
    arabicName: 'محمد صديق المنشاوي',
  ),
  QuranReciter(
    id: 'ar.shaatree',
    name: 'Abu Bakr Al-Shatri',
    arabicName: 'أبو بكر الشاطري',
  ),
  QuranReciter(
    id: 'ar.mahermuaiqly',
    name: 'Maher Al-Muaiqly',
    arabicName: 'ماهر المعيقلي',
  ),
  QuranReciter(
    id: 'ar.muhammadjibreel',
    name: 'Muhammad Jibreel',
    arabicName: 'محمد جبريل',
  ),
];

QuranReciter reciterById(String id) =>
    reciters.firstWhere((r) => r.id == id, orElse: () => reciters.first);
