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
import '../services/location_cache.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/prayer_time_service.dart';
import '../utils/rate_limiter.dart';
import '../widgets/crescent_decoration.dart';
import '../widgets/error_view.dart';
import '../widgets/hijri_date_header.dart';
import '../widgets/islamic_ornament.dart';
import '../widgets/next_prayer_banner.dart';
import '../widgets/prayer_card.dart';
import '../widgets/qibla_compass.dart';
import 'duas_screen.dart';
import 'guides_screen.dart';
import 'streak_screen.dart';
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
  DateTime? _nextTargetTime;
  Timer? _countdownTimer;
  double? _latitude;
  double? _longitude;
  String? _locationName;
  AppSettings? _settingsListener;

  static const _cacheKey = 'cachedPrayerTimes';
  static const _widgetChannel = MethodChannel('fajr.widget');
  static const _liveChannel = MethodChannel('fajr.live_activity');

  // Throttles pull-to-refresh so the user can't spam Aladhan from one device.
  final RateLimiter _refreshLimiter = RateLimiter();
  static const Duration _minRefreshInterval = Duration(seconds: 15);

  // Called on launch — if the device rebooted and cleared scheduled notifications,
  // the background fetch handler in AppDelegate sets a flag. We pick it up here
  // and force a full reschedule by clearing the date cache so _loadPrayerTimes
  // performs a fresh fetch and schedules new notifications.
  Future<void> _checkNotificationReschedule() async {
    try {
      final needs = await _widgetChannel.invokeMethod<bool>('needsReschedule') ?? false;
      if (needs) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('cachedDate'); // forces fresh fetch + notification reschedule
      }
    } catch (_) {}
  }

  Future<void> _endLiveActivity() async {
    try {
      await _liveChannel.invokeMethod('end');
    } catch (_) {}
  }

  Future<void> _updateLiveActivity(PrayerTimesResponse pt) async {
    if (!mounted || !context.settings.liveActivityEnabled) return;
    try {
      final prayers = pt.timings.dailyPrayers;
      final now = DateTime.now();
      PrayerEntry? next;
      for (final p in prayers) {
        if (p.todayDateTime.isAfter(now)) { next = p; break; }
      }
      if (next == null) return; // all prayers passed today
      final icon = switch (next.name) {
        'Fajr'    => 'moon.stars.fill',
        'Sunrise' => 'sunrise.fill',
        'Dhuhr'   => 'sun.max.fill',
        'Asr'     => 'sun.haze.fill',
        'Maghrib' => 'sunset.fill',
        'Isha'    => 'moon.fill',
        _         => 'clock.fill',
      };
      // Format 24h time to 12h display
      final parts = next.time.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final suffix = h >= 12 ? 'PM' : 'AM';
      final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      final displayTime = '$h12:${m.toString().padLeft(2, '0')} $suffix';

      final args = {
        'prayerName': next.name,
        'prayerTime': displayTime,
        'prayerEpoch': next.todayDateTime.millisecondsSinceEpoch,
        'prayerIcon': icon,
      };
      await _liveChannel.invokeMethod('start', args);
    } catch (_) {}
  }

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
        'hijriDay': pt.date.hijriDay,
        'hijriMonth': pt.date.hijriMonthEn,
        'hijriYear': pt.date.hijriYear,
      });
    } catch (_) {}
  }

  // Preload the next 7 days of prayer times into the widget's data store.
  // The Swift widget uses these to build a longer timeline so it stays
  // accurate even if iOS doesn't run the app for several days.
  Future<void> _prefetchWeekAhead(double lat, double lng, int method) async {
    // Throttle: at most one calendar fetch per hour. Today's prayer-time
    // fetch is already gated by the same-day cache; this guard prevents
    // rapid app foreground/background cycles from re-fetching the whole
    // month repeatedly.
    if (!_refreshLimiter.tryAcquire('prefetch_week', const Duration(hours: 1))) {
      return;
    }
    try {
      final now = DateTime.now();
      final months = <int, List<PrayerTimesResponse>>{};
      // Always need this month; fetch next month too if we'll cross the boundary.
      months[now.month] = await _prayerTimeService.fetchMonth(
        latitude: lat, longitude: lng, method: method,
        year: now.year, month: now.month,
      );
      final weekEnd = now.add(const Duration(days: 7));
      if (weekEnd.month != now.month) {
        months[weekEnd.month] = await _prayerTimeService.fetchMonth(
          latitude: lat, longitude: lng, method: method,
          year: weekEnd.year, month: weekEnd.month,
        );
      }

      final weekPrayers = <Map<String, dynamic>>[];
      for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
        final date = now.add(Duration(days: dayOffset));
        final monthData = months[date.month];
        if (monthData == null || date.day > monthData.length) continue;
        final pt = monthData[date.day - 1];
        for (final p in pt.timings.dailyPrayers) {
          final parts = p.time.split(':');
          if (parts.length < 2) continue;
          final dt = DateTime(date.year, date.month, date.day,
              int.parse(parts[0]), int.parse(parts[1]));
          weekPrayers.add({
            'name': p.name,
            'time': p.time,
            'epoch': dt.millisecondsSinceEpoch,
          });
        }
      }
      if (weekPrayers.isEmpty) return;
      await _widgetChannel.invokeMethod('updateWidgetWeek', {
        'weekPrayers': jsonEncode(weekPrayers),
      });
    } catch (_) {
      // Non-fatal — widget falls back to today's data.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPrayerTimes();
    _checkNotificationReschedule();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.settings;
    if (_settingsListener != settings) {
      _settingsListener?.removeListener(_onSettingsChanged);
      _settingsListener = settings;
      settings.addListener(_onSettingsChanged);
      _lastPrayerMethod = settings.prayerMethod;
      _lastLiveActivity = settings.liveActivityEnabled;
    }
  }

  int _lastPrayerMethod = -1;
  bool? _lastLiveActivity;
  Timer? _rescheduleDebounce;

  void _onSettingsChanged() {
    final settings = context.settings;
    final pt = _prayerTimes;

    // Debounce notification rescheduling — multiple toggles in the
    // settings sheet would otherwise fire _scheduleNotifications once per
    // toggle. Coalesce into a single call 400 ms after the last change.
    if (pt != null) {
      _rescheduleDebounce?.cancel();
      _rescheduleDebounce = Timer(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        final latest = _prayerTimes;
        if (latest != null) _scheduleNotifications(latest);
      });
    }

    if (_lastPrayerMethod != -1 && settings.prayerMethod != _lastPrayerMethod) {
      _lastPrayerMethod = settings.prayerMethod;
      _loadPrayerTimes();
    }
    if (_lastLiveActivity != null && settings.liveActivityEnabled != _lastLiveActivity) {
      if (settings.liveActivityEnabled) {
        if (pt != null) _updateLiveActivity(pt);
      } else {
        _endLiveActivity();
      }
    }
    _lastLiveActivity = settings.liveActivityEnabled;
  }

  @override
  void dispose() {
    _settingsListener?.removeListener(_onSettingsChanged);
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _rescheduleDebounce?.cancel();
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
        final coords = await LocationCache.readCoords();
        _latitude = coords?.$1;
        _longitude = coords?.$2;
        _locationName = await LocationCache.readName();
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
          if (mounted) {
            setState(() {
              _latitude = pos.latitude;
              _longitude = pos.longitude;
            });
          }
          _updateLocationName(pos.latitude, pos.longitude);
          if (movedFar) _fetchFresh(prefs, today);
        }).catchError((_) {
          // GPS failed silently — retry after 30 seconds
          Future.delayed(const Duration(seconds: 30), () {
            if (mounted) _loadPrayerTimes();
          });
        });
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
    final method = context.settings.prayerMethod;
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
        method: method,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;

      if (!mounted) return;

      await Future.wait([
        prefs.setString(_cacheKey, jsonEncode(prayerTimes.toJson())),
        prefs.setString('cachedDate', today),
        LocationCache.writeCoords(position.latitude, position.longitude),
      ]);

      setState(() {
        _prayerTimes = prayerTimes;
        _isLoading = false;
      });

      _determineNextPrayer();
      _startCountdown();
      _scheduleNotifications(prayerTimes);
      _updateWidget(prayerTimes);
      _updateLiveActivity(prayerTimes);
      _updateLocationName(position.latitude, position.longitude);
      // Fire-and-forget — pre-populates the widget's 7-day timeline
      _prefetchWeekAhead(position.latitude, position.longitude, method);
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
      setState(() {
        _isLoading = false;
        _isServerUnavailable = e.transient;
        _errorMessage = e.transient ? null : e.message;
      });
      if (e.transient) {
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

  // Resolves a human-readable "City, Country" for the given coords and caches it
  // so users can tell which location the prayer times and Qibla are based on.
  Future<void> _updateLocationName(double lat, double lng) async {
    final name = await _locationService.getLocationName(lat, lng);
    if (name == null || !mounted || name == _locationName) return;
    setState(() => _locationName = name);
    await LocationCache.writeName(name);
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
      final coords = await LocationCache.readCoords();
      _latitude = coords?.$1;
      _longitude = coords?.$2;
      _locationName = await LocationCache.readName();
      if (!mounted) return false;
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

    int newIndex = 0;
    DateTime newTarget = prayers[0].todayDateTime.add(const Duration(days: 1));
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].todayDateTime.isAfter(now)) {
        newIndex = i;
        newTarget = prayers[i].todayDateTime;
        break;
      }
    }

    if (newIndex == _nextPrayerIndex && newTarget == _nextTargetTime) return;
    setState(() {
      _nextPrayerIndex = newIndex;
      _nextTargetTime = newTarget;
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

  // The banner has its own internal 1-second ticker for the countdown digits.
  // This timer only fires to detect a prayer transition (every ~30 s is plenty)
  // — _determineNextPrayer is a no-op until the index actually changes.
  void _startCountdown() {
    _countdownTimer?.cancel();
    var lastIndex = _nextPrayerIndex;
    _countdownTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_prayerTimes == null) return;
      _determineNextPrayer();
      if (_nextPrayerIndex != lastIndex) {
        lastIndex = _nextPrayerIndex;
        _updateLiveActivity(_prayerTimes!);
      }
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
    final s = context.strings;
    final errorText = _isServerUnavailable
        ? s.serviceUnavailable
        : (_isGenericError ? s.somethingWentWrong : _errorMessage ?? '');
    return ErrorView(
      message: errorText,
      icon: Icons.location_off,
      onRetry: _loadPrayerTimes,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 4),
      child: IslamicDivider(label: title),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final c = context.colors;
    final actions = [
      (Icons.menu_book_outlined, 'Guide', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidesScreen()))),
      (Icons.volunteer_activism, 'Dua', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DuasScreen()))),
      (Icons.grain, 'Tasbeeh', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbeehScreen()))),
      (Icons.mosque_outlined, 'Masjid', () => widget.onTabSwitch?.call(3)),
      (Icons.local_fire_department_outlined, 'Streaks', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StreakScreen()))),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: actions.map((a) {
          final (icon, label, onTap) = a;
          return GestureDetector(
            onTap: onTap,
            child: Container(
              width: 76,
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    final c = context.colors;
    final prayers = _prayerTimes!.timings.dailyPrayers;
    final nextPrayer = prayers[_nextPrayerIndex];

    return RefreshIndicator(
      onRefresh: () async {
        // Throttle: silently no-op if user pulled within the last 15 s.
        // RefreshIndicator still animates and dismisses on its own.
        if (!_refreshLimiter.tryAcquire('dashboard_refresh', _minRefreshInterval)) {
          return;
        }
        final prefs = await SharedPreferences.getInstance();
        final today = DateTime.now().toIso8601String().substring(0, 10);
        await _fetchFresh(prefs, today);
      },
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
                  IslamicOrnament(size: 7, color: c.accent),
                  const SizedBox(width: 10),
                  CrescentMoon(size: 28, color: c.accent),
                  const SizedBox(width: 10),
                  Text(
                    'Al-Manar',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(width: 10),
                  IslamicOrnament(size: 7, color: c.accent),
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
              targetTime: _nextTargetTime ?? nextPrayer.todayDateTime,
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
                locationName: _locationName,
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

