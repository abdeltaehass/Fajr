import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/surah_list.dart';
import '../models/quran_models.dart';
import '../services/quran_service.dart';
import '../settings/settings_provider.dart';
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

  List<SurahInfo> get _filtered {
    if (_query.isEmpty) return surahList;
    final q = _query.toLowerCase();
    return surahList.where((s) {
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

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Text(
                  s.quran,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 14),
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
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final surah = _filtered[index];
                return _SurahCard(
                  surah: surah,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahScreen(
                        surahInfo: surah,
                        quranService: _quranService,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final SurahInfo surah;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.onTap});

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

            // Arabic name
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
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right,
                  color: textColor.withValues(alpha: 0.25),
                  size: 18,
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
