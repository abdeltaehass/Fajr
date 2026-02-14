import 'package:flutter/material.dart';

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
