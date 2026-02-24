import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/duas.dart';
import '../settings/settings_provider.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;
    final category = duaCategories[_selectedCategory];

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
          'Dua Collection',
          style: GoogleFonts.poppins(
            color: highEmphasis,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category selector
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: duaCategories.length,
              itemBuilder: (context, index) {
                final selected = index == _selectedCategory;
                final cat = duaCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? c.accent.withValues(alpha: 0.2)
                            : c.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? c.accent
                              : c.accent.withValues(alpha: 0.2),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat.icon,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: GoogleFonts.poppins(
                              color: selected ? c.accent : c.bodyText,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Duas list
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: category.duas.length,
              itemBuilder: (context, index) {
                final dua = category.duas[index];
                return _DuaCard(dua: dua);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaCard extends StatefulWidget {
  final Dua dua;
  const _DuaCard({required this.dua});

  @override
  State<_DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<_DuaCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final highEmphasis = c.isLight ? c.scaffold : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: c.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.dua.title,
                    style: GoogleFonts.poppins(
                      color: c.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: c.accentLight.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Arabic text
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.dua.arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    color: highEmphasis,
                    fontSize: 20,
                    height: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              if (_expanded) ...[
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: c.accent.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 14),

                // Transliteration
                Text(
                  widget.dua.transliteration,
                  style: GoogleFonts.poppins(
                    color: c.accent,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),

                // Translation
                Text(
                  widget.dua.translation,
                  style: GoogleFonts.poppins(
                    color: c.bodyText,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),

                // Source
                Text(
                  widget.dua.source,
                  style: GoogleFonts.poppins(
                    color: c.accentLight.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
