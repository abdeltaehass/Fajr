import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settings/settings_provider.dart';
import '../models/iqama_times.dart';
import '../models/masjid.dart';
import '../models/prayer_times.dart';
import '../services/masjid_service.dart';
import '../services/prayer_time_service.dart';
import 'masjid_iqama_sheet.dart';

class MasjidDetailScreen extends StatefulWidget {
  final Masjid masjid;
  final MasjidService masjidService;

  const MasjidDetailScreen({
    super.key,
    required this.masjid,
    required this.masjidService,
  });

  @override
  State<MasjidDetailScreen> createState() => _MasjidDetailScreenState();
}

class _MasjidDetailScreenState extends State<MasjidDetailScreen> {
  late Masjid _masjid;
  bool _isLoadingDetails = true;
  final PrayerTimeService _prayerTimeService = PrayerTimeService();
  PrayerTimings? _prayerTimings;

  @override
  void initState() {
    super.initState();
    _masjid = widget.masjid;
    _loadDetails();
    _loadPrayerTimes();
  }

  Future<void> _loadDetails() async {
    try {
      final detailed = await widget.masjidService.getMasjidDetails(_masjid);
      if (!mounted) return;
      setState(() {
        _masjid = detailed;
        _isLoadingDetails = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final response = await _prayerTimeService.fetchPrayerTimes(
        latitude: _masjid.latitude,
        longitude: _masjid.longitude,
      );
      if (!mounted) return;
      setState(() {
        _prayerTimings = response.timings;
      });
    } catch (_) {
      // Prayer times are supplementary; fail silently
    }
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${_masjid.latitude},${_masjid.longitude}'
      '&destination_place_id=${_masjid.placeId}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhone() async {
    if (_masjid.phoneNumber == null) return;
    final uri = Uri.parse('tel:${_masjid.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWebsite() async {
    if (_masjid.website == null) return;
    final uri = Uri.parse(_masjid.website!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool get _isSelected =>
      context.settings.selectedMasjid?.placeId == _masjid.placeId;

  Widget _buildMyMasjidButton(dynamic c, dynamic s, Color textColor) {
    if (_isSelected) {
      return GestureDetector(
        onTap: () {
          context.settings.clearSelectedMasjid();
          setState(() {});
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: c.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                s.myMasjid,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '—',
                style: GoogleFonts.poppins(color: c.accent),
              ),
              const SizedBox(width: 4),
              Text(
                s.removeMyMasjid,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: c.accent.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        context.settings.setSelectedMasjid(_masjid);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_masjid.name} — ${s.myMasjidSet}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: c.card,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque, color: c.scaffold, size: 20),
            const SizedBox(width: 8),
            Text(
              s.setAsMyMasjid,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.scaffold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddEventSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddEventSheet(),
    ).then((_) => setState(() {}));
  }

  static String _to12h(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final period = h < 12 ? 'AM' : 'PM';
    final displayH = h % 12 == 0 ? 12 : h % 12;
    return '$displayH:${m.toString().padLeft(2, '0')} $period';
  }

  String _calcIqama(String raw24, int offsetMinutes) {
    final parts = raw24.split(':');
    if (parts.length < 2) return '';
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final total = h * 60 + m + offsetMinutes;
    final rawH = (total ~/ 60) % 24;
    final rawM = total % 60;
    final rounded = ((rawM + 2) ~/ 5) * 5;
    final carry = rounded ~/ 60;
    final finalH = (rawH + carry) % 24;
    final finalM = rounded % 60;
    final period = finalH < 12 ? 'AM' : 'PM';
    final displayH = finalH % 12 == 0 ? 12 : finalH % 12;
    return '$displayH:${finalM.toString().padLeft(2, '0')} $period';
  }

  TimeOfDay _roundTo5(TimeOfDay t) {
    final rounded = ((t.minute + 2) ~/ 5) * 5;
    final carry = rounded ~/ 60;
    return TimeOfDay(hour: (t.hour + carry) % 24, minute: rounded % 60);
  }

  TimeOfDay _parseTime12h(String text) {
    try {
      final parts = text.trim().split(' ');
      final hm = parts[0].split(':');
      int h = int.parse(hm[0]);
      final m = int.parse(hm[1]);
      if (parts.length > 1) {
        if (parts[1] == 'PM' && h != 12) h += 12;
        if (parts[1] == 'AM' && h == 12) h = 0;
      }
      return TimeOfDay(hour: h % 24, minute: m);
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  Future<void> _pickIqamaTime(String field, String currentValue) async {
    final initial =
        currentValue.isEmpty ? TimeOfDay.now() : _parseTime12h(currentValue);
    final picked =
        await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    final rounded = _roundTo5(picked);
    final timeStr = rounded.format(context);
    final existing = context.settings.iqamaTimes ?? const IqamaTimes();
    final updated = IqamaTimes(
      fajr: field == 'fajr' ? timeStr : existing.fajr,
      dhuhr: field == 'dhuhr' ? timeStr : existing.dhuhr,
      asr: field == 'asr' ? timeStr : existing.asr,
      maghrib: field == 'maghrib' ? timeStr : existing.maghrib,
      isha: field == 'isha' ? timeStr : existing.isha,
      jumuah: field == 'jumuah' ? timeStr : existing.jumuah,
    );
    await context.settings.setIqamaTimes(updated);
    setState(() {});
  }

  Widget _buildPrayerScheduleSection(dynamic c, dynamic s, Color textColor) {
    final pt = _prayerTimings;
    final iqama = context.settings.iqamaTimes;
    final showIqama = _isSelected;

    // Effective iqama: saved > auto-calc > ''
    final iqamaFajr = iqama?.fajr ?? '';
    final iqamaDhuhr = (iqama?.dhuhr.isNotEmpty ?? false)
        ? iqama!.dhuhr
        : (pt != null ? _calcIqama(pt.dhuhr, 60) : '');
    final iqamaAsr = (iqama?.asr.isNotEmpty ?? false)
        ? iqama!.asr
        : (pt != null ? _calcIqama(pt.asr, 25) : '');
    final iqamaMaghrib = iqama?.maghrib ?? '';
    final iqamaIsha = (iqama?.isha.isNotEmpty ?? false)
        ? iqama!.isha
        : (pt != null ? _calcIqama(pt.isha, 40) : '');
    final iqamaJumuah = iqama?.jumuah ?? '';

    // (label, adhan raw24 or null, field key, iqama value)
    final rows = <(String, String?, String, String)>[
      if (pt != null) ...[
        (s.prayerFajr, pt.fajr, 'fajr', iqamaFajr),
        (s.prayerDhuhr, pt.dhuhr, 'dhuhr', iqamaDhuhr),
        (s.prayerAsr, pt.asr, 'asr', iqamaAsr),
        (s.prayerMaghrib, pt.maghrib, 'maghrib', iqamaMaghrib),
        (s.prayerIsha, pt.isha, 'isha', iqamaIsha),
      ],
      if (showIqama) (s.jumuah, null, 'jumuah', iqamaJumuah),
    ];

    if (!showIqama && pt == null) return const SizedBox.shrink();

    return _DetailSection(
      icon: Icons.access_time_filled,
      title: s.masjidPrayerTimes,
      trailing: showIqama && iqama != null
          ? GestureDetector(
              onTap: () async {
                await context.settings.clearIqamaTimes();
                setState(() {});
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Reset',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: c.accent),
                ),
              ),
            )
          : null,
      child: pt == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child:
                    CircularProgressIndicator(color: c.accent, strokeWidth: 2),
              ),
            )
          : Column(
              children: [
                if (showIqama)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 90),
                        Expanded(
                          child: Text(
                            'Adhan',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 104,
                          child: Text(
                            'Iqama',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ...rows.map((row) {
                  final (label, adhan24, field, iqamaVal) = row;
                  final adhanStr =
                      adhan24 != null ? _to12h(adhan24) : '—';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            adhanStr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: adhan24 != null
                                  ? c.accent
                                  : textColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        if (showIqama)
                          GestureDetector(
                            onTap: () => _pickIqamaTime(field, iqamaVal),
                            child: Container(
                              width: 104,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.accent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: c.accent.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      iqamaVal.isEmpty ? 'Tap' : iqamaVal,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: iqamaVal.isEmpty
                                            ? textColor.withValues(alpha: 0.3)
                                            : c.accent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Icon(
                                    Icons.edit,
                                    size: 10,
                                    color: c.accent.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _buildEventsSection(dynamic c, dynamic s, Color textColor) {
    final events = context.settings.masjidEvents;
    final upcoming = events
        .where((e) => e.date.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
        .toList();

    return _DetailSection(
      icon: Icons.event,
      title: s.events,
      trailing: GestureDetector(
        onTap: _openAddEventSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: c.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            s.addEvent,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600, color: c.accent),
          ),
        ),
      ),
      child: upcoming.isEmpty
          ? Text(
              s.noEvents,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: textColor.withValues(alpha: 0.4)),
            )
          : Column(
              children: upcoming.map((event) {
                final d = event.date;
                final dateStr =
                    '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: c.accent,
                              ),
                            ),
                            if (event.description.isNotEmpty)
                              Text(
                                event.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: textColor.withValues(alpha: 0.5),
                                ),
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.settings.removeMasjidEvent(event.id);
                          setState(() {});
                        },
                        child: Icon(Icons.close,
                            size: 18,
                            color: textColor.withValues(alpha: 0.3)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Scaffold(
      backgroundColor: c.scaffold,
      body: CustomScrollView(
        slivers: [
          // App bar with photo
          SliverAppBar(
            expandedHeight: _masjid.photoReferences.isNotEmpty ? 220 : 120,
            pinned: true,
            backgroundColor: c.card,
            foregroundColor: textColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _masjid.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: _masjid.photoReferences.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.masjidService.getPhotoUrl(
                            _masjid.photoReferences.first,
                            maxWidth: 800,
                          ),
                          headers: const {'X-Ios-Bundle-Identifier': 'com.fajr.fajr'},
                          fit: BoxFit.cover,
                          cacheWidth: 800,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child;
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 300),
                              child: child,
                            );
                          },
                          errorBuilder: (_, e, st) => Container(
                            color: c.surface,
                            child: Icon(
                              Icons.mosque,
                              size: 64,
                              color: c.accent.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        // Gradient overlay for text readability
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                c.card.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: c.surface,
                      child: Icon(
                        Icons.mosque,
                        size: 64,
                        color: c.accent.withValues(alpha: 0.3),
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and status row
                  Row(
                    children: [
                      if (_masjid.rating != null) ...[
                        Icon(Icons.star, color: c.accent, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          _masjid.rating!.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: c.accent,
                          ),
                        ),
                        if (_masjid.userRatingsTotal != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${_masjid.userRatingsTotal})',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                        const SizedBox(width: 16),
                      ],
                      if (_masjid.openNow != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _masjid.openNow!
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _masjid.openNow! ? s.openNow : s.closed,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  _masjid.openNow! ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      if (_masjid.distanceKm != null) ...[
                        const Spacer(),
                        Icon(Icons.near_me, size: 16, color: c.accentLight),
                        const SizedBox(width: 4),
                        Text(
                          '${_masjid.distanceKm!.toStringAsFixed(1)} ${s.km}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: c.accentLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.directions,
                          label: s.getDirections,
                          color: c.accent,
                          onTap: _openMaps,
                        ),
                      ),
                      if (_masjid.phoneNumber != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.phone,
                            label: s.call,
                            color: Colors.green,
                            onTap: _callPhone,
                          ),
                        ),
                      ],
                      if (_masjid.website != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.language,
                            label: s.websiteLabel,
                            color: Colors.blue,
                            onTap: _openWebsite,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Set as My Masjid button
                  _buildMyMasjidButton(c, s, textColor),
                  const SizedBox(height: 16),

                  // Combined prayer schedule (adhan + iqama)
                  _buildPrayerScheduleSection(c, s, textColor),
                  const SizedBox(height: 16),

                  // Events (only when this is My Masjid)
                  if (_isSelected) ...[
                    _buildEventsSection(c, s, textColor),
                    const SizedBox(height: 16),
                  ],

                  // Address
                  if (_masjid.address != null) ...[
                    _DetailSection(
                      icon: Icons.location_on,
                      title: s.distance,
                      child: Text(
                        _masjid.address!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Phone
                  if (_masjid.phoneNumber != null) ...[
                    _DetailSection(
                      icon: Icons.phone,
                      title: s.call,
                      child: GestureDetector(
                        onTap: _callPhone,
                        child: Text(
                          _masjid.phoneNumber!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: c.accent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Website
                  if (_masjid.website != null) ...[
                    _DetailSection(
                      icon: Icons.language,
                      title: s.websiteLabel,
                      child: GestureDetector(
                        onTap: _openWebsite,
                        child: Text(
                          _masjid.website!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: c.accent,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Opening hours
                  if (_masjid.openingHours.isNotEmpty) ...[
                    _DetailSection(
                      icon: Icons.schedule,
                      title: s.openingHours,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _masjid.openingHours.map((hour) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              hour,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: textColor.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Loading indicator for details
                  if (_isLoadingDetails)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: c.accent,
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                  // No details message
                  if (!_isLoadingDetails &&
                      _masjid.phoneNumber == null &&
                      _masjid.website == null &&
                      _masjid.openingHours.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          s.noDetails,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: textColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.accent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
