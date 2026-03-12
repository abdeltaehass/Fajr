class HijriDate {
  final int year;
  final int month;
  final int day;
  const HijriDate(this.year, this.month, this.day);
}

int _toJdn(int y, int m, int d) {
  final a = (14 - m) ~/ 12;
  final yy = y + 4800 - a;
  final mm = m + 12 * a - 3;
  return d +
      (153 * mm + 2) ~/ 5 +
      365 * yy +
      yy ~/ 4 -
      yy ~/ 100 +
      yy ~/ 400 -
      32045;
}

HijriDate jdnToHijri(int jd) {
  int l = jd - 1948440 + 10632;
  final n = (l - 1) ~/ 10631;
  l = l - 10631 * n + 354;
  final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
      (l ~/ 5670) * ((43 * l) ~/ 15238);
  l = l -
      ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
      (j ~/ 16) * ((15238 * j) ~/ 43) +
      29;
  final month = (24 * l) ~/ 709;
  final day = l - (709 * month) ~/ 24;
  final year = 30 * n + j - 30;
  return HijriDate(year, month, day);
}

HijriDate gregorianToHijri(DateTime date) =>
    jdnToHijri(_toJdn(date.year, date.month, date.day));

const List<String> hijriMonthNames = [
  'Muharram',
  'Safar',
  "Rabi' al-Awwal",
  "Rabi' al-Thani",
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhul Qa'da",
  'Dhul Hijja',
];
