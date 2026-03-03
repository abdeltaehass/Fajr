import Flutter
import UIKit
import WidgetKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  // Stored so willPresent can trigger Flutter-side adhan playback
  private var adhanChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // Wire adhan channel to main Flutter engine (window.rootViewController is set after super)
    if let controller = window?.rootViewController as? FlutterViewController {
      adhanChannel = FlutterMethodChannel(name: "fajr.adhan",
                                          binaryMessenger: controller.binaryMessenger)
    }
    return result
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

  // ── Widget + Adhan channels ─────────────────────────────────────────────
  func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FajrWidgetPlugin") else { return }
    let messenger = registrar.messenger()

    // Widget channel
    let widgetChannel = FlutterMethodChannel(name: "fajr.widget", binaryMessenger: messenger)
    widgetChannel.setMethodCallHandler { call, result in
      if call.method == "updateWidget" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
          return
        }
        let defaults = UserDefaults(suiteName: "group.com.fajr.fajr")
        if let nextPrayer = args["nextPrayer"] as? String { defaults?.set(nextPrayer, forKey: "nextPrayer") }
        if let nextTime   = args["nextTime"]   as? String { defaults?.set(nextTime,   forKey: "nextTime") }
        if let nextEpoch  = args["nextEpoch"]  as? Double { defaults?.set(nextEpoch,  forKey: "nextEpoch") }
        if let allPrayers = args["allPrayers"] as? String { defaults?.set(allPrayers, forKey: "allPrayers") }
        defaults?.synchronize()
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // (adhan channel is set up in application:didFinishLaunchingWithOptions: on the main engine)
  }
}
