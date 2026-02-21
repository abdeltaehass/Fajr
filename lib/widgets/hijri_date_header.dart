import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../settings/settings_provider.dart';

class HijriDateHeader extends StatelessWidget {
  final PrayerDate date;

  const HijriDateHeader({super.key, required this.date});

  String _gregorianLocalized(Locale locale) {
    try {
      final parts = date.gregorianReadable.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dt = DateTime(year, month, day);
      return DateFormat('EEEE, d MMMM yyyy', locale.toLanguageTag()).format(dt);
    } catch (_) {
      return date.gregorianFormatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final locale = context.settings.locale;

    return Column(
      children: [
        Text(
          date.hijriFormatted,
          style: theme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _gregorianLocalized(locale),
          style: theme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
