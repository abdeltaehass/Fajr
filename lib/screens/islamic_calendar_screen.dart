import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';

// ─────────────────────────────────────────────────────────────
// Hijri conversion (tabular/Kuwaiti civil calendar)
// ─────────────────────────────────────────────────────────────

class HijriDate {
  final int year;
  final int month;
  final int day;
  const HijriDate(this.year, this.month, this.day);
}

int _toJdn(int y, int m, int d) {
  final a = (14 - m) ~/ 12;
  final yy = y + 4800 - a;
  final mm = m + 12 * a - 3;
  return d +
      (153 * mm + 2) ~/ 5 +
      365 * yy +
      yy ~/ 4 -
      yy ~/ 100 +
      yy ~/ 400 -
      32045;
}

HijriDate jdnToHijri(int jd) {
  int l = jd - 1948440 + 10632;
  final n = (l - 1) ~/ 10631;
  l = l - 10631 * n + 354;
  final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
      (l ~/ 5670) * ((43 * l) ~/ 15238);
  l = l -
      ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
      (j ~/ 16) * ((15238 * j) ~/ 43) +
      29;
  final month = (24 * l) ~/ 709;
  final day = l - (709 * month) ~/ 24;
  final year = 30 * n + j - 30;
  return HijriDate(year, month, day);
}

HijriDate gregorianToHijri(DateTime date) =>
    jdnToHijri(_toJdn(date.year, date.month, date.day));

DateTime hijriMonthStart(int hy, int hm) {
  final n = (hy - 1) ~/ 30;
  final r = (hy - 1) % 30;
  int jd = 1948440 - 385 +
      n * 10631 +
      (r * 10631 + 29) ~/ 30 +
      (11 * hm - 1) ~/ 3 +
      30 * (hm - 1) +
      1;
  int a = jd + 32044;
  int b = (4 * a + 3) ~/ 146097;
  int c = a - (b * 146097) ~/ 4;
  int d2 = (4 * c + 3) ~/ 1461;
  int e = c - (1461 * d2) ~/ 4;
  int m2 = (5 * e + 2) ~/ 153;
  int day = e - (153 * m2 + 2) ~/ 5 + 1;
  int month = m2 + 3 - 12 * (m2 ~/ 10);
  int year = b * 100 + d2 - 4800 + m2 ~/ 10;
  return DateTime(year, month, day);
}

// ─────────────────────────────────────────────────────────────
// Event & fasting data
// ─────────────────────────────────────────────────────────────

class _Entry {
  final String name;
  final String description;
  final bool isFast;
  final bool isHoliday; // fasting is forbidden
  const _Entry({
    required this.name,
    required this.description,
    this.isFast = false,
    this.isHoliday = false,
  });
}

