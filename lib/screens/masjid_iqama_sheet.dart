import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/iqama_times.dart';
import '../models/masjid_event.dart';
import '../settings/settings_provider.dart';

class IqamaTimesSheet extends StatefulWidget {
  const IqamaTimesSheet({super.key});

  @override
  State<IqamaTimesSheet> createState() => _IqamaTimesSheetState();
}

class _IqamaTimesSheetState extends State<IqamaTimesSheet> {
  late TextEditingController _fajr;
  late TextEditingController _dhuhr;
  late TextEditingController _asr;
  late TextEditingController _maghrib;
  late TextEditingController _isha;
  late TextEditingController _jumuah;

  @override
  void initState() {
    super.initState();
    final existing = context.settings.iqamaTimes;
    _fajr = TextEditingController(text: existing?.fajr ?? '');
    _dhuhr = TextEditingController(text: existing?.dhuhr ?? '');
    _asr = TextEditingController(text: existing?.asr ?? '');
    _maghrib = TextEditingController(text: existing?.maghrib ?? '');
    _isha = TextEditingController(text: existing?.isha ?? '');
    _jumuah = TextEditingController(text: existing?.jumuah ?? '');
  }

  @override
  void dispose() {
    _fajr.dispose();
    _dhuhr.dispose();
    _asr.dispose();
    _maghrib.dispose();
    _isha.dispose();
    _jumuah.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      controller.text = picked.format(context);
    }
  }

  void _save() {
    final times = IqamaTimes(
      fajr: _fajr.text.trim(),
      dhuhr: _dhuhr.text.trim(),
      asr: _asr.text.trim(),
      maghrib: _maghrib.text.trim(),
      isha: _isha.text.trim(),
      jumuah: _jumuah.text.trim(),
    );
    context.settings.setIqamaTimes(times);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    final prayers = [
      ('Fajr', _fajr),
      ('Dhuhr', _dhuhr),
      ('Asr', _asr),
      ('Maghrib', _maghrib),
      ('Isha', _isha),
      (s.jumuah, _jumuah),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: c.scaffold,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.accentLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            s.setIqamaTimes,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...prayers.map((entry) => _TimeRow(
                label: entry.$1,
                controller: entry.$2,
                c: c,
                textColor: textColor,
                onTap: () => _pickTime(entry.$2),
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: c.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: c.accent.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      s.cancel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.save,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: c.scaffold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final dynamic c;
  final Color textColor;
  final VoidCallback onTap;

  const _TimeRow({
    required this.label,
    required this.controller,
    required this.c,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.accent.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  controller.text.isEmpty ? '—' : controller.text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: controller.text.isEmpty
                        ? textColor.withValues(alpha: 0.3)
                        : c.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.access_time, size: 18,
                  color: textColor.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class AddEventSheet extends StatefulWidget {
  const AddEventSheet({super.key});

  @override
  State<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends State<AddEventSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final event = MasjidEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: _selectedDate,
      description: _descController.text.trim(),
    );
    context.settings.addMasjidEvent(event);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    final dateStr =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'
        ' ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: c.scaffold,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.accentLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              s.addEvent,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SheetField(
            hint: s.eventTitle,
            controller: _titleController,
            c: c,
            textColor: textColor,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: c.accent.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 18, color: c.accentLight),
                  const SizedBox(width: 10),
                  Text(
                    dateStr,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: c.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _SheetField(
            hint: s.eventDescription,
            controller: _descController,
            c: c,
            textColor: textColor,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: c.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: c.accent.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      s.cancel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.save,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: c.scaffold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final dynamic c;
  final Color textColor;
  final int maxLines;

  const _SheetField({
    required this.hint,
    required this.controller,
    required this.c,
    required this.textColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.accent.withValues(alpha: 0.15)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 14, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
              fontSize: 14, color: textColor.withValues(alpha: 0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
