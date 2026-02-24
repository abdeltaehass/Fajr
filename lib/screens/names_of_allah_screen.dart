import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/names_of_allah.dart';
import '../settings/settings_provider.dart';

class NamesOfAllahScreen extends StatelessWidget {
  const NamesOfAllahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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
        title: Column(
          children: [
            Text(
              'Asma ul Husna',
              style: GoogleFonts.poppins(
                color: highEmphasis,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'أسماء الله الحسنى',
              style: GoogleFonts.amiri(
                color: c.accent,
                fontSize: 14,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: namesOfAllah.length,
        itemBuilder: (context, index) {
          final name = namesOfAllah[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: c.accent.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  // Number badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.accent.withValues(alpha: 0.15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${name.number}',
                      style: GoogleFonts.poppins(
                        color: c.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Meaning
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.transliteration,
                          style: GoogleFonts.poppins(
                            color: highEmphasis,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name.meaning,
                          style: GoogleFonts.poppins(
                            color: c.accentLight.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Arabic
                  Text(
                    name.arabic,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      color: c.accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
