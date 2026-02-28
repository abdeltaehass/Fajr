import WidgetKit
import SwiftUI

// MARK: - Shared data

let fajrSuiteName = "group.com.fajr.fajr"

struct PrayerItem {
    let name: String
    let time24: String  // "HH:mm"
    let epoch: Double

    var displayTime: String {
        let parts = time24.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return time24 }
        let h = parts[0], m = parts[1]
        let suffix = h >= 12 ? "PM" : "AM"
        let h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return String(format: "%d:%02d %@", h12, m, suffix)
    }

    var date: Date { Date(timeIntervalSince1970: epoch / 1000) }

    var icon: String {
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

struct PrayerData {
    let allPrayers: [PrayerItem]
    let nextEpoch: Double

    static func load() -> PrayerData {
        let d = UserDefaults(suiteName: fajrSuiteName)
        var prayers: [PrayerItem] = []

        if let json = d?.string(forKey: "allPrayers"),
           let raw  = json.data(using: .utf8),
           let arr  = try? JSONSerialization.jsonObject(with: raw) as? [[String: Any]] {
            prayers = arr.compactMap { dict -> PrayerItem? in
                guard let name  = dict["name"]  as? String,
                      let time  = dict["time"]  as? String,
                      let epoch = dict["epoch"] as? Double else { return nil }
                return PrayerItem(name: name, time24: time, epoch: epoch)
            }
        }

        // Fallback before the app writes allPrayers for the first time
        if prayers.isEmpty {
            let name  = d?.string(forKey: "nextPrayer") ?? "—"
            let time  = d?.string(forKey: "nextTime")   ?? "—"
            let epoch = d?.double(forKey: "nextEpoch")  ?? 0
            prayers = [PrayerItem(name: name, time24: time, epoch: epoch)]
        }

        return PrayerData(allPrayers: prayers,
                          nextEpoch: d?.double(forKey: "nextEpoch") ?? 0)
    }

    /// Next `count` prayers that haven't happened yet.
    func upcoming(_ count: Int = 3) -> [PrayerItem] {
        let now = Date()
        let future = allPrayers.filter { $0.epoch > 0 && $0.date > now }
        return Array((future.isEmpty ? allPrayers : future).prefix(count))
    }
}

// MARK: - Timeline Provider

struct FajrTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> FajrEntry {
        let items = [
            PrayerItem(name: "Asr",     time24: "15:45", epoch: 0),
            PrayerItem(name: "Maghrib", time24: "18:12", epoch: 0),
            PrayerItem(name: "Isha",    time24: "19:48", epoch: 0),
        ]
        return FajrEntry(date: Date(), data: PrayerData(allPrayers: items, nextEpoch: 0))
    }

    func getSnapshot(in context: Context, completion: @escaping (FajrEntry) -> Void) {
        completion(FajrEntry(date: Date(), data: .load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FajrEntry>) -> Void) {
        let data  = PrayerData.load()
        let entry = FajrEntry(date: Date(), data: data)
        var next  = Date().addingTimeInterval(30 * 60)
        if data.nextEpoch > 0 {
            let prayerDate = Date(timeIntervalSince1970: data.nextEpoch / 1000)
            if prayerDate > Date() { next = prayerDate.addingTimeInterval(60) }
        }
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// MARK: - Entry

struct FajrEntry: TimelineEntry {
    let date: Date
    let data: PrayerData
}

// MARK: - Background helper

extension View {
    @ViewBuilder
    func widgetBackground<B: View>(@ViewBuilder background: () -> B) -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(for: .widget, content: background)
        } else {
            self.background(background())
        }
    }
}

// MARK: - Shared palette

private let bgTop    = Color(red: 0.05, green: 0.29, blue: 0.18)  // #0D4A2E
private let bgBottom = Color(red: 0.04, green: 0.24, blue: 0.14)  // #0A3D24
private let gold     = Color(red: 0.79, green: 0.66, blue: 0.30)  // #C9A84C
private let cream    = Color(red: 0.96, green: 0.94, blue: 0.88)  // #F5F0E1

private var appGradient: LinearGradient {
    LinearGradient(colors: [bgTop, bgBottom],
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing)
}

// MARK: - Lock Screen: Inline

struct FajrInlineView: View {
    let entry: FajrEntry
    var body: some View {
        let next = entry.data.upcoming(1).first
        Text("\(next?.name ?? "—") · \(next?.displayTime ?? "—")")
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .widgetBackground { Color.clear }
    }
}

// MARK: - Lock Screen: Circular

struct FajrCircularView: View {
    let entry: FajrEntry
    var body: some View {
        let next = entry.data.upcoming(1).first
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 1) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 11))
                Text(next?.name ?? "—")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .minimumScaleFactor(0.7)
                Text(next?.displayTime ?? "—")
                    .font(.system(size: 10, design: .rounded))
                    .minimumScaleFactor(0.7)
            }
        }
        .widgetBackground { Color.clear }
    }
}

// MARK: - Lock Screen: Rectangular — live countdown

