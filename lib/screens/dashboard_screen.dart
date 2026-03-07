import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../settings/app_settings.dart';
import '../settings/settings_provider.dart';
import '../models/prayer_times.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/prayer_time_service.dart';
import '../widgets/crescent_decoration.dart';
import '../widgets/hijri_date_header.dart';
import '../widgets/next_prayer_banner.dart';
import '../widgets/prayer_card.dart';
import '../widgets/qibla_compass.dart';
import 'duas_screen.dart';
import 'guides_screen.dart';
import 'tasbeeh_screen.dart';

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSwitch;
  const DashboardScreen({super.key, this.onTabSwitch});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();

  bool _isLoading = true;
  String? _errorMessage;
  bool _isServerUnavailable = false;
  bool _isGenericError = false;
  PrayerTimesResponse? _prayerTimes;

  int _nextPrayerIndex = 0;
  Duration _timeUntilNext = Duration.zero;
  Timer? _countdownTimer;
  double? _latitude;
  double? _longitude;
  AppSettings? _settingsListener;

  static const _cacheKey = 'cachedPrayerTimes';
  static const _widgetChannel = MethodChannel('fajr.widget');

  Future<void> _updateWidget(PrayerTimesResponse pt) async {
    try {
      final prayers = pt.timings.dailyPrayers;
      final now = DateTime.now();
      PrayerEntry? next;
      for (final p in prayers) {
        if (p.todayDateTime.isAfter(now)) { next = p; break; }
      }
      next ??= prayers[0];
      final allPrayers = prayers.map((p) => {
        'name': p.name,
        'time': p.time,
        'epoch': p.todayDateTime.millisecondsSinceEpoch,
      }).toList();
      await _widgetChannel.invokeMethod('updateWidget', {
        'nextPrayer': next.name,
        'nextTime': next.time,
        'nextEpoch': next.todayDateTime.millisecondsSinceEpoch,
        'allPrayers': jsonEncode(allPrayers),
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPrayerTimes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.settings;
    if (_settingsListener != settings) {
      _settingsListener?.removeListener(_onSettingsChanged);
      _settingsListener = settings;
      settings.addListener(_onSettingsChanged);
    }
  }

  void _onSettingsChanged() {
    final pt = _prayerTimes;
    if (pt != null) _scheduleNotifications(pt);
  }

  @override
  void dispose() {
    _settingsListener?.removeListener(_onSettingsChanged);
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPrayerTimes();
    }
  }

  Future<void> _loadPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final cachedDate = prefs.getString('cachedDate') ?? '';
    final raw = prefs.getString(_cacheKey);

    // Same day + valid cache → serve instantly, no GPS, no API call
    if (cachedDate == today && raw != null) {
      try {
        final cached = PrayerTimesResponse.fromCached(
            jsonDecode(raw) as Map<String, dynamic>);
        _latitude = prefs.getDouble('cachedLat');
        _longitude = prefs.getDouble('cachedLng');
        if (!mounted) return;
        setState(() {
          _prayerTimes = cached;
          _isLoading = false;
          _errorMessage = null;
          _isServerUnavailable = false;
          _isGenericError = false;
        });
        _determineNextPrayer();
        _startCountdown();
        // Silently update GPS coords in background (for compass/qibla accuracy).
        // If the user has moved >50 km, fetch fresh prayer times for new location.
        _locationService.getCurrentPosition().then((pos) {
          if (!mounted) return;
          final movedFar = _distanceKm(
                _latitude ?? pos.latitude, _longitude ?? pos.longitude,
                pos.latitude, pos.longitude) >
            50.0;
          setState(() {
            _latitude = pos.latitude;
            _longitude = pos.longitude;
          });
          if (movedFar) _fetchFresh(prefs, today);
        }).catchError((_) {});
        return;
      } catch (_) {
        // Corrupt cache — fall through to full fetch
      }
    }

    // Different day or no cache — fetch fresh
    await _fetchFresh(prefs, today);
  }

  Future<void> _fetchFresh(SharedPreferences prefs, String today) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isServerUnavailable = false;
      _isGenericError = false;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      final prayerTimes = await _prayerTimeService.fetchPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;

      if (!mounted) return;

      await Future.wait([
        prefs.setString(_cacheKey, jsonEncode(prayerTimes.toJson())),
        prefs.setString('cachedDate', today),
        prefs.setDouble('cachedLat', position.latitude),
        prefs.setDouble('cachedLng', position.longitude),
      ]);

      setState(() {
        _prayerTimes = prayerTimes;
        _isLoading = false;
      });

      _determineNextPrayer();
      _startCountdown();
      _scheduleNotifications(prayerTimes);
      _updateWidget(prayerTimes);
    } on LocationServiceException catch (e) {
      if (!mounted) return;
      if (await _tryLoadCache()) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } on PrayerTimeServiceException catch (e) {
      if (!mounted) return;
      if (await _tryLoadCache()) return;
      final isServerError =
          e.message.contains('503') || e.message.contains('502');
      setState(() {
        _isLoading = false;
        _isServerUnavailable = isServerError;
        _errorMessage = isServerError ? null : e.message;
      });
      if (isServerError) {
        await Future.delayed(const Duration(seconds: 5));
        if (mounted) _loadPrayerTimes();
      }
    } catch (e) {
      if (!mounted) return;
      if (await _tryLoadCache()) return;
      setState(() {
        _isLoading = false;
        _isGenericError = true;
      });
    }
  }

  // Equirectangular approximation — accurate enough for a >50 km threshold check
  double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    const toRad = 3.141592653589793 / 180;
    final x = (lng2 - lng1) * toRad * cos((lat1 + lat2) / 2 * toRad);
    final y = (lat2 - lat1) * toRad;
    return r * sqrt(x * x + y * y);
  }

  Future<bool> _tryLoadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null || !mounted) return false;
      final cachedDate = prefs.getString('cachedDate') ?? '';
      final today = DateTime.now().toIso8601String().substring(0, 10);
      if (cachedDate != today) return false;
      final cached = PrayerTimesResponse.fromCached(
          jsonDecode(raw) as Map<String, dynamic>);
      _latitude = prefs.getDouble('cachedLat');
      _longitude = prefs.getDouble('cachedLng');
      setState(() {
        _prayerTimes = cached;
        _isLoading = false;
        _errorMessage = null;
      });
      _determineNextPrayer();
      _startCountdown();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _determineNextPrayer() {
    if (_prayerTimes == null) return;

    final prayers = _prayerTimes!.timings.dailyPrayers;
    final now = DateTime.now();

    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].todayDateTime.isAfter(now)) {
        setState(() {
          _nextPrayerIndex = i;
          _timeUntilNext = prayers[i].todayDateTime.difference(now);
        });
        return;
      }
    }

    // All prayers have passed — next is tomorrow's Fajr
    final tomorrowFajr = prayers[0].todayDateTime.add(const Duration(days: 1));
    setState(() {
      _nextPrayerIndex = 0;
      _timeUntilNext = tomorrowFajr.difference(now);
    });
  }

  void _scheduleNotifications(PrayerTimesResponse prayerTimes) {
    final settings = context.settings;

    if (!settings.adhanEnabled && !settings.reminderEnabled) {
      NotificationService.cancelAll();
    } else {
      final entries = prayerTimes.timings.dailyPrayers
          .where((p) => p.isPrayer)
          .map((p) => PrayerNotificationEntry(
                prayerName: p.name,
                localTime: p.todayDateTime,
              ))
          .toList();
      NotificationService.schedulePrayerNotifications(
        entries: entries,
        adhanEnabled: settings.adhanEnabled,
        adhanSoundEnabled: settings.adhanSoundEnabled,
        adhanSoundId: settings.adhanSoundId,
        reminderEnabled: settings.reminderEnabled,
        reminderMinutes: settings.reminderMinutes,
      );
    }

    // Sunrise & Tahajjud notifications
    final prayers = prayerTimes.timings.dailyPrayers;
    final fajrEntry = prayers.firstWhere((p) => p.name == 'Fajr');
    final sunriseEntry = prayers.firstWhere((p) => p.name == 'Sunrise');
    NotificationService.scheduleSunriseTahajjudNotifications(
      sunriseTime: sunriseEntry.todayDateTime,
      fajrTime: fajrEntry.todayDateTime,
      sunriseEnabled: settings.sunriseNotifEnabled,
      tahajjudEnabled: settings.tahajjudNotifEnabled,
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_prayerTimes == null) return;

      _determineNextPrayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? _buildLoadingState()
          : (_errorMessage != null || _isServerUnavailable || _isGenericError)
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CrescentMoon(size: 60, color: c.accent.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: c.accent),
          const SizedBox(height: 16),
          Text(
            context.strings.findingLocation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final c = context.colors;
    final s = context.strings;
    final errorText = _isServerUnavailable
        ? s.serviceUnavailable
        : (_isGenericError ? s.somethingWentWrong : _errorMessage ?? '');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: c.accentLight,
            ),
            const SizedBox(height: 16),
            Text(
              errorText,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPrayerTimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.scaffold,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.strings.retry,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 13,
            decoration: BoxDecoration(
              color: c.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              color: c.accent.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final c = context.colors;
    final actions = [
      (Icons.menu_book_outlined, 'Guide', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidesScreen()))),
      (Icons.volunteer_activism, 'Dua', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DuasScreen()))),
      (Icons.grain, 'Tasbeeh', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbeehScreen()))),
      (Icons.mosque_outlined, 'Masjid', () => widget.onTabSwitch?.call(3)),
    ];
    return Row(
      children: actions.map((a) {
        final (icon, label, onTap) = a;
        return Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [c.surface.withValues(alpha: 0.45), c.card],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.accent.withValues(alpha: 0.16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: c.accent, size: 23),
                  const SizedBox(height: 7),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: c.bodyText.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContent() {
    final c = context.colors;
    final prayers = _prayerTimes!.timings.dailyPrayers;
    final nextPrayer = prayers[_nextPrayerIndex];

    return RefreshIndicator(
      onRefresh: _loadPrayerTimes,
      color: c.accent,
      backgroundColor: c.card,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CrescentMoon(size: 28, color: c.accent),
                  const SizedBox(width: 10),
                  Text(
                    'Al-Manar',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Hijri date
            Center(child: HijriDateHeader(date: _prayerTimes!.date)),
            const SizedBox(height: 16),

            // Next prayer banner
            NextPrayerBanner(
              prayerName: nextPrayer.localizedName(context.strings),
              prayerTime: nextPrayer.time,
              timeRemaining: _timeUntilNext,
            ),
            const SizedBox(height: 22),

            // Quick Access section
            _buildSectionHeader('Quick Access'),
            _buildQuickActions(context),
            const SizedBox(height: 22),

            // Prayer Times section
            _buildSectionHeader('Prayer Times'),
            ...List.generate(prayers.length, (index) {
              return PrayerCard(
                prayer: prayers[index],
                isNext: index == _nextPrayerIndex,
              );
            }),
            const SizedBox(height: 22),

            // Qibla compass
            if (_latitude != null && _longitude != null) ...[
              _buildSectionHeader('Qibla'),
              QiblaCompass(
                latitude: _latitude!,
                longitude: _longitude!,
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