const Map<(int, int), _Entry> _fixedDates = {
  (1, 1): _Entry(
    name: 'Islamic New Year',
    description:
        'The Islamic lunar year begins on 1 Muharram. Muharram is one of the four sacred months — along with Rajab, Dhul Qa\'da, and Dhul Hijja — in which fighting was traditionally forbidden. It is a time for gratitude, reflection, and renewed intention for the year ahead.',
  ),
  (1, 9): _Entry(
    name: "Tasu'a",
    description:
        'The 9th of Muharram. The Prophet ﷺ intended to fast this day alongside Ashura to distinguish from the Jewish practice of fasting only on the 10th. It is Sunnah to fast both the 9th and 10th of Muharram together.',
    isFast: true,
  ),
  (1, 10): _Entry(
    name: 'Day of Ashura',
    description:
        'The Prophet ﷺ said: "Fasting the Day of Ashura expiates the sins of the previous year." (Muslim). This is also the day Allah saved Musa (AS) and the Children of Israel from Pharaoh, and the day Nuh\'s (AS) Ark came to rest on Mount Judi. It is one of the most recommended voluntary fasts of the year.',
    isFast: true,
  ),
  (3, 12): _Entry(
    name: "Mawlid al-Nabi ﷺ",
    description:
        'The birth of the Prophet Muhammad ﷺ is commemorated on 12 Rabi\' al-Awwal. This is an occasion for Muslims to study and celebrate his life, mercy, and character. Scholars have differed on the ruling of its formal observance, but there is consensus that increasing salawat and learning about his Seerah is always virtuous.',
  ),
  (7, 1): _Entry(
    name: 'Rajab Begins',
    description:
        'Rajab is one of the four sacred months in Islam. The Prophet ﷺ would make du\'a upon its entry: "Allahumma barik lana fi Rajab wa Sha\'ban wa ballighna Ramadan." It is a month of preparation — increasing worship and seeking forgiveness — as Ramadan approaches.',
  ),
  (7, 27): _Entry(
    name: "Isra' & Mi'raj",
    description:
        'The miraculous night journey in which the Prophet ﷺ was taken from Masjid al-Haram to Masjid al-Aqsa (Isra\'), then ascended through the seven heavens to meet Allah (Mi\'raj). The five daily prayers were made obligatory on this blessed night — a gift to the Muslim ummah.',
  ),
  (8, 15): _Entry(
    name: "Laylat al-Bara'ah",
    description:
        'The 15th night of Sha\'ban. Some scholars regard this as a blessed night for du\'a and seeking forgiveness, supported by certain narrations. Others urge caution about innovated practices on this night. Regardless, seeking Allah\'s pardon and performing extra worship is always beneficial.',
  ),
  (9, 1): _Entry(
    name: 'Ramadan Begins',
    description:
        'The blessed month of fasting, Quran, and intensified worship. Every healthy adult Muslim must fast from Fajr to Maghrib. The Prophet ﷺ said: "When Ramadan comes, the gates of Paradise are opened, the gates of Hell are shut, and the devils are chained." (Bukhari & Muslim). Increase charity, Quran, and night prayer.',
    isFast: true,
  ),
  (9, 17): _Entry(
    name: 'Battle of Badr',
    description:
        'On 17 Ramadan (2 AH), the first major battle of Islam was fought at the wells of Badr. Three hundred and thirteen believers faced over a thousand Quraysh warriors. Allah sent angels to support the Muslims, and the decisive victory established the young Muslim state in Madinah.',
  ),
  (9, 21): _Entry(
    name: 'Seek Laylat al-Qadr',
    description:
        'Laylat al-Qadr — the Night of Decree — falls in an odd night of the last ten days. It is better than a thousand months (over 83 years) of worship. The entire Quran was first revealed on this night. The Prophet ﷺ intensified worship throughout the last ten nights. Recite: "Allahumma innaka \'Afuwwun tuhibbul \'afwa fa\'fu \'anni."',
  ),
  (9, 23): _Entry(
    name: 'Seek Laylat al-Qadr',
    description:
        'Seek Laylat al-Qadr in the odd nights of the last ten days of Ramadan. The Prophet ﷺ used to make I\'tikaf (spiritual retreat in the mosque) during these nights, standing in prayer until dawn. A single night of worship surpasses 83 years of continuous worship.',
  ),
  (9, 25): _Entry(
    name: 'Seek Laylat al-Qadr',
    description:
        'Among the odd nights in which Laylat al-Qadr is most likely. The Prophet ﷺ said: "Search for Laylat al-Qadr in the odd nights of the last ten nights of Ramadan." (Bukhari). Do not let this night pass without prayer, du\'a, and Quran.',
  ),
  (9, 27): _Entry(
    name: "Laylat al-Qadr",
    description:
        'Widely regarded as the most likely night for Laylat al-Qadr. The Prophet ﷺ said: "Whoever stands in prayer on Laylat al-Qadr out of faith and seeking reward, his previous sins will be forgiven." (Bukhari). Perform abundant prayer, du\'a, Quran, and dhikr. Recite: "Allahumma innaka \'Afuwwun tuhibbul \'afwa fa\'fu \'anni."',
  ),
  (9, 29): _Entry(
    name: 'Seek Laylat al-Qadr',
    description:
        'Among the odd nights in the last ten days of Ramadan where Laylat al-Qadr may fall. The Prophet ﷺ said it is to be sought among the odd nights — do not miss the opportunity for this immense blessing.',
  ),
  (10, 1): _Entry(
    name: 'Eid al-Fitr',
    description:
        'The Festival of Breaking the Fast — a day of joy, gratitude, and community. Zakat al-Fitr must be given before the Eid prayer. Begin the day with Ghusl, your best clothing, eating something before prayer, and reciting Takbeer. It is FORBIDDEN to fast on Eid al-Fitr.',
    isHoliday: true,
  ),
  (12, 1): _Entry(
    name: 'First 10 Days of Dhul Hijja',
    description:
        'The most virtuous days of the entire year begin today. The Prophet ﷺ said: "No good deeds are more beloved to Allah than those done in these ten days." (Bukhari). Increase Takbeer (Allahu Akbar), Tahleel (La ilaha ill Allah), Tahmeed (Alhamdulillah), charity, and Quran. Fasting all nine days before Arafah is highly recommended.',
    isFast: true,
  ),
  (12, 9): _Entry(
    name: 'Day of Arafah',
    description:
        'The pinnacle of Hajj and one of the greatest days of the year. The Prophet ﷺ said: "Fasting on the Day of Arafah expiates the sins of the previous year and the coming year." (Muslim). For those not performing Hajj, fasting this day is one of the greatest Sunnah acts. Pilgrims stand on the plains of Arafah in one of Islam\'s most powerful moments of collective supplication.',
    isFast: true,
  ),
  (12, 10): _Entry(
    name: 'Eid al-Adha',
    description:
        'The Festival of Sacrifice — the greater of the two Eids. Muslims who are able perform Qurbani (animal sacrifice) in remembrance of Ibrahim\'s (AS) willingness to sacrifice his son Ismail (AS), and Allah\'s mercy in sending a ram in his place. Begin the day with Ghusl and Eid prayer before slaughtering. It is FORBIDDEN to fast on Eid al-Adha.',
    isHoliday: true,
  ),
  (12, 11): _Entry(
    name: 'Days of Tashreeq Begin',
    description:
        'The Days of Tashreeq (11, 12, and 13 Dhul Hijja) are sacred days of eating, drinking, and remembrance of Allah. The Prophet ﷺ said: "The days of Tashreeq are days of eating, drinking, and remembrance of Allah." (Muslim). Pilgrims spend these nights in Mina. It is FORBIDDEN to fast on any of the three Days of Tashreeq.',
    isHoliday: true,
  ),
  (12, 12): _Entry(
    name: 'Day of Tashreeq',
    description:
        'The second Day of Tashreeq — days of celebration, gratitude, and dhikr. Pilgrims who chose to depart early (Nafr al-Awwal) left Mina yesterday; those remaining complete their stay. Fasting is FORBIDDEN on the Days of Tashreeq.',
    isHoliday: true,
  ),
  (12, 13): _Entry(
    name: 'Last Day of Tashreeq',
    description:
        'The final Day of Tashreeq and the last day of the Hajj season. Pilgrims complete their final stoning and depart Mina. Fasting is FORBIDDEN today. After this, the sacred season of Dhul Hijja concludes.',
    isHoliday: true,
  ),
};

