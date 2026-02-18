import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quran_models.dart';
import '../services/quran_service.dart';
import '../settings/settings_provider.dart';

class SurahScreen extends StatefulWidget {
  final SurahInfo surahInfo;
  final QuranService quranService;

  const SurahScreen({
    super.key,
    required this.surahInfo,
    required this.quranService,
  });

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  bool _isLoading = true;
  String? _error;
  SurahContent? _content;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final content = await widget.quranService.getSurah(widget.surahInfo.number);
      if (!mounted) return;
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  bool get _showBismillah =>
      widget.surahInfo.number != 1 && widget.surahInfo.number != 9;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.card,
        foregroundColor: textColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surahInfo.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              '${widget.surahInfo.totalVerses} ${s.verses} · ${widget.surahInfo.isMeccan ? s.meccan : s.medinan}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        actions: [
          // Translation toggle
          GestureDetector(
            onTap: () => setState(() => _showTranslation = !_showTranslation),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _showTranslation
                    ? c.accent.withValues(alpha: 0.15)
                    : c.accent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: c.accent.withValues(alpha: _showTranslation ? 0.4 : 0.15),
                ),
              ),
              child: Text(
                _showTranslation ? s.hideTranslation : s.showTranslation,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: c.accent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoading(c, s)
          : _error != null
              ? _buildError(c, s, textColor)
              : _buildContent(c, s, textColor),
    );
  }

  Widget _buildLoading(dynamic c, dynamic s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: c.accent),
          const SizedBox(height: 16),
          Text(
            s.loadingVerses,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: c.accentLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(dynamic c, dynamic s, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56, color: c.accentLight),
            const SizedBox(height: 16),
            Text(
              s.couldNotLoadSurah,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: textColor.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSurah,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.scaffold,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                s.retry,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(dynamic c, dynamic s, Color textColor) {
    final ayahs = _content!.ayahs;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ayahs.length + (_showBismillah ? 1 : 0),
      itemBuilder: (context, index) {
        // Bismillah header for all surahs except 1 and 9
        if (_showBismillah && index == 0) {
          return _BismillahHeader(c: c);
        }

        final ayah = _showBismillah ? ayahs[index - 1] : ayahs[index];
        return _AyahTile(
          ayah: ayah,
          showTranslation: _showTranslation,
          c: c,
          textColor: textColor,
        );
      },
    );
  }
}

class _BismillahHeader extends StatelessWidget {
  final dynamic c;
  const _BismillahHeader({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.accent.withValues(alpha: 0.2)),
      ),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: GoogleFonts.amiri(
          fontSize: 26,
          color: c.accent,
          height: 2.0,
        ),
      ),
    );
  }
}

class _AyahTile extends StatelessWidget {
  final Ayah ayah;
  final bool showTranslation;
  final dynamic c;
  final Color textColor;

  const _AyahTile({
    required this.ayah,
    required this.showTranslation,
    required this.c,
    required this.textColor,
  });

  void _copyAyah(BuildContext context) {
    final text = '${ayah.arabic}\n\n${ayah.translation}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Verse copied',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: c.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _copyAyah(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.accent.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Verse number badge + divider
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${ayah.number}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: c.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 1,
                    color: c.accent.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Arabic text
            Text(
              ayah.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 22,
                color: textColor.withValues(alpha: 0.9),
                height: 2.0,
              ),
            ),

            // Translation
            if (showTranslation) ...[
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: c.accent.withValues(alpha: 0.06),
              ),
              const SizedBox(height: 10),
              Text(
                ayah.translation,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: textColor.withValues(alpha: 0.6),
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
