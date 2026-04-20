import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../settings/settings_provider.dart';

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

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.surface, c.card],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: c.accent.withValues(alpha: 0.45),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: c.accent.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          child: Column(
            children: [
              Text(
                context.strings.nextPrayer.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 6),
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
        // Subtle top-light shimmer — zero runtime cost
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 48,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x0FFFFFFF), Color(0x00FFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
        ),
      ],
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
