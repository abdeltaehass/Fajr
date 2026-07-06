import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:just_audio/just_audio.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'settings/app_settings.dart';
import 'settings/settings_provider.dart';
import 'services/notification_service.dart';
import 'services/quran_audio_handler.dart';

late QuranAudioHandler audioHandler;
final _adhanPlayer = AudioPlayer();

// Configure as a music app — playback category, no special options.
// Custom flags like `duckOthers` interfere with iOS's now-playing
// integration, which is what surfaces the Control Center / lock-screen
// controls. The .music() preset is what Apple expects for a media app.
Future<QuranAudioHandler> _initAudio() async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  return AudioService.init(
    builder: () => QuranAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.fajr.fajr.quran',
      androidNotificationChannelName: 'Quran Audio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // These four don't depend on each other, so overlap their platform-channel
  // round-trips instead of awaiting them one at a time — same guarantees
  // (everything ready before the first frame), shorter cold start.
  final results = await Future.wait<dynamic>([
    initializeDateFormatting(),
    NotificationService.initialize(),
    _initAudio(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);
  audioHandler = results[2] as QuranAudioHandler;

  // Handle adhan playback triggered by foreground notifications
  const MethodChannel('fajr.adhan').setMethodCallHandler((call) async {
    if (call.method == 'play') {
      final assetPath = call.arguments as String? ?? 'assets/audio/adhan_rabeh_ibn_darah.mp3';
      // Defensively pause any active Quran recitation through its handler
      // so the audio session state stays consistent. The handler's
      // interruption listener may or may not fire, but doing this
      // explicitly avoids the "Quran stuck in a weird state after adhan"
      // edge case.
      try {
        await audioHandler.pause();
      } catch (_) {}
      await _adhanPlayer.stop();
      await _adhanPlayer.setAsset(assetPath);
      await _adhanPlayer.play();
    }
    return null;
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const FajrApp());
}

class FajrApp extends StatefulWidget {
  const FajrApp({super.key});

  @override
  State<FajrApp> createState() => _FajrAppState();
}

class _FajrAppState extends State<FajrApp> {
  final AppSettings _settings = AppSettings();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _settings.loadSettings().then((_) async {
      if (_settings.athkarNotifEnabled.isNotEmpty) {
        await NotificationService.scheduleAthkarNotifications(
            _settings.athkarNotifEnabled);
      }
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF0D4A2E),
          body: const SizedBox.shrink(),
        ),
      );
    }

    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final colors = _settings.colors;
        final isLight = colors.isLight;

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        ));

        return SettingsProvider(
          settings: _settings,
          child: MaterialApp(
            title: 'Al-Manar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.fromColors(colors),
            locale: _settings.locale,
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
