import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';
import '../data/hadiths.dart';
import '../data/athkar.dart';
import 'athkar_screen.dart';

class HadithAthkarScreen extends StatelessWidget {
  const HadithAthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hadith = todaysHadith;
    final s = context.strings;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Header
            Text(
              s.hadithAthkar,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),

            // Hadith of the Day
            _HadithCard(hadith: hadith),
            const SizedBox(height: 24),

            // Section label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                s.dailyAthkar,
                style: GoogleFonts.poppins(
                  color: context.colors.accentLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Morning Athkar
            _AthkarLaunchCard(
              title: s.morningAthkar,
              subtitle: s.athkarAlSabah,
              icon: Icons.wb_sunny_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AthkarScreen(
                    title: 'Morning Athkar',
                    athkar: morningAthkar,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Evening Athkar
            _AthkarLaunchCard(
              title: s.eveningAthkar,
              subtitle: s.athkarAlMasa,
              icon: Icons.nights_stay_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AthkarScreen(
                    title: 'Evening Athkar',
                    athkar: eveningAthkar,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // After Prayer Athkar
            _AthkarLaunchCard(
              title: s.afterPrayerAthkar,
              subtitle: s.athkarBadSalah,
              icon: Icons.mosque_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AthkarScreen(
                    title: 'After Prayer Athkar',
                    athkar: afterPrayerAthkar,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sleep Athkar
            _AthkarLaunchCard(
              title: s.sleepAthkar,
              subtitle: s.athkarAnNawm,
              icon: Icons.bedtime_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AthkarScreen(
                    title: 'Sleep Athkar',
                    athkar: sleepAthkar,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _HadithCard extends StatelessWidget {
  final Hadith hadith;

  const _HadithCard({required this.hadith});

  void _showExplanation(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            controller: controller,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.accentLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                s.hadithOfTheDay,
                style: GoogleFonts.poppins(
                  color: c.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"${hadith.text}"',
                style: GoogleFonts.amiri(
                  color: c.bodyText,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hadith.narrator,
                style: GoogleFonts.poppins(
                  color: c.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hadith.source,
                style: GoogleFonts.poppins(
                  color: c.accentLight.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 1,
                color: c.accent.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 20),
              Text(
                s.explanation.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: c.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hadith.explanation,
                style: GoogleFonts.poppins(
                  color: c.bodyText,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    return GestureDetector(
      onTap: () => _showExplanation(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: c.accent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.auto_stories, color: c.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  s.hadithOfTheDay,
                  style: GoogleFonts.poppins(
                    color: c.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hadith text
            Text(
              '"${hadith.text}"',
              style: GoogleFonts.amiri(
                color: c.bodyText,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),

            // Narrator
            Text(
              hadith.narrator,
              style: GoogleFonts.poppins(
                color: c.accent,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),

            // Source
            Text(
              hadith.source,
              style: GoogleFonts.poppins(
                color: c.accentLight.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 10),

            // Tap hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  color: c.accentLight.withValues(alpha: 0.5),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  s.tapForExplanation,
                  style: GoogleFonts.poppins(
                    color: c.accentLight.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AthkarLaunchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _AthkarLaunchCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: c.accent.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.surface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.accent, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: highEmphasis,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: c.accentLight.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: c.accentLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
