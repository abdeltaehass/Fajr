import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../theme/app_theme.dart';

class PrayerCard extends StatelessWidget {
  final PrayerEntry prayer;
  final bool isNext;

  const PrayerCard({
    super.key,
    required this.prayer,
    required this.isNext,
  });

  String get _formattedTime {
    final parts = prayer.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNext
            ? IslamicColors.darkGreen.withValues(alpha: 0.9)
            : IslamicColors.darkGreen,
        borderRadius: BorderRadius.circular(16),
        border: isNext
            ? const Border(
                left: BorderSide(color: IslamicColors.gold, width: 4),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            prayer.icon,
            color: isNext ? IslamicColors.gold : IslamicColors.lightGold,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isNext ? Colors.white : IslamicColors.cream,
                      ),
                ),
                if (isNext)
                  Text(
                    'Up next',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: IslamicColors.gold,
                        ),
                  ),
              ],
            ),
          ),
          Text(
            _formattedTime,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: isNext ? IslamicColors.gold : Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
