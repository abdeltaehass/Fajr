import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';
import '../data/athkar.dart';

class AthkarScreen extends StatefulWidget {
  final String title;
  final List<Dhikr> athkar;

  const AthkarScreen({
    super.key,
    required this.title,
    required this.athkar,
  });

  @override
  State<AthkarScreen> createState() => _AthkarScreenState();
}

class _AthkarScreenState extends State<AthkarScreen> {
  int _currentIndex = 0;
  int _currentCount = 0;
  bool _completed = false;

  Dhikr get _currentDhikr => widget.athkar[_currentIndex];

  void _onTap() {
    if (_completed) return;

    setState(() {
      _currentCount++;
      if (_currentCount >= _currentDhikr.repeatCount) {
        _currentCount = 0;
        if (_currentIndex < widget.athkar.length - 1) {
          _currentIndex++;
        } else {
          _completed = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.card,
        foregroundColor: c.accent,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _completed ? _buildCompletedState() : _buildDhikrView(),
      ),
    );
  }

  Widget _buildDhikrView() {
    final c = context.colors;
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Progress bar
            _buildProgressBar(),
            const SizedBox(height: 8),

            // Progress text
            Text(
              '${_currentIndex + 1} of ${widget.athkar.length}',
              style: GoogleFonts.poppins(
                color: c.accentLight.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            // Arabic text
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      _currentDhikr.arabic,
                      style: GoogleFonts.amiri(
                        color: c.isLight ? c.scaffold : Colors.white,
                        fontSize: 24,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Container(
                      width: 60,
                      height: 1,
                      color: c.accent.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 24),

                    // Translation
                    Text(
                      _currentDhikr.translation,
                      style: GoogleFonts.poppins(
                        color: c.accentLight,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Counter badge
            _buildCounterBadge(),
            const SizedBox(height: 12),

            Text(
              context.strings.tapAnywhere,
              style: GoogleFonts.poppins(
                color: c.accentLight.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final c = context.colors;
    final progress = (_currentIndex + 1) / widget.athkar.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: c.surface.withValues(alpha: 0.3),
        color: c.accent,
        minHeight: 4,
      ),
    );
  }

  Widget _buildCounterBadge() {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: c.accent.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Text(
        '$_currentCount / ${_currentDhikr.repeatCount}',
        style: GoogleFonts.poppins(
          color: c.accent,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    final c = context.colors;
    final s = context.strings;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: c.accent,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              s.completed,
              style: GoogleFonts.amiri(
                color: c.accent,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.acceptanceMessage,
              style: GoogleFonts.poppins(
                color: c.accentLight,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.scaffold,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                s.done,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
