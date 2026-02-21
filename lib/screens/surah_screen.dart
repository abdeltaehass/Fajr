import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/reciter_list.dart';
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
  String? _loadedEdition;

  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  int? _playingVerseNumber;
  bool _isPlayingSurah = false;

  static const String _cdnVerseBase =
      'https://cdn.islamic.network/quran/audio/128';

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) _playNextVerse();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final edition = context.settings.quranEdition;
    if (_loadedEdition != edition) {
      _loadedEdition = edition;
      _loadSurah();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSurah() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final content = await widget.quranService.getSurah(
        widget.surahInfo.number,
        edition: _loadedEdition ?? 'en.sahih',
      );
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

  Future<void> _playSurah() async {
    if (_content == null || _content!.ayahs.isEmpty) return;
    await _playVerse(_content!.ayahs[0]);
  }

  Future<void> _playVerse(Ayah ayah) async {
    final id = context.settings.reciterId;
    await _audioPlayer
        .play(UrlSource('$_cdnVerseBase/$id/${ayah.globalNumber}.mp3'));
    setState(() {
      _playingVerseNumber = ayah.number;
      _isPlayingSurah = false;
    });
  }

  Future<void> _togglePlayPause() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else if (_playerState == PlayerState.paused) {
      await _audioPlayer.resume();
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _playingVerseNumber = null;
      _isPlayingSurah = false;
    });
  }

  Future<void> _playNextVerse() async {
    if (_isPlayingSurah || _content == null) {
      if (mounted) setState(() { _playingVerseNumber = null; _isPlayingSurah = false; });
      return;
    }
    final ayahs = _content!.ayahs;
    final currentIndex = ayahs.indexWhere((a) => a.number == _playingVerseNumber);
    if (currentIndex >= 0 && currentIndex < ayahs.length - 1) {
      await _playVerse(ayahs[currentIndex + 1]);
    } else {
      if (mounted) setState(() { _playingVerseNumber = null; _isPlayingSurah = false; });
    }
  }

  Future<void> _playPreviousVerse() async {
    if (_content == null || _playingVerseNumber == null) return;
    final ayahs = _content!.ayahs;
    final currentIndex = ayahs.indexWhere((a) => a.number == _playingVerseNumber);
    if (currentIndex > 0) await _playVerse(ayahs[currentIndex - 1]);
  }

  bool get _showBismillah =>
      widget.surahInfo.number != 1 && widget.surahInfo.number != 9;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isActive => _isPlaying || _isPaused;

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
          GestureDetector(
            onTap: () => setState(() => _showTranslation = !_showTranslation),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _showTranslation
                    ? c.accent.withValues(alpha: 0.15)
                    : c.accent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: c.accent
                      .withValues(alpha: _showTranslation ? 0.4 : 0.15),
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
          if (!_isLoading && _error == null)
            GestureDetector(
              onTap: _isActive ? _togglePlayPause : _playSurah,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: c.accent,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? _buildLoading(c, s)
                : _error != null
                    ? _buildError(c, s, textColor)
                    : _buildContent(c, s, textColor),
          ),
          if (_isActive) _buildAudioBar(c, textColor),
        ],
      ),
    );
  }

  Widget _buildAudioBar(dynamic c, Color textColor) {
    final s = context.strings;
    final label = _isPlayingSurah
        ? widget.surahInfo.name
        : '${s.verse} $_playingVerseNumber';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: c.card,
        border:
            Border(top: BorderSide(color: c.accent.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          Icon(Icons.headphones, size: 24, color: c.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  reciterById(context.settings.reciterId).name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (!_isPlayingSurah) ...[
            GestureDetector(
              onTap: _playPreviousVerse,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.skip_previous, color: c.accent, size: 26),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: c.accent,
                size: 26,
              ),
            ),
          ),
          if (!_isPlayingSurah) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _playNextVerse,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.skip_next, color: c.accent, size: 26),
              ),
            ),
          ],
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _stop,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stop, color: Colors.red, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(dynamic c, dynamic s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: c.accent),
          const SizedBox(height: 16),
          Text(s.loadingVerses,
              style:
                  GoogleFonts.poppins(fontSize: 14, color: c.accentLight)),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(s.retry,
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(dynamic c, dynamic s, Color textColor) {
    var ayahs = _content!.ayahs;
    // Skip the first ayah if it contains the bismillah and we're already showing the header
    if (_showBismillah && ayahs.isNotEmpty && ayahs[0].arabic.startsWith('بِسْمِ')) {
      ayahs = ayahs.sublist(1);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: ayahs.length + (_showBismillah ? 1 : 0),
      itemBuilder: (context, index) {
        if (_showBismillah && index == 0) {
          return _BismillahHeader(c: c);
        }
        final ayah = _showBismillah ? ayahs[index - 1] : ayahs[index];
        final isThisPlaying =
            _isPlaying && _playingVerseNumber == ayah.number;
        return _AyahTile(
          ayah: ayah,
          showTranslation: _showTranslation,
          isPlaying: isThisPlaying,
          c: c,
          textColor: textColor,
          onPlay: () => _playVerse(ayah),
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
        style:
            GoogleFonts.amiri(fontSize: 26, color: c.accent, height: 2.0),
      ),
    );
  }
}

class _AyahTile extends StatelessWidget {
  final Ayah ayah;
  final bool showTranslation;
  final bool isPlaying;
  final dynamic c;
  final Color textColor;
  final VoidCallback onPlay;

  const _AyahTile({
    required this.ayah,
    required this.showTranslation,
    required this.isPlaying,
    required this.c,
    required this.textColor,
    required this.onPlay,
  });

  void _copyAyah(BuildContext context) {
    final text = '${ayah.arabic}\n\n${ayah.translation}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.strings.verseCopied, style: GoogleFonts.poppins()),
        backgroundColor: c.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
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
          color: isPlaying ? c.accent.withValues(alpha: 0.06) : c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying
                ? c.accent.withValues(alpha: 0.3)
                : c.accent.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      color: c.accent.withValues(alpha: 0.08)),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onPlay,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? c.accent.withValues(alpha: 0.2)
                          : c.accent.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.volume_up : Icons.play_arrow,
                      size: 14,
                      color: c.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
            if (showTranslation) ...[
              const SizedBox(height: 10),
              Container(
                  height: 1,
                  color: c.accent.withValues(alpha: 0.06)),
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
