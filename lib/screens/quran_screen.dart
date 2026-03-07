import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/surah_list.dart';
import '../models/quran_models.dart';
import '../services/quran_service.dart';
import '../settings/settings_provider.dart';
import 'bookmarks_screen.dart';
import 'surah_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final QuranService _quranService = QuranService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showFavourites = false;

  List<SurahInfo> get _filtered {
    final base = _showFavourites
        ? surahList.where((s) => context.settings.isSurahFavourited(s.number)).toList()
        : surahList;
    if (_query.isEmpty) return base;
    final q = _query.toLowerCase();
    return base.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.arabicName.contains(_query) ||
          s.meaning.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;
    final settings = context.settings;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.quran,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookmarksScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: c.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.accent.withValues(alpha: 0.15)),
                        ),
                        child: Icon(Icons.bookmark_rounded, color: c.accent, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tab toggle
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.accent.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      _Tab(
                        label: 'All Surahs',
                        selected: !_showFavourites,
                        c: c,
                        onTap: () => setState(() => _showFavourites = false),
                      ),
                      _Tab(
                        label: 'Favourites',
                        selected: _showFavourites,
                        c: c,
                        onTap: () => setState(() => _showFavourites = true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.accent.withValues(alpha: 0.2)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.poppins(fontSize: 14, color: textColor),
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: s.searchSurahs,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.4),
                      ),
                      prefixIcon: Icon(Icons.search, color: c.accentLight, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              child: Icon(Icons.close, color: c.accentLight, size: 18),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Surah list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_border,
                            size: 48, color: c.accent.withValues(alpha: 0.35)),
                        const SizedBox(height: 10),
                        Text(
                          _showFavourites ? 'No favourite surahs yet' : 'No results',
                          style: GoogleFonts.poppins(
                              color: textColor.withValues(alpha: 0.45), fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final surah = _filtered[index];
                      return _SurahCard(
                        surah: surah,
                        isFavourited: settings.isSurahFavourited(surah.number),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahScreen(
                              surahInfo: surah,
                              quranService: _quranService,
                            ),
                          ),
                        ),
                        onBookmark: () => context.settings.toggleFavouriteSurah(surah.number),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final dynamic c;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.c, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? c.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : c.accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final SurahInfo surah;
  final bool isFavourited;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  const _SurahCard({
    required this.surah,
    required this.isFavourited,
    required this.onTap,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.accent.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name and meaning
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    surah.meaning,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Badge(
                        label: '${surah.totalVerses} ${s.verses}',
                        color: c.accentLight,
                        bg: c.accent.withValues(alpha: 0.08),
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        label: surah.isMeccan ? s.meccan : s.medinan,
                        color: surah.isMeccan
                            ? const Color(0xFF7B9E5E)
                            : const Color(0xFF5E7B9E),
                        bg: surah.isMeccan
                            ? const Color(0xFF7B9E5E).withValues(alpha: 0.12)
                            : const Color(0xFF5E7B9E).withValues(alpha: 0.12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arabic name + bookmark
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surah.arabicName,
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    color: c.accent,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onBookmark,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      isFavourited ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isFavourited ? c.accent : textColor.withValues(alpha: 0.25),
                      size: 20,
                    ),
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _Badge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
