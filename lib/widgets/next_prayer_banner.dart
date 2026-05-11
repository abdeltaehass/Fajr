import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../settings/settings_provider.dart';
import 'islamic_ornament.dart';

class NextPrayerBanner extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final DateTime targetTime;

  const NextPrayerBanner({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.targetTime,
  });

  String _formattedTime(String locale) {
    final parts = prayerTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat.jm(locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = context.settings.locale.toLanguageTag();

    // Outer container = thicker outer hairline; inner Container = body of the
    // banner. This produces the "double gold line" inscription-band feel
    // without needing custom paint.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            c.accent.withValues(alpha: 0.55),
            c.accent.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: c.accent.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c.surface, c.card],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: c.accent.withValues(alpha: 0.35),
            width: 0.6,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Faint geometric watermark
            Positioned.fill(
              child: IslamicWatermark(
                color: c.accent,
                opacity: 0.06,
                size: 200,
              ),
            ),
            // Subtle top-light shimmer
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 56,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x14FFFFFF), Color(0x00FFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                children: [
                  IslamicDivider(label: context.strings.nextPrayer),
                  const SizedBox(height: 14),
                  Text(
                    prayerName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formattedTime(locale),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: c.accent,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _LiveCountdown(
                    key: ValueKey(targetTime.millisecondsSinceEpoch),
                    targetTime: targetTime,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.strings.remaining,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Self-contained 1s ticker. Only this subtree rebuilds each second —
// the rest of the dashboard stays static between prayer transitions.
class _LiveCountdown extends StatefulWidget {
  final DateTime targetTime;
  const _LiveCountdown({super.key, required this.targetTime});

  @override
  State<_LiveCountdown> createState() => _LiveCountdownState();
}

class _LiveCountdownState extends State<_LiveCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _compute();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = _compute());
    });
  }

  Duration _compute() {
    final diff = widget.targetTime.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CountdownBox(
          value: hours.toString().padLeft(2, '0'),
          label: context.strings.hours.toLowerCase(),
        ),
        const _CountdownSeparator(),
        _CountdownBox(
          value: minutes.toString().padLeft(2, '0'),
          label: context.strings.minutes.toLowerCase(),
        ),
        const _CountdownSeparator(),
        _CountdownBox(
          value: seconds.toString().padLeft(2, '0'),
          label: context.strings.seconds.toLowerCase(),
        ),
      ],
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String value;
  final String label;

  const _CountdownBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;

    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: c.scaffold.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: c.accent.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: highEmphasis,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: c.accentLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownSeparator extends StatelessWidget {
  const _CountdownSeparator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: context.colors.accent,
        ),
      ),
    );
  }
}
