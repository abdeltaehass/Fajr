import Flutter
import UIKit
import WidgetKit
import AVFoundation
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  private var adhanPlayer: AVAudioPlayer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // Take back delegate ownership after plugins register so our willPresent fires
    UNUserNotificationCenter.current().delegate = self
    return result
  }

  // ── Foreground notification interception ──────────────────────────────────
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let category = notification.request.content.categoryIdentifier

    if category == "ADHAN" {
      // Play via AVAudioPlayer for reliable foreground playback;
      // suppress the notification sound so it doesn't double-fire.
      playAdhan()
      if #available(iOS 14.0, *) {
        completionHandler([.banner, .badge])
      } else {
        completionHandler([.alert, .badge])
      }
    } else {
      // All other notifications (reminders, athkar, etc.) use default behaviour.
      if #available(iOS 14.0, *) {
        completionHandler([.banner, .badge, .sound])
      } else {
        completionHandler([.alert, .badge, .sound])
      }
    }
  }

  private func playAdhan() {
    let defaults = UserDefaults.standard
    // flutter shared_preferences stores keys with "flutter." prefix
    let soundId = defaults.string(forKey: "flutter.adhanSoundId")
                  ?? "adhan_rabeh_ibn_darah.caf"
    let soundName = soundId.replacingOccurrences(of: ".caf", with: "")

    guard let url = Bundle.main.url(forResource: soundName, withExtension: "caf") else {
      return
    }

    do {
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.duckOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
      adhanPlayer?.stop()
      adhanPlayer = try AVAudioPlayer(contentsOf: url)
      adhanPlayer?.play()
    } catch {
      // silently ignore — notification sound will still play as fallback
    }
  }

  // ── Widget channel ─────────────────────────────────────────────────────────
  func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FajrWidgetPlugin") else { return }
    let channel = FlutterMethodChannel(
      name: "fajr.widget",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
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
  }
}