struct FajrRectangularView: View {
    let entry: FajrEntry
    var body: some View {
        let next = entry.data.upcoming(1).first
        let isLive = (next?.epoch ?? 0) > 0 && (next?.date ?? .distantPast) > Date()

        VStack(alignment: .leading, spacing: 2) {
            // Prayer name label
            HStack(spacing: 4) {
                Image(systemName: "timer")
                    .font(.system(size: 10, weight: .semibold))
                Text((next?.name ?? "Next").uppercased())
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .lineLimit(1)
            }
            .opacity(0.65)

            // Live countdown — ticks automatically, no reload needed
            if isLive, let d = next?.date {
                Text(d, style: .timer)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            } else {
                Text(next?.displayTime ?? "—")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
            }

            Text("until adhan")
                .font(.system(size: 10, design: .rounded))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetBackground { Color.clear }
    }
}

// MARK: - Home Screen: Small

struct FajrSmallView: View {
    let entry: FajrEntry

    var body: some View {
        let prayers = entry.data.upcoming(3)
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(gold)
                Text("PRAYERS")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(cream.opacity(0.6))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                ForEach(prayers.indices, id: \.self) { i in
                    let p = prayers[i]
                    HStack {
                        Text(p.name)
                            .font(.system(size: i == 0 ? 16 : 13,
                                          weight: i == 0 ? .bold : .regular,
                                          design: .rounded))
                            .foregroundColor(i == 0 ? cream : cream.opacity(0.5))
                        Spacer()
                        Text(p.displayTime)
                            .font(.system(size: i == 0 ? 15 : 12,
                                          weight: i == 0 ? .semibold : .regular,
                                          design: .rounded))
                            .foregroundColor(i == 0 ? gold : cream.opacity(0.4))
                    }
                    if i == 0 {
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(cream.opacity(0.2))
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetBackground { appGradient }
    }
}

// MARK: - Home Screen: Medium — next 3 prayers with icons

struct FajrMediumView: View {
    let entry: FajrEntry

    var body: some View {
        let prayers = entry.data.upcoming(3)
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 5) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(gold)
                Text("PRAYERS")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(cream.opacity(0.6))
            }
            .padding(.bottom, 10)

            // Prayer rows
            VStack(alignment: .leading, spacing: 0) {
                ForEach(prayers.indices, id: \.self) { i in
                    let p = prayers[i]

                    HStack(spacing: 12) {
                        Image(systemName: p.icon)
                            .font(.system(size: 15))
                            .foregroundColor(i == 0 ? gold : cream.opacity(0.35))
                            .frame(width: 22)

                        Text(p.name)
                            .font(.system(size: i == 0 ? 17 : 14,
                                          weight: i == 0 ? .bold : .regular,
                                          design: .rounded))
                            .foregroundColor(i == 0 ? cream : cream.opacity(0.5))

                        Spacer()

                        Text(p.displayTime)
                            .font(.system(size: i == 0 ? 17 : 14,
                                          weight: i == 0 ? .semibold : .regular,
                                          design: .rounded))
                            .foregroundColor(i == 0 ? gold : cream.opacity(0.4))
                    }
                    .padding(.vertical, i == 0 ? 5 : 4)

                    if i == 0 {
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(cream.opacity(0.2))
                            .padding(.vertical, 2)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetBackground { appGradient }
    }
}

// MARK: - Entry View Router

struct FajrEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: FajrEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            FajrInlineView(entry: entry)
        case .accessoryCircular:
            FajrCircularView(entry: entry)
        case .accessoryRectangular:
            FajrRectangularView(entry: entry)
        case .systemSmall:
            FajrSmallView(entry: entry)
        case .systemMedium:
            FajrMediumView(entry: entry)
        default:
            FajrRectangularView(entry: entry)
        }
    }
}

// MARK: - Lock Screen: Rectangular — 3 prayers list

struct FajrRectangularPrayersView: View {
    let entry: FajrEntry
    var body: some View {
        let prayers = entry.data.upcoming(3)
        VStack(alignment: .leading, spacing: 0) {
            ForEach(prayers.indices, id: \.self) { i in
                let p = prayers[i]
                HStack {
                    Text(p.name)
                        .font(.system(size: i == 0 ? 14 : 12,
                                      weight: i == 0 ? .bold : .regular,
                                      design: .rounded))
                    Spacer()
                    Text(p.displayTime)
                        .font(.system(size: i == 0 ? 13 : 12,
                                      weight: i == 0 ? .semibold : .regular,
                                      design: .rounded))
                }
                .opacity(i == 0 ? 1.0 : (i == 1 ? 0.65 : 0.45))
                .padding(.vertical, 2)

                if i == 0 {
                    Rectangle()
                        .frame(height: 0.4)
                        .opacity(0.25)
                        .padding(.vertical, 1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetBackground { Color.clear }
    }
}

// MARK: - Widgets

struct FajrWidget: Widget {
    let kind = "FajrWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FajrTimelineProvider()) { entry in
            FajrEntryView(entry: entry)
        }
        .configurationDisplayName("manār")
        .description("Next prayer times at a glance.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .systemSmall,
            .systemMedium,
        ])
    }
}

struct FajrPrayersWidget: Widget {
    let kind = "FajrPrayersWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FajrTimelineProvider()) { entry in
            FajrRectangularPrayersView(entry: entry)
        }
        .configurationDisplayName("manār · Prayers")
        .description("Next three prayers at a glance.")
        .supportedFamilies([.accessoryRectangular])
    }
}
