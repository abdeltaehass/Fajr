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
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onTabSwitch: (i) => setState(() => _currentIndex = i)),
      const QuranScreen(),
      const HadithAthkarScreen(),
      const MasjidScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;

    const icons = [
      Icons.access_time_outlined,
      Icons.auto_stories_outlined,
      Icons.menu_book_outlined,
      Icons.mosque_outlined,
      Icons.settings_outlined,
    ];
    const activeIcons = [
      Icons.access_time,
      Icons.auto_stories,
      Icons.menu_book,
      Icons.mosque,
      Icons.settings,
    ];
    final labels = [s.prayerTimes, s.quran, s.hadithAthkar, s.masjid, s.settings];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.card,
          border: Border(
            top: BorderSide(color: c.accent.withValues(alpha: 0.18), width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 58,
            child: Row(
              children: List.generate(5, (i) {
                final selected = i == _currentIndex;
                return Expanded(
                  child: _NavItem(
                    icon: icons[i],
                    activeIcon: activeIcons[i],
                    label: labels[i],
                    selected: selected,
                    onTap: () => setState(() => _currentIndex = i),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: selected ? 28 : 0,
            height: 2.5,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: c.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Icon(
            selected ? activeIcon : icon,
            color: selected ? c.accent : c.accentLight.withValues(alpha: 0.38),
            size: 21,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? c.accent : c.accentLight.withValues(alpha: 0.38),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
