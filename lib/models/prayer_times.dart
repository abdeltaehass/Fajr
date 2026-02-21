import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class PrayerTimesResponse {
  final PrayerTimings timings;
  final PrayerDate date;

  PrayerTimesResponse({required this.timings, required this.date});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PrayerTimesResponse(
      timings: PrayerTimings.fromJson(data['timings']),
      date: PrayerDate.fromJson(data['date']),
    );
  }

  factory PrayerTimesResponse.fromCached(Map<String, dynamic> json) {
    return PrayerTimesResponse(
      timings: PrayerTimings.fromCached(json['timings'] as Map<String, dynamic>),
      date: PrayerDate.fromCached(json['date'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'timings': timings.toJson(),
        'date': date.toJson(),
      };
}

class PrayerTimings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: _cleanTime(json['Fajr']),
      sunrise: _cleanTime(json['Sunrise']),
      dhuhr: _cleanTime(json['Dhuhr']),
      asr: _cleanTime(json['Asr']),
      maghrib: _cleanTime(json['Maghrib']),
      isha: _cleanTime(json['Isha']),
    );
  }

  factory PrayerTimings.fromCached(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json['fajr'] as String,
      sunrise: json['sunrise'] as String,
      dhuhr: json['dhuhr'] as String,
      asr: json['asr'] as String,
      maghrib: json['maghrib'] as String,
      isha: json['isha'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  static String _cleanTime(String raw) {
    final parenIndex = raw.indexOf(' (');
    return parenIndex != -1 ? raw.substring(0, parenIndex) : raw.trim();
  }

  List<PrayerEntry> get dailyPrayers => [
        PrayerEntry(name: 'Fajr', time: fajr, icon: Icons.nights_stay),
        PrayerEntry(name: 'Sunrise', time: sunrise, icon: Icons.wb_sunny_outlined, isPrayer: false),
        PrayerEntry(name: 'Dhuhr', time: dhuhr, icon: Icons.wb_sunny),
        PrayerEntry(name: 'Asr', time: asr, icon: Icons.wb_cloudy),
        PrayerEntry(name: 'Maghrib', time: maghrib, icon: Icons.wb_twilight),
        PrayerEntry(name: 'Isha', time: isha, icon: Icons.dark_mode),
      ];
}

class PrayerEntry {
  final String name;
  final String time;
  final IconData icon;
  final bool isPrayer;

  PrayerEntry({
    required this.name,
    required this.time,
    required this.icon,
    this.isPrayer = true,
  });

  DateTime get todayDateTime {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  String localizedName(AppStrings s) {
    switch (name) {
      case 'Fajr': return s.prayerFajr;
      case 'Sunrise': return s.prayerSunrise;
      case 'Dhuhr': return s.prayerDhuhr;
      case 'Asr': return s.prayerAsr;
      case 'Maghrib': return s.prayerMaghrib;
      case 'Isha': return s.prayerIsha;
      default: return name;
    }
  }
}

class PrayerDate {
  final String gregorianReadable;
  final String gregorianWeekday;
  final String hijriDay;
  final String hijriMonthEn;
  final String hijriYear;

  PrayerDate({
    required this.gregorianReadable,
    required this.gregorianWeekday,
    required this.hijriDay,
    required this.hijriMonthEn,
    required this.hijriYear,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    final gregorian = json['gregorian'];
    final hijri = json['hijri'];
    return PrayerDate(
      gregorianReadable: gregorian['date'] as String,
      gregorianWeekday: gregorian['weekday']['en'] as String,
      hijriDay: hijri['day'] as String,
      hijriMonthEn: hijri['month']['en'] as String,
      hijriYear: hijri['year'] as String,
    );
  }

  factory PrayerDate.fromCached(Map<String, dynamic> json) {
    // Always use today's actual Gregorian date — the device clock is accurate.
    // Hijri date comes from the cache (may be ±1 day off when stale).
    final now = DateTime.now();
    final weekdays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final todayWeekday = weekdays[now.weekday - 1];
    final todayReadable =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    return PrayerDate(
      gregorianReadable: todayReadable,
      gregorianWeekday: todayWeekday,
      hijriDay: json['hijriDay'] as String,
      hijriMonthEn: json['hijriMonthEn'] as String,
      hijriYear: json['hijriYear'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'gregorianReadable': gregorianReadable,
        'gregorianWeekday': gregorianWeekday,
        'hijriDay': hijriDay,
        'hijriMonthEn': hijriMonthEn,
        'hijriYear': hijriYear,
      };

  String get hijriFormatted => '$hijriDay $hijriMonthEn $hijriYear AH';

  String get gregorianFormatted {
    final parts = gregorianReadable.split('-');
    if (parts.length == 3) {
      final months = [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = parts[2];
      return '$gregorianWeekday, $day ${months[month]} $year';
    }
    return '$gregorianWeekday, $gregorianReadable';
  }
}
