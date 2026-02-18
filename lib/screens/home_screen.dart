import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';
import 'dashboard_screen.dart';
import 'hadith_athkar_screen.dart';
import 'quran_screen.dart';
import 'masjid_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    QuranScreen(),
    HadithAthkarScreen(),
    MasjidScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: c.card,
        selectedItemColor: c.accent,
        unselectedItemColor: c.accentLight.withValues(alpha: 0.45),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.access_time),
            label: s.prayerTimes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_stories_outlined),
            activeIcon: const Icon(Icons.auto_stories),
            label: s.quran,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: s.hadithAthkar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mosque_outlined),
            label: s.masjid,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: s.settings,
          ),
        ],
      ),
    );
  }
}
