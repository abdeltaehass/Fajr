import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/hajj_umrah_guide.dart';
import '../settings/settings_provider.dart';

class HajjUmrahScreen extends StatefulWidget {
  const HajjUmrahScreen({super.key});

  @override
  State<HajjUmrahScreen> createState() => _HajjUmrahScreenState();
}

class _HajjUmrahScreenState extends State<HajjUmrahScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.scaffold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Hajj & Umrah Guide',
          style: GoogleFonts.poppins(
            color: c.accentLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: c.accentLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.accent.withValues(alpha: 0.2)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: c.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.accent, width: 1.5),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: c.accent,
              unselectedLabelColor: c.bodyText,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Umrah'),
                Tab(text: 'Hajj'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GuideList(sections: umrahGuide),
          _GuideList(sections: hajjGuide),
        ],
      ),
    );
  }
}

class _GuideList extends StatelessWidget {
  final List<GuideSection> sections;
  const _GuideList({required this.sections});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: sections.length,
      itemBuilder: (context, sIndex) {
        final section = sections[sIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sIndex > 0) const SizedBox(height: 8),
            _SectionHeader(title: section.heading),
            const SizedBox(height: 8),
            ...section.steps.asMap().entries.map((entry) {
              return _StepCard(
                stepNumber: entry.key + 1,
                step: entry.value,
              );
            }),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: c.accent,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final int stepNumber;
  final GuideStep step;

  const _StepCard({required this.stepNumber, required this.step});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final step = widget.step;
    final hasExtra =
        step.arabic != null || step.note != null || step.dua != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? c.accent.withValues(alpha: 0.4)
              : c.accent.withValues(alpha: 0.12),
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: hasExtra ? () => setState(() => _expanded = !_expanded) : null,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.stepNumber}',
                      style: GoogleFonts.poppins(
                        color: c.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.poppins(
                            color: c.accentLight,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.description,
                          style: GoogleFonts.poppins(
                            color: c.bodyText,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasExtra) ...[
                    const SizedBox(width: 8),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: c.accentLight,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_expanded && hasExtra)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: c.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.accent.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (step.arabic != null) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        step.arabic!,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          color: c.accentLight,
                          fontSize: 18,
                          height: 2,
                        ),
                      ),
                    ),
                    if (step.transliteration != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        step.transliteration!,
                        style: GoogleFonts.poppins(
                          color: c.bodyText.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (step.dua != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        step.dua!,
                        style: GoogleFonts.poppins(
                          color: c.bodyText,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (step.note != null) const SizedBox(height: 10),
                  ],
                  if (step.note != null && step.arabic == null && step.dua != null) ...[
                    Text(
                      step.dua!,
                      style: GoogleFonts.poppins(
                        color: c.bodyText,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (step.note != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: c.accent, size: 15),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            step.note!,
                            style: GoogleFonts.poppins(
                              color: c.accent.withValues(alpha: 0.85),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
