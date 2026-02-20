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

  static Future<void> schedulePrayerNotifications({
    required List<PrayerNotificationEntry> entries,
    required bool adhanEnabled,
    required bool reminderEnabled,
  }) async {
    await _plugin.cancelAll();
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
        );
      }

      if (reminderEnabled) {
        final reminder =
            entry.localTime.subtract(const Duration(minutes: 30));
        if (reminder.isAfter(now)) {
          await _schedule(
            id: id++,
            title: '${entry.prayerName} in 30 minutes',
            body: '${entry.prayerName} at ${_formatTime(entry.localTime)}',
            localTime: reminder,
          );
        }
      }

      if (id >= 60) break;
    }
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime localTime,
  }) async {
    final utc = localTime.toUtc();
    final tzAt = tz.TZDateTime(
        tz.UTC, utc.year, utc.month, utc.day, utc.hour, utc.minute);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzAt,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
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
