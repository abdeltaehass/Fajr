import WidgetKit
import SwiftUI
import ActivityKit

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
    let hijriDay: String
    let hijriMonth: String
    let hijriYear: String

    static func load() -> PrayerData {
        let d = UserDefaults(suiteName: fajrSuiteName)
        var prayers: [PrayerItem] = []

        // Prefer 7-day pre-fetched data when present — keeps the widget
        // accurate even if the app hasn't run today.
        if let json = d?.string(forKey: "weekPrayers"),
           let raw  = json.data(using: .utf8),
           let arr  = try? JSONSerialization.jsonObject(with: raw) as? [[String: Any]] {
            prayers = arr.compactMap { dict -> PrayerItem? in
                guard let name  = dict["name"]  as? String,
                      let time  = dict["time"]  as? String,
                      let epoch = dict["epoch"] as? Double else { return nil }
                return PrayerItem(name: name, time24: time, epoch: epoch)
            }
        }

        // Fallback to today-only data
        if prayers.isEmpty,
           let json = d?.string(forKey: "allPrayers"),
           let raw  = json.data(using: .utf8),
           let arr  = try? JSONSerialization.jsonObject(with: raw) as? [[String: Any]] {
            prayers = arr.compactMap { dict -> PrayerItem? in
                guard let name  = dict["name"]  as? String,
                      let time  = dict["time"]  as? String,
                      let epoch = dict["epoch"] as? Double else { return nil }
                return PrayerItem(name: name, time24: time, epoch: epoch)
            }
        }

        // Last-resort fallback before the app writes anything for the first time
        if prayers.isEmpty {
            let name  = d?.string(forKey: "nextPrayer") ?? "—"
            let time  = d?.string(forKey: "nextTime")   ?? "—"
            let epoch = d?.double(forKey: "nextEpoch")  ?? 0
            prayers = [PrayerItem(name: name, time24: time, epoch: epoch)]
        }

        return PrayerData(
            allPrayers: prayers,
            nextEpoch: d?.double(forKey: "nextEpoch") ?? 0,
            hijriDay: d?.string(forKey: "hijriDay") ?? "",
            hijriMonth: d?.string(forKey: "hijriMonth") ?? "",
            hijriYear: d?.string(forKey: "hijriYear") ?? ""
        )
    }

    /// Next `count` prayers that haven't happened yet, relative to `referenceDate`.
    /// Widget views must pass `entry.date` here. Using `Date()` would freeze
    /// the snapshot at provide-time since iOS pre-renders all entries.
    func upcoming(after referenceDate: Date, _ count: Int = 3) -> [PrayerItem] {
        let future = allPrayers.filter { $0.epoch > 0 && $0.date > referenceDate }
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
        return FajrEntry(date: Date(), data: PrayerData(allPrayers: items, nextEpoch: 0, hijriDay: "15", hijriMonth: "Shawwal", hijriYear: "1447"))
    }

    func getSnapshot(in context: Context, completion: @escaping (FajrEntry) -> Void) {
        completion(FajrEntry(date: Date(), data: .load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FajrEntry>) -> Void) {
        let data = PrayerData.load()
        let now  = Date()

        // Build one entry now + one entry at each upcoming prayer time. iOS
        // renders the most recent entry whose date is in the past, so as each
        // prayer arrives the widget naturally rolls forward to the next.
        var entries: [FajrEntry] = [FajrEntry(date: now, data: data)]
        let upcoming = data.allPrayers
            .filter { $0.epoch > 0 && $0.date > now }
            .sorted { $0.date < $1.date }
            .prefix(40) // 7 days * ~6 prayers, with headroom

        for item in upcoming {
            // Add a small offset so the entry refreshes just after the prayer time
            entries.append(FajrEntry(date: item.date.addingTimeInterval(1), data: data))
        }

        // Refresh policy: re-pull the timeline ~6h after the last entry so
        // we always have fresh data once the pre-fetched window winds down.
        let refreshAfter = (entries.last?.date ?? now).addingTimeInterval(6 * 60 * 60)
        completion(Timeline(entries: entries, policy: .after(refreshAfter)))
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
        let next = entry.data.upcoming(after: entry.date, 1).first
        Text("\(next?.name ?? "—") · \(next?.displayTime ?? "—")")
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .widgetBackground { Color.clear }
    }
}

