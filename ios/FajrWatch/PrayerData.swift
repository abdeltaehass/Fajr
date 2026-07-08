import Foundation

/// One prayer moment mirrored from the iPhone.
struct PrayerTime: Identifiable {
  let name: String
  let date: Date

  var id: Double { date.timeIntervalSince1970 }

  var displayTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
  }

  var symbol: String {
    switch name {
    case "Fajr":    return "moon.stars.fill"
    case "Sunrise": return "sunrise.fill"
    case "Dhuhr":   return "sun.max.fill"
    case "Asr":     return "sun.haze.fill"
    case "Maghrib": return "sunset.fill"
    case "Isha":    return "moon.fill"
    default:        return "clock.fill"
    }
  }
}

/// Snapshot of everything the iPhone mirrored over WatchConnectivity,
/// persisted in the watch-side app group so the app and the complications
/// read the same data. The watch never fetches from the network.
struct PrayerSnapshot {
  static let appGroup = "group.com.fajr.fajr"

  let today: [PrayerTime]
  let week: [PrayerTime]
  let hijri: String
  let city: String
  let mirroredAt: Date?

  static func load() -> PrayerSnapshot {
    let defaults = UserDefaults(suiteName: appGroup)
    let today = parse(defaults?.string(forKey: "allPrayers"))
    let week = parse(defaults?.string(forKey: "weekPrayers"))

    var hijri = ""
    if let day = defaults?.string(forKey: "hijriDay"),
       let month = defaults?.string(forKey: "hijriMonth"),
       let year = defaults?.string(forKey: "hijriYear"),
       !day.isEmpty {
      hijri = "\(day) \(month) \(year) AH"
    }

    let mirroredAtRaw = defaults?.double(forKey: "mirroredAt") ?? 0

    return PrayerSnapshot(
      today: today,
      week: week,
      hijri: hijri,
      city: defaults?.string(forKey: "locationName") ?? "",
      mirroredAt: mirroredAtRaw > 0
          ? Date(timeIntervalSince1970: mirroredAtRaw) : nil
    )
  }

  /// Decode the [{"name": …, "time": …, "epoch": ms}] JSON the phone sends.
  private static func parse(_ json: String?) -> [PrayerTime] {
    guard let json = json,
          let data = json.data(using: .utf8),
          let list = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    else { return [] }
    return list.compactMap { item in
      guard let name = item["name"] as? String,
            let epoch = (item["epoch"] as? NSNumber)?.doubleValue
      else { return nil }
      return PrayerTime(name: name, date: Date(timeIntervalSince1970: epoch / 1000))
    }.sorted { $0.date < $1.date }
  }

  /// Upcoming prayers, preferring the 7-day timeline (longer horizon) and
  /// falling back to today's list for older mirrors.
  var upcoming: [PrayerTime] {
    let source = week.isEmpty ? today : week
    let now = Date()
    return source.filter { $0.date > now }
  }

  var next: PrayerTime? { upcoming.first }

  /// Today's rows for the main list — the mirrored "today" payload.
  var todaysList: [PrayerTime] { today }

  var hasData: Bool { !today.isEmpty || !week.isEmpty }

  /// True when every mirrored time is in the past — the phone hasn't
  /// synced in a while, so the times on screen can't be trusted.
  var isStale: Bool { hasData && upcoming.isEmpty }
}
