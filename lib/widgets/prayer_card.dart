import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../settings/settings_provider.dart';

class PrayerCard extends StatelessWidget {
  final PrayerEntry prayer;
  final bool isNext;

  const PrayerCard({
    super.key,
    required this.prayer,
    required this.isNext,
  });

  String _formattedTime(String locale) {
    final parts = prayer.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat.jm(locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;
    final locale = context.settings.locale.toLanguageTag();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNext ? c.card.withValues(alpha: 0.9) : c.card,
        borderRadius: BorderRadius.circular(16),
        border: isNext
            ? Border(left: BorderSide(color: c.accent, width: 4))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            prayer.icon,
            color: isNext ? c.accent : c.accentLight,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.localizedName(context.strings),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isNext ? highEmphasis : c.bodyText,
                      ),
                ),
                if (isNext)
                  Text(
                    context.strings.upNext,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: c.accent,
                        ),
                  ),
              ],
            ),
          ),
          Text(
            _formattedTime(locale),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: isNext ? c.accent : highEmphasis,
                ),
          ),
        ],
      ),
    );
  }
}
