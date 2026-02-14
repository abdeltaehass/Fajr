import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/hadiths.dart';
import '../data/athkar.dart';
import 'athkar_screen.dart';

class HadithAthkarScreen extends StatelessWidget {
  const HadithAthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hadith = todaysHadith;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Header
            Text(
              'Hadith & Athkar',
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
                'DAILY ATHKAR',
                style: GoogleFonts.poppins(
                  color: IslamicColors.lightGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Morning Athkar
            _AthkarLaunchCard(
              title: 'Morning Athkar',
              subtitle: 'Athkar Al-Sabah',
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
              title: 'Evening Athkar',
              subtitle: 'Athkar Al-Masa',
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
              title: 'After Prayer Athkar',
              subtitle: 'Athkar Ba\'d As-Salah',
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
              title: 'Sleep Athkar',
              subtitle: 'Athkar An-Nawm',
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
    showModalBottomSheet(
      context: context,
      backgroundColor: IslamicColors.darkGreen,
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
                    color: IslamicColors.lightGold.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'HADITH OF THE DAY',
                style: GoogleFonts.poppins(
                  color: IslamicColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"${hadith.text}"',
                style: GoogleFonts.amiri(
                  color: IslamicColors.cream,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hadith.narrator,
                style: GoogleFonts.poppins(
                  color: IslamicColors.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hadith.source,
                style: GoogleFonts.poppins(
                  color: IslamicColors.lightGold.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 1,
                color: IslamicColors.gold.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 20),
              Text(
                'EXPLANATION',
                style: GoogleFonts.poppins(
                  color: IslamicColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hadith.explanation,
                style: GoogleFonts.poppins(
                  color: IslamicColors.cream,
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
    return GestureDetector(
      onTap: () => _showExplanation(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: IslamicColors.darkGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: IslamicColors.gold.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.auto_stories, color: IslamicColors.gold, size: 18),
                const SizedBox(width: 8),
                Text(
                  'HADITH OF THE DAY',
                  style: GoogleFonts.poppins(
                    color: IslamicColors.gold,
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
                color: IslamicColors.cream,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),

            // Narrator
            Text(
              hadith.narrator,
              style: GoogleFonts.poppins(
                color: IslamicColors.gold,
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
                color: IslamicColors.lightGold.withValues(alpha: 0.7),
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
                  color: IslamicColors.lightGold.withValues(alpha: 0.5),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Tap for explanation',
                  style: GoogleFonts.poppins(
                    color: IslamicColors.lightGold.withValues(alpha: 0.5),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: IslamicColors.darkGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: IslamicColors.gold.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: IslamicColors.forestGreen.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: IslamicColors.gold, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: IslamicColors.lightGold.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: IslamicColors.lightGold,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