// MARK: - Lock Screen: Circular

struct FajrCircularView: View {
    let entry: FajrEntry
    var body: some View {
        let next = entry.data.upcoming(after: entry.date, 1).first
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
        let next = entry.data.upcoming(after: entry.date, 1).first
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
        let prayers = entry.data.upcoming(after: entry.date, 3)
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
        let prayers = entry.data.upcoming(after: entry.date, 3)
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

// MARK: - Home Screen: Large — full dashboard

private let cardBg = Color.white.opacity(0.06)
private let cardBorder = Color.white.opacity(0.08)
private let softGold = Color(red: 0.85, green: 0.73, blue: 0.40)

struct FajrLargeView: View {
    let entry: FajrEntry

    var body: some View {
        let data = entry.data
        // Use the entry's date — not the current wall clock — because iOS
        // pre-renders all timeline entries at provide-time. Otherwise every
        // entry would freeze on whatever was "next" the moment iOS asked.
        let reference = entry.date
        let upcoming = data.allPrayers.filter { $0.epoch > 0 && $0.date > reference }
        let next = upcoming.first ?? data.allPrayers.first

        // The data store now holds up to 7 days of prayers (for the timeline).
        // The large widget should only list TODAY's prayers — take the 6 that
        // fall on the same calendar day as the reference date.
        let cal = Calendar.current
        let todaysPrayers = data.allPrayers.filter {
            $0.epoch > 0 && cal.isDate($0.date, inSameDayAs: reference)
        }

        let day = Calendar.current.component(.day, from: reference)
        let monthName = DateFormatter().monthSymbols[Calendar.current.component(.month, from: reference) - 1]
        let weekday = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: reference) - 1]

        VStack(spacing: 12) {
            // ── Header cards row ──
            HStack(spacing: 10) {
                // Next prayer card
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(next?.name ?? "—")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(cream)
                        Spacer()
                        Image(systemName: next?.icon ?? "clock.fill")
                            .font(.system(size: 13))
                            .foregroundColor(softGold)
                    }

                    Text(next?.displayTime ?? "—")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(cream)
                        .minimumScaleFactor(0.8)

                    Spacer(minLength: 0)

                    HStack(spacing: 4) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 8))
                            .foregroundColor(softGold.opacity(0.6))
                        Text("Remaining")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(cream.opacity(0.4))
                    }

                    if let nextDate = next?.date, nextDate > reference {
                        Text(nextDate, style: .timer)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(softGold)
                            .minimumScaleFactor(0.7)
                    } else {
                        Text("—:—")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(softGold.opacity(0.4))
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(cardBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(cardBorder, lineWidth: 0.5)
                        )
                )

                // Date card
                VStack(alignment: .leading, spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundColor(softGold)

                    Spacer(minLength: 0)

                    Text("\(day) \(monthName)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(cream.opacity(0.55))
                    Text(weekday)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(cream)
                        .minimumScaleFactor(0.7)

                    if !data.hijriDay.isEmpty {
                        Spacer(minLength: 2)
                        Text("\(data.hijriDay) \(data.hijriMonth)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(cream.opacity(0.4))
                        Text(data.hijriYear)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(softGold)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(cardBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(cardBorder, lineWidth: 0.5)
                        )
                )
            }
            .frame(height: 130)

            // ── Prayer times grid (today only) ──
            VStack(spacing: 0) {
                let half = (todaysPrayers.count + 1) / 2
                let left  = Array(todaysPrayers.prefix(half))
                let right = Array(todaysPrayers.suffix(from: half))
                let rows = max(left.count, right.count)

                ForEach(0..<rows, id: \.self) { i in
                    if i > 0 {
                        Rectangle()
                            .fill(cream.opacity(0.06))
                            .frame(height: 0.5)
                    }
                    HStack(spacing: 0) {
                        if i < left.count {
                            prayerCell(left[i], isNext: left[i].epoch == next?.epoch)
                        } else {
                            Spacer().frame(maxWidth: .infinity)
                        }

                        Rectangle()
                            .fill(cream.opacity(0.06))
                            .frame(width: 0.5)

                        if i < right.count {
                            prayerCell(right[i], isNext: right[i].epoch == next?.epoch)
                        } else {
                            Spacer().frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(cardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(cardBorder, lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .widgetBackground { appGradient }
    }

    private func prayerCell(_ p: PrayerItem, isNext: Bool) -> some View {
        HStack(spacing: 0) {
            Text(p.name)
                .font(.system(size: isNext ? 13 : 12,
                              weight: isNext ? .bold : .medium,
                              design: .rounded))
                .foregroundColor(isNext ? cream : cream.opacity(0.5))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer(minLength: 4)
            Text(p.displayTime)
                .font(.system(size: isNext ? 13 : 12,
                              weight: isNext ? .bold : .regular,
                              design: .rounded))
                .foregroundColor(isNext ? softGold : cream.opacity(0.35))
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity)
        .background(isNext ? softGold.opacity(0.12) : Color.clear)
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
        case .systemLarge:
            FajrLargeView(entry: entry)
        default:
            FajrRectangularView(entry: entry)
        }
    }
}

// MARK: - Lock Screen: Rectangular — 3 prayers list

struct FajrRectangularPrayersView: View {
    let entry: FajrEntry
    var body: some View {
        let prayers = entry.data.upcoming(after: entry.date, 3)
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
            .systemLarge,
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

// MARK: - Live Activity
// PrayerLiveAttributes is defined in Shared/PrayerLiveAttributes.swift
// (compiled into both the app and widget targets).

struct PrayerLiveActivityView: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PrayerLiveAttributes.self) { context in
            // ── Lock screen / banner presentation ──
            HStack(spacing: 14) {
                // Icon
                Image(systemName: context.state.prayerIcon)
                    .font(.system(size: 20))
                    .foregroundColor(gold)
                    .frame(width: 36)

                // Prayer info
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.prayerName)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(context.state.prayerTime)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                // Live countdown
                let target = Date(timeIntervalSince1970: context.state.prayerEpoch / 1000)
                if target > Date() {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(target, style: .timer)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(gold)
                            .multilineTextAlignment(.trailing)
                        Text("remaining")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(appGradient)

        } dynamicIsland: { context in
            DynamicIsland {
                // ── Expanded regions ──
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.prayerIcon)
                            .font(.system(size: 14))
                            .foregroundColor(gold)
                        Text(context.state.prayerName)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.prayerTime)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.trailing, 4)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    let target = Date(timeIntervalSince1970: context.state.prayerEpoch / 1000)
                    if target > Date() {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 10))
                                .foregroundColor(gold.opacity(0.6))
                            Text("Remaining until \(context.state.prayerName)")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text(target, style: .timer)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(gold)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.top, 4)
                    }
                }
            } compactLeading: {
                // ── Compact: left pill ──
                Image(systemName: context.state.prayerIcon)
                    .font(.system(size: 12))
                    .foregroundColor(gold)
            } compactTrailing: {
                // ── Compact: right pill ──
                let target = Date(timeIntervalSince1970: context.state.prayerEpoch / 1000)
                if target > Date() {
                    Text(target, style: .timer)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(gold)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 36)
                } else {
                    Text(context.state.prayerTime)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(gold)
                }
            } minimal: {
                // ── Minimal: single icon ──
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 12))
                    .foregroundColor(gold)
            }
        }
    }
}
