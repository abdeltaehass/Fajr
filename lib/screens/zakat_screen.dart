import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/hajj_umrah_guide.dart';
import '../data/zakat_guide.dart';
import '../settings/settings_provider.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  // Calculator controllers
  final _goldPriceCtrl   = TextEditingController();
  final _cashCtrl        = TextEditingController();
  final _goldValueCtrl   = TextEditingController();
  final _silverValueCtrl = TextEditingController();
  final _businessCtrl    = TextEditingController();
  final _investCtrl      = TextEditingController();
  final _receivableCtrl  = TextEditingController();
  final _debtsCtrl       = TextEditingController();

  double? _zakatDue;
  double? _totalWealth;
  double? _nisab;
  bool _belowNisab = false;

  @override
  void dispose() {
    _goldPriceCtrl.dispose();
    _cashCtrl.dispose();
    _goldValueCtrl.dispose();
    _silverValueCtrl.dispose();
    _businessCtrl.dispose();
    _investCtrl.dispose();
    _receivableCtrl.dispose();
    _debtsCtrl.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '')) ?? 0;

  void _calculate() {
    final goldPrice = _parse(_goldPriceCtrl);
    final cash       = _parse(_cashCtrl);
    final goldVal    = _parse(_goldValueCtrl);
    final silverVal  = _parse(_silverValueCtrl);
    final business   = _parse(_businessCtrl);
    final invest     = _parse(_investCtrl);
    final receivable = _parse(_receivableCtrl);
    final debts      = _parse(_debtsCtrl);

    final total = cash + goldVal + silverVal + business + invest + receivable - debts;
    final nisab = goldPrice > 0 ? 85 * goldPrice : null;

    setState(() {
      _totalWealth = total < 0 ? 0 : total;
      _nisab = nisab;
      if (nisab != null && total < nisab) {
        _belowNisab = true;
        _zakatDue = 0;
      } else {
        _belowNisab = false;
        _zakatDue = (total < 0 ? 0 : total) * 0.025;
      }
    });

    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _goldPriceCtrl.clear();
    _cashCtrl.clear();
    _goldValueCtrl.clear();
    _silverValueCtrl.clear();
    _businessCtrl.clear();
    _investCtrl.clear();
    _receivableCtrl.clear();
    _debtsCtrl.clear();
    setState(() {
      _zakatDue = null;
      _totalWealth = null;
      _nisab = null;
      _belowNisab = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.scaffold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Zakat Guide',
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
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.accent.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.volunteer_activism, color: c.accent, size: 36),
                const SizedBox(height: 10),
                Text(
                  'الزَّكَاة',
                  style: GoogleFonts.amiri(
                    fontSize: 28,
                    color: c.accent,
                    height: 1.8,
                  ),
                ),
                Text(
                  'The Third Pillar of Islam',
                  style: GoogleFonts.poppins(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '2.5% of net zakatable wealth held for one lunar year',
                  style: GoogleFonts.poppins(
                    color: c.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Guide sections
          ...zakatGuide.map((section) => _GuideSection(
                section: section,
                c: c,
                textColor: textColor,
              )),

          const SizedBox(height: 8),

          // Calculator
          _ZakatCalculator(
            c: c,
            textColor: textColor,
            goldPriceCtrl: _goldPriceCtrl,
            cashCtrl: _cashCtrl,
            goldValueCtrl: _goldValueCtrl,
            silverValueCtrl: _silverValueCtrl,
            businessCtrl: _businessCtrl,
            investCtrl: _investCtrl,
            receivableCtrl: _receivableCtrl,
            debtsCtrl: _debtsCtrl,
            zakatDue: _zakatDue,
            totalWealth: _totalWealth,
            nisab: _nisab,
            belowNisab: _belowNisab,
            onCalculate: _calculate,
            onReset: _reset,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Guide section widget
// ─────────────────────────────────────────────────────────────

class _GuideSection extends StatefulWidget {
  final GuideSection section;
  final dynamic c;
  final Color textColor;

  const _GuideSection({
    required this.section,
    required this.c,
    required this.textColor,
  });

  @override
  State<_GuideSection> createState() => _GuideSectionState();
}

class _GuideSectionState extends State<_GuideSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: c.accent.withValues(alpha: _expanded ? 0.3 : 0.12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.section.heading,
                    style: GoogleFonts.poppins(
                      color: c.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: c.accent,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.accent.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: widget.section.steps.asMap().entries.map((e) {
                final isLast = e.key == widget.section.steps.length - 1;
                return _StepTile(
                  step: e.value,
                  c: c,
                  textColor: widget.textColor,
                  showDivider: !isLast,
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final GuideStep step;
  final dynamic c;
  final Color textColor;
  final bool showDivider;

  const _StepTile({
    required this.step,
    required this.c,
    required this.textColor,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.accentLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: textColor.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
              if (step.arabic != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        step.arabic!,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          color: c.accent,
                          height: 2.0,
                        ),
                      ),
                      if (step.dua != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.dua!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: textColor.withValues(alpha: 0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (step.note != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(color: c.accent, width: 3),
                    ),
                  ),
                  child: Text(
                    step.note!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: c.accent.withValues(alpha: 0.08),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Zakat Calculator
// ─────────────────────────────────────────────────────────────

class _ZakatCalculator extends StatelessWidget {
  final dynamic c;
  final Color textColor;
  final TextEditingController goldPriceCtrl;
  final TextEditingController cashCtrl;
  final TextEditingController goldValueCtrl;
  final TextEditingController silverValueCtrl;
  final TextEditingController businessCtrl;
  final TextEditingController investCtrl;
  final TextEditingController receivableCtrl;
  final TextEditingController debtsCtrl;
  final double? zakatDue;
  final double? totalWealth;
  final double? nisab;
  final bool belowNisab;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const _ZakatCalculator({
    required this.c,
    required this.textColor,
    required this.goldPriceCtrl,
    required this.cashCtrl,
    required this.goldValueCtrl,
    required this.silverValueCtrl,
    required this.businessCtrl,
    required this.investCtrl,
    required this.receivableCtrl,
    required this.debtsCtrl,
    required this.zakatDue,
    required this.totalWealth,
    required this.nisab,
    required this.belowNisab,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.calculate_outlined, color: c.accent, size: 22),
              const SizedBox(width: 10),
              Text(
                'Zakat Calculator',
                style: GoogleFonts.poppins(
                  color: c.accentLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Enter all values in your local currency',
            style: GoogleFonts.poppins(
              color: textColor.withValues(alpha: 0.45),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Gold price (for nisab calculation)
          _SectionLabel('Nisab Reference', c, textColor),
          _Field(
            ctrl: goldPriceCtrl,
            label: 'Gold price per gram',
            hint: 'e.g. 60.00',
            note: 'Used to calculate nisab (85g × price)',
            c: c,
            textColor: textColor,
          ),
          const SizedBox(height: 20),

          // Assets
          _SectionLabel('Assets', c, textColor),
          _Field(ctrl: cashCtrl,        label: 'Cash & bank savings',     hint: '0.00', c: c, textColor: textColor),
          _Field(ctrl: goldValueCtrl,   label: 'Gold (market value)',      hint: '0.00', c: c, textColor: textColor),
          _Field(ctrl: silverValueCtrl, label: 'Silver (market value)',    hint: '0.00', c: c, textColor: textColor),
          _Field(ctrl: businessCtrl,    label: 'Business / trade goods',   hint: '0.00', c: c, textColor: textColor),
          _Field(ctrl: investCtrl,      label: 'Investments & stocks',     hint: '0.00', c: c, textColor: textColor),
          _Field(ctrl: receivableCtrl,  label: 'Money owed to you',        hint: '0.00', c: c, textColor: textColor),
          const SizedBox(height: 20),

          // Deductions
          _SectionLabel('Deductions', c, textColor),
          _Field(
            ctrl: debtsCtrl,
            label: 'Debts you owe',
            hint: '0.00',
            note: 'Subtracted from total before calculating Zakat',
            c: c,
            textColor: textColor,
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCalculate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Calculate Zakat',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: c.scaffold,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 18),
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: c.accent.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                      color: c.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Result
          if (zakatDue != null) ...[
            const SizedBox(height: 20),
            _ResultCard(
              c: c,
              textColor: textColor,
              zakatDue: zakatDue!,
              totalWealth: totalWealth!,
              nisab: nisab,
              belowNisab: belowNisab,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final dynamic c;
  final Color textColor;
  const _SectionLabel(this.label, this.c, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          color: c.accentLight.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final String? note;
  final dynamic c;
  final Color textColor;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.note,
    required this.c,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: textColor.withValues(alpha: 0.3),
                fontSize: 14,
              ),
              filled: true,
              fillColor: c.scaffold.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.accent.withValues(alpha: 0.15)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.accent.withValues(alpha: 0.15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: c.accent, width: 1.5),
              ),
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 4),
            Text(
              note!,
              style: GoogleFonts.poppins(
                color: textColor.withValues(alpha: 0.4),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final dynamic c;
  final Color textColor;
  final double zakatDue;
  final double totalWealth;
  final double? nisab;
  final bool belowNisab;

  const _ResultCard({
    required this.c,
    required this.textColor,
    required this.zakatDue,
    required this.totalWealth,
    required this.nisab,
    required this.belowNisab,
  });

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)}K';
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isDue = !belowNisab;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDue
            ? c.accent.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDue
              ? c.accent.withValues(alpha: 0.35)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDue ? Icons.check_circle_outline : Icons.info_outline,
                color: isDue ? c.accent : textColor.withValues(alpha: 0.4),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isDue ? 'Zakat is Due' : 'Zakat Not Yet Due',
                style: GoogleFonts.poppins(
                  color: isDue ? c.accent : textColor.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Row('Total zakatable wealth', _fmt(totalWealth), c, textColor),
          if (nisab != null)
            _Row('Nisab (85g × gold price)', _fmt(nisab!), c, textColor),
          if (isDue) ...[
            Divider(height: 20, color: c.accent.withValues(alpha: 0.15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Zakat Due (2.5%)',
                  style: GoogleFonts.poppins(
                    color: c.accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _fmt(zakatDue),
                  style: GoogleFonts.poppins(
                    color: c.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 6),
            Text(
              nisab != null
                  ? 'Your wealth has not reached the nisab threshold. Zakat is not obligatory at this time.'
                  : 'Enter your gold price per gram above to check if your wealth meets nisab.',
              style: GoogleFonts.poppins(
                color: textColor.withValues(alpha: 0.5),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _Row(String label, String value, dynamic c, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: textColor.withValues(alpha: 0.55),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
