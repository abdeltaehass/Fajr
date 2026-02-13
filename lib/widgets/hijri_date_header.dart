import 'package:flutter/material.dart';
import '../models/prayer_times.dart';

class HijriDateHeader extends StatelessWidget {
  final PrayerDate date;

  const HijriDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          date.hijriFormatted,
          style: theme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          date.gregorianFormatted,
          style: theme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
