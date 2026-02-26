import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/duas.dart';
import '../settings/settings_provider.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

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
            color: c.accentLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: duaCategories.length,
        itemBuilder: (context, index) {
          final cat = duaCategories[index];
          return _CategoryTile(category: cat);
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final DuaCategory category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _DuaCategoryScreen(category: category),
          ),
        ),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.accent.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: GoogleFonts.poppins(
                        color: c.accentLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.duas.length} duas',
                      style: GoogleFonts.poppins(
                        color: c.bodyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: c.accentLight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuaCategoryScreen extends StatelessWidget {
  final DuaCategory category;
  const _DuaCategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.scaffold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: c.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: GoogleFonts.poppins(
                color: c.accentLight,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: category.duas.length,
        itemBuilder: (context, index) => _DuaCard(dua: category.duas[index]),
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
              color: _expanded
                  ? c.accent.withValues(alpha: 0.4)
                  : c.accent.withValues(alpha: 0.15),
              width: _expanded ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.dua.title,
                      style: GoogleFonts.poppins(
                        color: c.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
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
                Container(height: 1, color: c.accent.withValues(alpha: 0.15)),
                const SizedBox(height: 14),
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
                Text(
                  widget.dua.translation,
                  style: GoogleFonts.poppins(
                    color: c.bodyText,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
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
