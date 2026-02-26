import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerNotificationEntry {
  final String prayerName;
  final DateTime localTime;

  const PrayerNotificationEntry({
    required this.prayerName,
    required this.localTime,
  });
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(iOS: iosSettings);
    await _plugin.initialize(settings);
  }

  static Future<bool> requestPermissions() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();

  // Cancel only prayer notification IDs (0–59), leaving athkar IDs intact
  static Future<void> _cancelPrayerNotifications() async {
    for (int i = 0; i < 60; i++) {
      await _plugin.cancel(i);
    }
  }

  static Future<void> schedulePrayerNotifications({
    required List<PrayerNotificationEntry> entries,
    required bool adhanEnabled,
    required bool reminderEnabled,
    bool adhanSoundEnabled = false,
    int reminderMinutes = 10,
  }) async {
    await _cancelPrayerNotifications();
    if (!adhanEnabled && !reminderEnabled) return;

    final now = DateTime.now();
    int id = 0;

    for (final entry in entries) {
      if (id >= 60) break;

      if (adhanEnabled && entry.localTime.isAfter(now)) {
        await _schedule(
          id: id++,
          title: "It's time for ${entry.prayerName}",
          body: '${entry.prayerName} | ${_formatTime(entry.localTime)}',
          localTime: entry.localTime,
          useAdhanSound: adhanSoundEnabled,
        );
      }

      if (reminderEnabled) {
        final reminder =
            entry.localTime.subtract(Duration(minutes: reminderMinutes));
        if (reminder.isAfter(now)) {
          await _schedule(
            id: id++,
            title: '${entry.prayerName} in $reminderMinutes minutes',
            body: '${entry.prayerName} at ${_formatTime(entry.localTime)}',
            localTime: reminder,
          );
        }
      }

      if (id >= 60) break;
    }
  }

  static Future<void> scheduleAthkarNotifications(Set<String> enabled) async {
    // Athkar use IDs 200–203
    for (int i = 200; i <= 203; i++) {
      await _plugin.cancel(i);
    }

    const configs = [
      ('morning',    200, 'Morning Athkar',      'Time for Athkar Al-Sabah',       6,  0),
      ('evening',    201, 'Evening Athkar',       'Time for Athkar Al-Masa',        17, 0),
      ('afterPrayer',202, 'After Prayer Athkar',  "Time for Athkar Ba'd As-Salah",  13, 30),
      ('sleep',      203, 'Sleep Athkar',         'Time for Athkar An-Nawm',        22, 0),
    ];

    for (final (key, id, title, body, hour, minute) in configs) {
      if (!enabled.contains(key)) continue;
      await _scheduleDailyAthkar(
          id: id, title: title, body: body, hour: hour, minute: minute);
    }
  }

  static Future<void> _scheduleDailyAthkar({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Build target time in local wall-clock time, then convert to UTC so
    // the notification fires at the correct local hour regardless of timezone.
    final now = DateTime.now();
    var local = DateTime(now.year, now.month, now.day, hour, minute);
    if (local.isBefore(now)) {
      local = local.add(const Duration(days: 1));
    }
    final utc = local.toUtc();
    final tzScheduled =
        tz.TZDateTime(tz.UTC, utc.year, utc.month, utc.day, utc.hour, utc.minute);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduled,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime localTime,
    bool useAdhanSound = false,
  }) async {
    final utc = localTime.toUtc();
    final tzAt = tz.TZDateTime(
        tz.UTC, utc.year, utc.month, utc.day, utc.hour, utc.minute);
    final iosDetails = useAdhanSound
        ? const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'adhan.mp3',
          )
        : const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzAt,
      NotificationDetails(iOS: iosDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour > 12
        ? dt.hour - 12
        : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}
