import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/reciter_list.dart';
import '../main.dart';
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

  PlaybackState? _playbackState;
  MediaItem? _currentMediaItem;
  late StreamSubscription<PlaybackState> _psSub;
  late StreamSubscription<MediaItem?> _miSub;

  static const String _cdnVerseBase =
      'https://cdn.islamic.network/quran/audio/128';

  @override
  void initState() {
    super.initState();
    _psSub = audioHandler.playbackState.listen((ps) {
      if (mounted) setState(() => _playbackState = ps);
    });
    _miSub = audioHandler.mediaItem.listen((mi) {
      if (mounted) setState(() => _currentMediaItem = mi);
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
    _psSub.cancel();
    _miSub.cancel();
    super.dispose();
  }

  bool get _isFromThisSurah =>
      _currentMediaItem?.id.startsWith('surah_${widget.surahInfo.number}_') ??
      false;

  bool get _isActive =>
      _isFromThisSurah &&
      (_playbackState?.processingState == AudioProcessingState.ready ||
          _playbackState?.processingState == AudioProcessingState.buffering ||
          _playbackState?.processingState == AudioProcessingState.loading);

  bool get _isPlaying => _isActive && (_playbackState?.playing ?? false);
  bool get _isPaused => _isActive && !(_playbackState?.playing ?? false);

  int? get _playingVerseNumber => _isFromThisSurah
      ? (_currentMediaItem?.extras?['verseNumber'] as int?)
      : null;

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

  Future<void> _playSurahFrom(int index) async {
    if (_content == null) return;
    final id = context.settings.reciterId;
    final reciterName = reciterById(id).name;
    final urls = _content!.ayahs
        .map((a) => '$_cdnVerseBase/$id/${a.globalNumber}.mp3')
        .toList();
    final items = _content!.ayahs.asMap().entries.map((e) {
      return MediaItem(
        id: 'surah_${widget.surahInfo.number}_verse_${e.value.number}',
        title: widget.surahInfo.name,
        artist: reciterName,
        album: 'Verse ${e.value.number}',
        extras: {
          'verseNumber': e.value.number,
          'surahIndex': e.key,
        },
      );
    }).toList();
    await audioHandler.playSurah(urls, items, startIndex: index);
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await audioHandler.pause();
    } else if (_isPaused) {
      await audioHandler.play();
    }
  }

  Future<void> _stop() => audioHandler.stop();
  Future<void> _skipNext() => audioHandler.skipToNext();
  Future<void> _skipPrev() => audioHandler.skipToPrevious();

  void _showReciterPicker() {
    final c = context.colors;
    final currentId = context.settings.reciterId;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          children: [
            Center(
              child: Text(
                'Select Reciter',
                style: GoogleFonts.poppins(
                  color: c.accentLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...reciters.map((r) {
              final selected = r.id == currentId;
              return GestureDetector(
                onTap: () async {
                  final settings = context.settings;
                  final shouldRestart = _isActive;
                  final currentIdx =
                      _currentMediaItem?.extras?['surahIndex'] as int? ?? 0;
                  Navigator.pop(ctx);
                  await settings.setReciter(r.id);
                  if (shouldRestart && mounted) {
                    await _playSurahFrom(currentIdx);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? c.accent.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? c.accent
                          : c.accent.withValues(alpha: 0.12),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.name,
                              style: GoogleFonts.poppins(
                                color: selected ? c.accent : c.accentLight,
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            Text(
                              r.arabicName,
                              style: GoogleFonts.amiri(
                                color: c.bodyText,
                                fontSize: 13,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_circle, color: c.accent, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
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
          GestureDetector(
            onTap: _showReciterPicker,
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: c.accent.withValues(alpha: 0.2)),
              ),
              child: Icon(Icons.mic_none, color: c.accent, size: 20),
            ),
          ),
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
              onTap: _isActive ? _togglePlayPause : () => _playSurahFrom(0),
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
    final verseNum = _playingVerseNumber;
    final label = verseNum != null ? '${s.verse} $verseNum' : widget.surahInfo.name;
    final subtitle = _currentMediaItem?.artist ??
        reciterById(context.settings.reciterId).name;

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
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _playSurahFrom(0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.replay, color: c.accent, size: 22),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: _skipPrev,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.skip_previous, color: c.accent, size: 26),
            ),
          ),
          const SizedBox(width: 4),
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _skipNext,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.skip_next, color: c.accent, size: 26),
            ),
          ),
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
    final ayahs = _content!.ayahs;
    String? firstAyahStripped;
    if (_showBismillah && ayahs.isNotEmpty) {
      final arabic = ayahs[0].arabic;
      final bare = arabic
          .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
          .replaceAll('ٱ', 'ا');
      if (bare.startsWith('بسم الله')) {
        final stripped = arabic
            .replaceFirst(
              RegExp(
                r'^.+?ح[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]*'
                r'ي[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]*'
                r'م[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]*\s*',
                dotAll: true,
              ),
              '',
            )
            .trim();
        if (stripped.isNotEmpty) firstAyahStripped = stripped;
      }
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: ayahs.length + (_showBismillah ? 1 : 0),
      itemBuilder: (context, index) {
        if (_showBismillah && index == 0) {
          return _BismillahHeader(c: c);
        }
        final ayahIndex = _showBismillah ? index - 1 : index;
        final ayah = ayahs[ayahIndex];
        final isThisPlaying = _isPlaying && _playingVerseNumber == ayah.number;
        final isFirst = _showBismillah ? index == 1 : index == 0;
        return _AyahTile(
          ayah: ayah,
          displayArabic:
              (isFirst && firstAyahStripped != null) ? firstAyahStripped : null,
          showTranslation: _showTranslation,
          isPlaying: isThisPlaying,
          c: c,
          textColor: textColor,
          onPlay: () => _playSurahFrom(ayahIndex),
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
  final String? displayArabic;
  final bool showTranslation;
  final bool isPlaying;
  final dynamic c;
  final Color textColor;
  final VoidCallback onPlay;

  const _AyahTile({
    required this.ayah,
    this.displayArabic,
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
              displayArabic ?? ayah.arabic,
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
