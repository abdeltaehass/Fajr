import Flutter
import UIKit
import WidgetKit
import UserNotifications
import ActivityKit
import BackgroundTasks

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  // Stored so willPresent can trigger Flutter-side adhan playback
  private var adhanChannel: FlutterMethodChannel?

  // Identifier must match BGTaskSchedulerPermittedIdentifiers in Info.plist
  private static let bgRefreshTaskId = "com.fajr.fajr.refresh"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // Register the BGAppRefreshTask handler before super.application() returns.
    if #available(iOS 13.0, *) {
      BGTaskScheduler.shared.register(
        forTaskWithIdentifier: AppDelegate.bgRefreshTaskId,
        using: nil
      ) { task in
        self.handleAppRefresh(task: task as! BGAppRefreshTask)
      }
    }

    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // Wire adhan channel to main Flutter engine (window.rootViewController is set after super)
    if let controller = window?.rootViewController as? FlutterViewController {
      adhanChannel = FlutterMethodChannel(name: "fajr.adhan",
                                          binaryMessenger: controller.binaryMessenger)
    }
    return result
  }

  // ── BGAppRefreshTask scheduling ──────────────────────────────────────────
  // Schedule a refresh whenever the user backgrounds the app. iOS coalesces
  // requests, so calling this every backgrounding is fine — only one is queued.
  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
    if #available(iOS 13.0, *) { scheduleAppRefresh() }
  }

  @available(iOS 13.0, *)
  private func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: AppDelegate.bgRefreshTaskId)
    // Earliest 4 hours from now — iOS may delay further depending on usage.
    request.earliestBeginDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      // Submission can fail if the app isn't allowed background refresh.
      // Nothing to do — performFetch + foreground refresh remain as fallbacks.
    }
  }

  @available(iOS 13.0, *)
  private func handleAppRefresh(task: BGAppRefreshTask) {
    // Always queue the next refresh first so we keep getting woken up.
    scheduleAppRefresh()

    // The expirationHandler is called if iOS needs to terminate us early.
    task.expirationHandler = { task.setTaskCompleted(success: false) }

    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
      if requests.count < 3 {
        UserDefaults.standard.set(true, forKey: "needsNotificationReschedule")
      }
      task.setTaskCompleted(success: true)
    }
  }

  // ── Foreground notification interception ──────────────────────────────────
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // For adhan: play through Flutter/just_audio (correct audio session, no glitching)
    if notification.request.content.categoryIdentifier == "ADHAN",
       let channel = adhanChannel {
      let soundId = UserDefaults.standard.string(forKey: "flutter.adhanSoundId")
                    ?? "adhan_rabeh_ibn_darah.aiff"
      let baseName = soundId
        .replacingOccurrences(of: ".aiff", with: "")
        .replacingOccurrences(of: ".caf", with: "")
      channel.invokeMethod("play", arguments: "assets/audio/\(baseName).mp3")
      if #available(iOS 14.0, *) {
        completionHandler([.banner, .badge])
      } else {
        completionHandler([.alert, .badge])
      }
      return
    }
    // All other notifications: let flutter_local_notifications handle sound
    super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
  }

  // ── Background fetch ────────────────────────────────────────────────────
  // iOS wakes the app periodically (when fetch background mode is enabled).
  // We use this to reload the widget timeline and flag notification reschedule
  // if the device has rebooted and cleared all scheduled notifications.
  override func application(
    _ application: UIApplication,
    performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Always reload widget so it reflects the latest cached prayer times.
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }

    // If very few notifications are pending the device likely rebooted and
    // cleared them. Set a flag so Flutter reschedules them on next launch.
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
      if requests.count < 3 {
        UserDefaults.standard.set(true, forKey: "needsNotificationReschedule")
      }
      completionHandler(.newData)
    }
  }

  // ── Widget + Adhan channels ─────────────────────────────────────────────
  func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FajrWidgetPlugin") else { return }
    let messenger = registrar.messenger()

    // Widget channel
    let widgetChannel = FlutterMethodChannel(name: "fajr.widget", binaryMessenger: messenger)
    widgetChannel.setMethodCallHandler { call, result in
      if call.method == "needsReschedule" {
        let needs = UserDefaults.standard.bool(forKey: "needsNotificationReschedule")
        UserDefaults.standard.removeObject(forKey: "needsNotificationReschedule")
        result(needs)
      } else if call.method == "updateWidget" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
          return
        }
        let defaults = UserDefaults(suiteName: "group.com.fajr.fajr")
        if let nextPrayer = args["nextPrayer"] as? String { defaults?.set(nextPrayer, forKey: "nextPrayer") }
        if let nextTime   = args["nextTime"]   as? String { defaults?.set(nextTime,   forKey: "nextTime") }
        if let nextEpoch  = args["nextEpoch"]  as? Double { defaults?.set(nextEpoch,  forKey: "nextEpoch") }
        if let allPrayers = args["allPrayers"] as? String { defaults?.set(allPrayers, forKey: "allPrayers") }
        if let hijriDay   = args["hijriDay"]   as? String { defaults?.set(hijriDay,   forKey: "hijriDay") }
        if let hijriMonth = args["hijriMonth"] as? String { defaults?.set(hijriMonth, forKey: "hijriMonth") }
        if let hijriYear  = args["hijriYear"]  as? String { defaults?.set(hijriYear,  forKey: "hijriYear") }
        defaults?.synchronize()
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      } else if call.method == "updateWidgetWeek" {
        // Pre-populated 7-day timeline so the widget stays accurate even when
        // the app hasn't run for several days.
        if let args = call.arguments as? [String: Any],
           let weekPrayers = args["weekPrayers"] as? String {
          let defaults = UserDefaults(suiteName: "group.com.fajr.fajr")
          defaults?.set(weekPrayers, forKey: "weekPrayers")
          defaults?.synchronize()
          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
          }
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // Live Activity channel
    let liveChannel = FlutterMethodChannel(name: "fajr.live_activity", binaryMessenger: messenger)
    liveChannel.setMethodCallHandler { call, result in
      if #available(iOS 16.2, *) {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
          return
        }
        let name  = args["prayerName"]  as? String ?? ""
        let time  = args["prayerTime"]  as? String ?? ""
        let epoch = args["prayerEpoch"] as? Double ?? 0
        let icon  = args["prayerIcon"]  as? String ?? "moon.stars.fill"

        let state = PrayerLiveAttributes.ContentState(
          prayerName: name, prayerTime: time, prayerEpoch: epoch, prayerIcon: icon
        )

        switch call.method {
        case "start":
          // End any existing activities first
          for activity in Activity<PrayerLiveAttributes>.activities {
            Task { await activity.end(nil, dismissalPolicy: .immediate) }
          }
          // Start new
          let attrs = PrayerLiveAttributes()
          let content = ActivityContent(state: state, staleDate: Date(timeIntervalSince1970: epoch / 1000))
          do {
            _ = try Activity.request(attributes: attrs, content: content)
            result(nil)
          } catch {
            result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: error.localizedDescription, details: nil))
          }

        case "update":
          let content = ActivityContent(state: state, staleDate: Date(timeIntervalSince1970: epoch / 1000))
          Task {
            for activity in Activity<PrayerLiveAttributes>.activities {
              await activity.update(content)
            }
            result(nil)
          }

        case "end":
          Task {
            for activity in Activity<PrayerLiveAttributes>.activities {
              await activity.end(nil, dismissalPolicy: .immediate)
            }
            result(nil)
          }

        default:
          result(FlutterMethodNotImplemented)
        }
      } else {
        result(nil) // Silently no-op on iOS < 16.1
      }
    }

    // (adhan channel is set up in application:didFinishLaunchingWithOptions: on the main engine)
  }
}
