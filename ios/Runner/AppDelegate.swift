import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

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
