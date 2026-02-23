import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'settings/app_settings.dart';
import 'settings/settings_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await initializeDateFormatting();
  await NotificationService.initialize();

  // Configure audio session for background playback (matches UIBackgroundModes: audio)
  await AudioPlayer.global.setAudioContext(AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: const {},
    ),
  ));
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
            title: 'Fajr',
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
