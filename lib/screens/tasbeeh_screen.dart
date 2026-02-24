import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';

class _Dhikr {
  final String arabic;
  final String transliteration;
  final int target;
  const _Dhikr(this.arabic, this.transliteration, this.target);
}

const _presets = [
  _Dhikr('سُبْحَانَ اللَّهِ',   'SubhanAllah',   33),
  _Dhikr('الْحَمْدُ لِلَّهِ',   'Alhamdulillah', 33),
  _Dhikr('اللَّهُ أَكْبَرُ',    'Allahu Akbar',  34),
];

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _count = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _increment() {
    final target = _presets[_selectedIndex].target;
    if (_count >= target) return;
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    setState(() => _count++);
    if (_count == target) {
      HapticFeedback.mediumImpact();
    }
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() => _count = 0);
  }

  void _selectDhikr(int index) {
    setState(() {
      _selectedIndex = index;
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dhikr = _presets[_selectedIndex];
    final target = dhikr.target;
    final progress = _count / target;
    final done = _count >= target;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.scaffold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: c.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tasbeeh',
          style: GoogleFonts.poppins(
            color: highEmphasis,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: c.accent),
            onPressed: _reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Dhikr selector chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_presets.length, (i) {
                  final selected = i == _selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => _selectDhikr(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? c.accent.withValues(alpha: 0.2)
                              : c.card,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: selected
                                ? c.accent
                                : c.accent.withValues(alpha: 0.25),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _presets[i].arabic,
                              style: GoogleFonts.amiri(
                                color: selected ? c.accent : c.bodyText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '×${_presets[i].target}',
                              style: GoogleFonts.poppins(
                                color: selected
                                    ? c.accent
                                    : c.accentLight.withValues(alpha: 0.6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // Current dhikr name
            Text(
              dhikr.transliteration,
              style: GoogleFonts.poppins(
                color: c.accentLight.withValues(alpha: 0.7),
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            // Big tap circle
            GestureDetector(
              onTap: _increment,
              child: ScaleTransition(
                scale: _pulseAnim,
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress ring
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          backgroundColor: c.card,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            done ? Colors.greenAccent.shade400 : c.accent,
                          ),
                        ),
                      ),
                      // Inner circle
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.card,
                          boxShadow: [
                            BoxShadow(
                              color: c.accent.withValues(alpha: 0.15),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (done)
                              Icon(Icons.check_circle_outline,
                                  color: Colors.greenAccent.shade400, size: 40)
                            else ...[
                              Text(
                                '$_count',
                                style: GoogleFonts.poppins(
                                  color: highEmphasis,
                                  fontSize: 64,
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                ),
                              ),
                              Text(
                                '/ $target',
                                style: GoogleFonts.poppins(
                                  color:
                                      c.accentLight.withValues(alpha: 0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Arabic text
            Text(
              dhikr.arabic,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                color: done ? Colors.greenAccent.shade400 : highEmphasis,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.8,
              ),
            ),

            if (done)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Complete! Tap reset to continue.',
                  style: GoogleFonts.poppins(
                    color: Colors.greenAccent.shade400,
                    fontSize: 13,
                  ),
                ),
              ),

            const Spacer(),

            // Sequence reminder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: c.accent.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_presets.length, (i) {
                    final isCurrent = i == _selectedIndex;
                    return Column(
                      children: [
                        Text(
                          _presets[i].transliteration,
                          style: GoogleFonts.poppins(
                            color: isCurrent
                                ? c.accent
                                : c.accentLight.withValues(alpha: 0.4),
                            fontSize: 11,
                            fontWeight: isCurrent
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        Text(
                          '×${_presets[i].target}',
                          style: GoogleFonts.poppins(
                            color: isCurrent
                                ? c.accent
                                : c.accentLight.withValues(alpha: 0.3),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reset button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _reset,
                  icon: Icon(Icons.refresh, color: c.accent, size: 18),
                  label: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                        color: c.accent, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: c.accent.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
