import Foundation
import WatchConnectivity
import WidgetKit

/// Receives the prayer-data mirror the iPhone pushes over WatchConnectivity
/// and persists it in the app group shared with the complications. The
/// phone is the single source of truth — nothing here touches the network.
final class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
  static let shared = PhoneConnector()

  @Published var snapshot = PrayerSnapshot.load()

  private override init() {
    super.init()
  }

  func activate() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    // A context pushed while the watch app wasn't running is waiting here.
    if activationState == .activated, !session.receivedApplicationContext.isEmpty {
      store(session.receivedApplicationContext)
    }
  }

  func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    store(applicationContext)
  }

  private func store(_ context: [String: Any]) {
    guard let defaults = UserDefaults(suiteName: PrayerSnapshot.appGroup) else { return }
    let stringKeys = [
      "nextPrayer", "nextTime", "allPrayers", "weekPrayers",
      "hijriDay", "hijriMonth", "hijriYear", "locationName",
    ]
    for key in stringKeys {
      if let value = context[key] as? String { defaults.set(value, forKey: key) }
    }
    if let epoch = (context["nextEpoch"] as? NSNumber)?.doubleValue {
      defaults.set(epoch, forKey: "nextEpoch")
    }
    if let at = (context["mirroredAt"] as? NSNumber)?.doubleValue {
      defaults.set(at, forKey: "mirroredAt")
    }

    WidgetCenter.shared.reloadAllTimelines()
    DispatchQueue.main.async {
      self.snapshot = PrayerSnapshot.load()
    }
  }
}
