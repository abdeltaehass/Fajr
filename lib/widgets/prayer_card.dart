import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isPast = prayer.todayDateTime.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: isNext
            ? LinearGradient(
                colors: [c.accent.withValues(alpha: 0.16), c.card],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isNext ? null : c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext
              ? c.accent.withValues(alpha: 0.35)
              : c.accent.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isNext
                  ? c.accent.withValues(alpha: 0.18)
                  : c.scaffold.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              prayer.icon,
              color: isNext
                  ? c.accent
                  : isPast
                      ? c.accentLight.withValues(alpha: 0.25)
                      : c.accentLight.withValues(alpha: 0.6),
              size: 19,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.localizedName(context.strings),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isNext
                            ? highEmphasis
                            : isPast
                                ? c.bodyText.withValues(alpha: 0.35)
                                : c.bodyText.withValues(alpha: 0.82),
                        fontWeight:
                            isNext ? FontWeight.w600 : FontWeight.w500,
                      ),
                ),
                if (isNext)
                  Text(
                    context.strings.upNext,
                    style: GoogleFonts.poppins(
                      color: c.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _formattedTime(locale),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
              color: isNext
                  ? c.accent
                  : isPast
                      ? highEmphasis.withValues(alpha: 0.28)
                      : highEmphasis.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}