_Entry? _rangedEntry(int hm, int hd) {
  // Ayyam al-Bidh — 13th, 14th, 15th of every month
  if (hd == 13 || hd == 14 || hd == 15) {
    return const _Entry(
      name: 'Ayyam al-Bidh',
      description:
          "The three 'white days' of every lunar month, named because the full moon illuminates the night. The Prophet ﷺ used to fast these three days every month. He said: 'Fasting three days of every month is like fasting the whole year.' (Bukhari & Muslim). The reward is as if one fasted perpetually without hardship.",
      isFast: true,
    );
  }
  // Dhul Hijja days 2–8 (day 1 and day 9 are in fixed map)
  if (hm == 12 && hd >= 2 && hd <= 8) {
    return const _Entry(
      name: 'First 10 Days of Dhul Hijja',
      description:
          "Among the most virtuous days of the year. The Prophet ﷺ said: 'No good deeds are more beloved to Allah than those done in these ten days.' (Bukhari). Fasting is highly recommended alongside increasing Takbeer, charity, and Quran recitation.",
      isFast: true,
    );
  }
  // 6 days of Shawwal — days 2–7 (day 1 is Eid in fixed map)
  if (hm == 10 && hd >= 2 && hd <= 7) {
    return const _Entry(
      name: '6 Days of Shawwal',
      description:
          "The Prophet ﷺ said: 'Whoever fasts Ramadan and follows it with six days from Shawwal, it is as if he has fasted the whole year.' (Muslim). Fasting these six days immediately after Eid is a powerful Sunnah that earns the reward of a full year of fasting.",
      isFast: true,
    );
  }
  return null;
}

