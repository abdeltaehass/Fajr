import Foundation
import WatchConnectivity

/// Mirrors prayer data to the Apple Watch. The phone is the single source of
/// truth — the watch never fetches from the network itself. Data rides on
/// WCSession's applicationContext, which keeps only the latest snapshot and
/// delivers it opportunistically (even if the watch is out of reach right
/// now), which is exactly the semantics prayer times need.
class WatchSessionManager: NSObject, WCSessionDelegate {
  static let shared = WatchSessionManager()

  // applicationContext replaces the entire dictionary on every send, so we
  // merge each partial update (today's prayers vs. week timeline) into the
  // last known full picture before pushing.
  private var latest: [String: Any] = [:]

  private override init() {
    super.init()
  }

  func start() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  /// Merge a partial payload into the mirrored state and push to the watch.
  func merge(_ piece: [String: Any]) {
    for (key, value) in piece { latest[key] = value }
    push()
  }

  private func push() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    guard session.activationState == .activated,
          session.isPaired,
          session.isWatchAppInstalled,
          !latest.isEmpty else { return }
    // Stamp so the watch can tell how fresh its mirror is.
    latest["mirroredAt"] = Date().timeIntervalSince1970
    try? session.updateApplicationContext(latest)
  }

  // MARK: - WCSessionDelegate

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    if activationState == .activated { push() }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    // Re-activate after a watch switch so the new watch gets data.
    session.activate()
  }

  func sessionWatchStateDidChange(_ session: WCSession) {
    // Fires when the watch app gets installed/paired — push what we have.
    push()
  }
}
