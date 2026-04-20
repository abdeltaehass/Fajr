import Foundation
import ActivityKit

// Shared by BOTH the Runner app target (to start/update/end activities)
// and the FajrWidget extension (to render the lock-screen banner and
// Dynamic Island). Must be compiled into both targets.
@available(iOS 16.1, *)
struct PrayerLiveAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var prayerName: String
        var prayerTime: String    // display string e.g. "1:07 PM"
        var prayerEpoch: Double   // ms since epoch
        var prayerIcon: String    // SF Symbol name
    }
}