_Entry? getEntry(int hm, int hd) =>
    _fixedDates[(hm, hd)] ?? _rangedEntry(hm, hd);

// ─────────────────────────────────────────────────────────────
// Static labels
// ─────────────────────────────────────────────────────────────

const List<String> _hijriMonths = [
  'Muharram',
  'Safar',
  "Rabi' al-Awwal",
  "Rabi' al-Thani",
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhul Qa'da",
  'Dhul Hijja',
];

const List<String> _hijriMonthsAr = [
  'مُحَرَّم',
  'صَفَر',
  'رَبيع الأوَّل',
  'رَبيع الثَّاني',
  'جُمَادَى الأولَى',
  'جُمَادَى الثَّانِيَة',
  'رَجَب',
  'شَعْبَان',
  'رَمَضَان',
  'شَوَّال',
  'ذُو القَعْدَة',
  'ذُو الحِجَّة',
];

const List<String> _gregorianMonths = [
  '',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────

class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  late DateTime _viewMonth;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _viewMonth = DateTime(_today.year, _today.month, 1);
  }

  void _prev() => setState(() =>
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1));
  void _next() => setState(() =>
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1));
  void _goToday() =>
      setState(() => _viewMonth = DateTime(_today.year, _today.month, 1));

  List<DateTime?> _gridDays() {
    final firstWeekday = _viewMonth.weekday % 7;
    final daysInMonth =
        DateUtils.getDaysInMonth(_viewMonth.year, _viewMonth.month);
    final cells = <DateTime?>[];
    for (int i = 0; i < firstWeekday; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_viewMonth.year, _viewMonth.month, d));
    }
    while (cells.length % 7 != 0) cells.add(null);
    return cells;
  }

  List<({int day, _Entry entry, HijriDate hijri})> _monthEntries() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_viewMonth.year, _viewMonth.month);
    final list = <({int day, _Entry entry, HijriDate hijri})>[];
    final seen = <String>{};
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_viewMonth.year, _viewMonth.month, d);
      final h = gregorianToHijri(date);
      final entry = getEntry(h.month, h.day);
      if (entry != null && !seen.contains(entry.name)) {
        seen.add(entry.name);
        list.add((day: d, entry: entry, hijri: h));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textColor = c.isLight ? c.scaffold : Colors.white;
    final today = _today;
    final cells = _gridDays();
    final entries = _monthEntries();

    final h1 = gregorianToHijri(_viewMonth);
    final lastDay = DateTime(_viewMonth.year, _viewMonth.month + 1, 0);
    final h2 = gregorianToHijri(lastDay);
    final hijriHeader = h1.month == h2.month
        ? '${_hijriMonths[h1.month - 1]} ${h1.year} AH'
        : '${_hijriMonths[h1.month - 1]} – ${_hijriMonths[h2.month - 1]} ${h1.year} AH';

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.scaffold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Islamic Calendar',
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
        actions: [
          TextButton(
            onPressed: _goToday,
            child: Text(
              'Today',
              style: GoogleFonts.poppins(
                  color: c.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── Calendar card ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: c.accent.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                // Month navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: c.accent),
                      onPressed: _prev,
                    ),
                    Column(
                      children: [
                        Text(
                          '${_gregorianMonths[_viewMonth.month]} ${_viewMonth.year}',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          hijriHeader,
                          style: GoogleFonts.poppins(
                            color: c.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: c.accent),
                      onPressed: _next,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Day-of-week headers
                Row(
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .asMap()
                      .entries
                      .map((e) => Expanded(
                            child: Text(
                              e.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: e.key == 5
                                    ? c.accent
                                    : textColor.withValues(alpha: 0.45),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: cells.length,
                  itemBuilder: (ctx, i) {
                    final date = cells[i];
                    if (date == null) return const SizedBox();
                    final h = gregorianToHijri(date);
                    final isToday = date.year == today.year &&
                        date.month == today.month &&
                        date.day == today.day;
                    final isFriday = date.weekday == DateTime.friday;
                    final entry = getEntry(h.month, h.day);
                    final isFast = entry?.isFast ?? false;
                    final isHoliday = entry?.isHoliday ?? false;
                    final hasEntry = entry != null;

                    return GestureDetector(
                      onTap: hasEntry
                          ? () => _showSheet(context, c, textColor, date, h, entry)
                          : null,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isToday
                              ? c.accent
                              : isFriday
                                  ? c.accent.withValues(alpha: 0.07)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isFast && !isToday
                              ? Border.all(
                                  color: c.accent.withValues(alpha: 0.35),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: isToday
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isToday
                                    ? c.scaffold
                                    : isFriday
                                        ? c.accent
                                        : textColor,
                              ),
                            ),
                            Text(
                              '${h.day}',
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: isToday
                                    ? c.scaffold.withValues(alpha: 0.7)
                                    : textColor.withValues(alpha: 0.4),
                              ),
                            ),
                            if (hasEntry)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: isFast ? 5 : 4,
                                    height: isFast ? 5 : 4,
                                    decoration: BoxDecoration(
                                      color: isToday
                                          ? c.scaffold
                                          : isHoliday
                                              ? c.accent.withValues(alpha: 0.5)
                                              : c.accent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (isFast) ...[
                                    const SizedBox(width: 2),
                                    Text(
                                      '☽',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color: isToday
                                            ? c.scaffold
                                            : c.accent,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Legend ──
          _Legend(c: c, textColor: textColor),
          const SizedBox(height: 16),

          // ── Events this month ──
          if (entries.isNotEmpty) ...[
            Text(
              'THIS MONTH',
              style: GoogleFonts.poppins(
                color: c.accentLight.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            ...entries.map((ev) => _EventCard(
                  day: ev.day,
                  entry: ev.entry,
                  hijri: ev.hijri,
                  c: c,
                  textColor: textColor,
                  onTap: () => _showSheet(
                    context,
                    c,
                    textColor,
                    DateTime(_viewMonth.year, _viewMonth.month, ev.day),
                    ev.hijri,
                    ev.entry,
                  ),
                )),
            const SizedBox(height: 8),
          ],

          // ── Sunnah Fasts card ──
          _SunnahFastsCard(c: c, textColor: textColor),
          const SizedBox(height: 12),

          // ── Hijri month names ──
          _HijriMonthsCard(c: c, textColor: textColor),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, dynamic c, Color textColor,
      DateTime date, HijriDate h, _Entry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Type badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (entry.isFast)
                  _Badge(label: 'Recommended Fast', icon: Icons.bedtime_outlined, c: c),
                if (entry.isHoliday)
                  _Badge(label: 'Fasting Forbidden', icon: Icons.block_outlined, c: c),
              ],
            ),
            if (entry.isFast || entry.isHoliday) const SizedBox(height: 12),
            Text(
              entry.name,
              style: GoogleFonts.poppins(
                color: c.accent,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${_gregorianMonths[date.month]} ${date.day}, ${date.year}',
              style: GoogleFonts.poppins(
                color: textColor.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${h.day} ${_hijriMonthsAr[h.month - 1]} ${h.year} هـ',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                color: c.accentLight,
                fontSize: 16,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.accent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.accent.withValues(alpha: 0.15)),
              ),
              child: Text(
                entry.description,
                style: GoogleFonts.poppins(
                  color: textColor.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;
  final dynamic c;
  const _Badge({required this.label, required this.icon, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: c.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: c.accent, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: c.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Event card (in the "This Month" section)
// ─────────────────────────────────────────────────────────────

class _EventCard extends StatefulWidget {
  final int day;
  final _Entry entry;
  final HijriDate hijri;
  final dynamic c;
  final Color textColor;
  final VoidCallback onTap;
  const _EventCard({
    required this.day,
    required this.entry,
    required this.hijri,
    required this.c,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final entry = widget.entry;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? c.accent.withValues(alpha: 0.35)
                : c.accent.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: entry.isFast
                          ? const Text('☽',
                              style: TextStyle(fontSize: 16))
                          : entry.isHoliday
                              ? Icon(Icons.star_outline,
                                  color: c.accent, size: 18)
                              : Text(
                                  '${widget.day}',
                                  style: GoogleFonts.poppins(
                                    color: c.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: GoogleFonts.poppins(
                            color: widget.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${widget.hijri.day} ${_hijriMonths[widget.hijri.month - 1]}'
                          '${entry.isFast ? '  •  Fast Recommended' : entry.isHoliday ? '  •  Fasting Forbidden' : ''}',
                          style: GoogleFonts.poppins(
                            color: c.accent,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: c.accent,
                    size: 18,
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: c.accent.withValues(alpha: 0.12)),
                ),
                child: Text(
                  entry.description,
                  style: GoogleFonts.poppins(
                    color: widget.textColor.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.65,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Legend
// ─────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final dynamic c;
  final Color textColor;
  const _Legend({required this.c, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        _LegendItem(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: c.accent, borderRadius: BorderRadius.circular(4)),
          ),
          label: 'Today',
          textColor: textColor,
          c: c,
        ),
        _LegendItem(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: c.accent.withValues(alpha: 0.3)),
            ),
          ),
          label: 'Friday',
          textColor: textColor,
          c: c,
        ),
        _LegendItem(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: c.accent.withValues(alpha: 0.35)),
            ),
            child: Center(
              child: Text('☽',
                  style: TextStyle(fontSize: 10, color: c.accent)),
            ),
          ),
          label: 'Fast',
          textColor: textColor,
          c: c,
        ),
        _LegendItem(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: c.accent, shape: BoxShape.circle),
              ),
            ],
          ),
          label: 'Event',
          textColor: textColor,
          c: c,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Widget child;
  final String label;
  final Color textColor;
  final dynamic c;
  const _LegendItem(
      {required this.child,
      required this.label,
      required this.textColor,
      required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.poppins(
                color: textColor.withValues(alpha: 0.5), fontSize: 11)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sunnah Fasts card
// ─────────────────────────────────────────────────────────────

class _FastEntry {
  final String title;
  final String timing;
  final String description;
  final String virtue;
  const _FastEntry({
    required this.title,
    required this.timing,
    required this.description,
    required this.virtue,
  });
}

const _sunnahFasts = [
  _FastEntry(
    title: 'Ramadan',
    timing: 'All of Ramadan — Obligatory',
    description:
        'Fasting the entire month of Ramadan is one of the Five Pillars of Islam, obligatory on every sane, healthy adult Muslim. Abstaining from food, drink, and intimacy from Fajr to Maghrib while increasing worship, Quran, and charity.',
    virtue:
        '"Whoever fasts Ramadan out of faith and seeking reward, his previous sins will be forgiven." — Prophet ﷺ (Bukhari & Muslim)',
  ),
  _FastEntry(
    title: '6 Days of Shawwal',
    timing: 'Shawwal 2–7 (after Eid al-Fitr)',
    description:
        'Fasting six voluntary days in the month following Ramadan earns the reward of a full year of fasting. They can be fasted consecutively or spread across the month, but should be completed before Shawwal ends.',
    virtue:
        '"Whoever fasts Ramadan and follows it with six days of Shawwal, it is as if he fasted the whole year." — Prophet ﷺ (Muslim)',
  ),
  _FastEntry(
    title: 'Day of Arafah',
    timing: 'Dhul Hijja 9 — for non-pilgrims',
    description:
        'The greatest voluntary fast of the year, observed on the day pilgrims stand on the plain of Arafah. For those not performing Hajj, fasting this day expiates two full years of minor sins.',
    virtue:
        '"Fasting on the Day of Arafah expiates the sins of the previous year and the coming year." — Prophet ﷺ (Muslim)',
  ),
  _FastEntry(
    title: "Ashura & Tasu'a",
    timing: 'Muharram 9 & 10',
    description:
        'Fasting Ashura (10 Muharram) expiates the previous year\'s sins. It is also Sunnah to fast Tasu\'a (9 Muharram) alongside it, to distinguish from the Jewish practice of fasting only on the 10th. Fasting both days is highly recommended.',
    virtue:
        '"Fasting the Day of Ashura expiates the sins of the previous year." — Prophet ﷺ (Muslim)',
  ),
  _FastEntry(
    title: 'First 9 Days of Dhul Hijja',
    timing: 'Dhul Hijja 1–9',
    description:
        'The ten days of Dhul Hijja are the most virtuous days of the year. Fasting all nine (the tenth is Eid al-Adha, when fasting is forbidden) is highly recommended. At minimum, fasting the Day of Arafah (9th) is strongly encouraged.',
    virtue:
        '"No good deeds are more beloved to Allah than those done in these ten days." — Prophet ﷺ (Bukhari)',
  ),
  _FastEntry(
    title: 'Ayyam al-Bidh',
    timing: '13th, 14th & 15th of every month',
    description:
        'The three "white days" of every lunar month, named because the full moon illuminates the night. Fasting these three days each month carries a reward equivalent to fasting the entire year, since each good deed is multiplied tenfold.',
    virtue:
        '"Fasting three days of every month is like fasting forever." — Prophet ﷺ (Bukhari & Muslim)',
  ),
  _FastEntry(
    title: 'Mondays & Thursdays',
    timing: 'Every week',
    description:
        'The Prophet ﷺ regularly fasted on Mondays and Thursdays. He explained that deeds are presented to Allah on these two days, and he loved for his deeds to be presented while he was fasting. Both days also hold special significance: the Prophet ﷺ was born on a Monday.',
    virtue:
        '"Deeds are presented on Mondays and Thursdays, and I love for my deeds to be presented while I am fasting." — Prophet ﷺ (Tirmidhi)',
  ),
  _FastEntry(
    title: "Fast of Dawud (AS)",
    timing: 'Alternate days (advanced practice)',
    description:
        'The most complete form of voluntary fasting: fasting one day and eating the next. Named after Prophet Dawud (AS) who observed this throughout his life. The Prophet ﷺ described this as the most beloved fast to Allah, but also cautioned that one should not fast more than this.',
    virtue:
        '"The most beloved fast to Allah is the fast of Dawud — he fasted one day and ate the next." — Prophet ﷺ (Bukhari & Muslim)',
  ),
];

class _SunnahFastsCard extends StatefulWidget {
  final dynamic c;
  final Color textColor;
  const _SunnahFastsCard({required this.c, required this.textColor});

  @override
  State<_SunnahFastsCard> createState() => _SunnahFastsCardState();
}

class _SunnahFastsCardState extends State<_SunnahFastsCard> {
  bool _expanded = false;
  int? _openIndex;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return GestureDetector(
      onTap: () => setState(() {
        _expanded = !_expanded;
        if (!_expanded) _openIndex = null;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? c.accent.withValues(alpha: 0.35)
                : c.accent.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.bedtime_outlined, color: c.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sunnah Fasting Guide',
                          style: GoogleFonts.poppins(
                            color: c.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Days to fast & their virtues',
                          style: GoogleFonts.poppins(
                            color: widget.textColor.withValues(alpha: 0.45),
                            fontSize: 11,
                          ),
                        ),
                      ],
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
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: _sunnahFasts.asMap().entries.map((e) {
                    final idx = e.key;
                    final fast = e.value;
                    final isOpen = _openIndex == idx;
                    return GestureDetector(
                      onTap: () => setState(
                          () => _openIndex = isOpen ? null : idx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: c.scaffold.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isOpen
                                ? c.accent.withValues(alpha: 0.4)
                                : c.accent.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fast.title,
                                          style: GoogleFonts.poppins(
                                            color:
                                                widget.textColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          fast.timing,
                                          style: GoogleFonts.poppins(
                                            color: c.accent,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isOpen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: c.accent,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            if (isOpen) ...[
                              Divider(
                                  height: 1,
                                  color:
                                      c.accent.withValues(alpha: 0.1)),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fast.description,
                                      style: GoogleFonts.poppins(
                                        color: widget.textColor
                                            .withValues(alpha: 0.75),
                                        fontSize: 12,
                                        height: 1.65,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: c.accent
                                            .withValues(alpha: 0.07),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border(
                                          left: BorderSide(
                                              color: c.accent, width: 3),
                                        ),
                                      ),
                                      child: Text(
                                        fast.virtue,
                                        style: GoogleFonts.poppins(
                                          color: widget.textColor
                                              .withValues(alpha: 0.65),
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hijri month names card
// ─────────────────────────────────────────────────────────────

class _HijriMonthsCard extends StatefulWidget {
  final dynamic c;
  final Color textColor;
  const _HijriMonthsCard({required this.c, required this.textColor});

  @override
  State<_HijriMonthsCard> createState() => _HijriMonthsCardState();
}

class _HijriMonthsCardState extends State<_HijriMonthsCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.accent.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined,
                      color: c.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hijri Month Names',
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
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: List.generate(
                    12,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text(
                              '${i + 1}.',
                              style: GoogleFonts.poppins(
                                color: c.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _hijriMonths[i],
                              style: GoogleFonts.poppins(
                                color: widget.textColor
                                    .withValues(alpha: 0.75),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            _hijriMonthsAr[i],
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              color: c.accent,
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
