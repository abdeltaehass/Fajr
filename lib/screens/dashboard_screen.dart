import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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

  static const _cacheKey = 'cachedPrayerTimes';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPrayerTimes();
  }

  @override
  void dispose() {
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

      // Persist for offline use
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().substring(0, 10);
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

  Future<bool> _tryLoadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null || !mounted) return false;
      // If cache is from a previous day, don't use it — prayer times have changed.
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
      // GPS works without internet — fetch location in background for compass
      if (_latitude == null || _longitude == null) {
        _locationService.getCurrentPosition().then((pos) {
          if (!mounted) return;
          setState(() {
            _latitude = pos.latitude;
            _longitude = pos.longitude;
          });
        }).catchError((_) {});
      }
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
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CrescentMoon(size: 32, color: c.accent),
                const SizedBox(width: 12),
                Text(
                  'manār',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hijri date
            HijriDateHeader(date: _prayerTimes!.date),
            const SizedBox(height: 12),

            const SizedBox(height: 12),

            // Next prayer banner
            NextPrayerBanner(
              prayerName: nextPrayer.localizedName(context.strings),
              prayerTime: nextPrayer.time,
              timeRemaining: _timeUntilNext,
            ),
            const SizedBox(height: 24),

            // Prayer cards
            ...List.generate(prayers.length, (index) {
              return PrayerCard(
                prayer: prayers[index],
                isNext: index == _nextPrayerIndex,
              );
            }),
            const SizedBox(height: 24),

            // Qibla compass
            if (_latitude != null && _longitude != null)
              QiblaCompass(
                latitude: _latitude!,
                longitude: _longitude!,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

