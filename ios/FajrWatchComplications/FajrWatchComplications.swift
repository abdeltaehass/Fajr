import SwiftUI
import WidgetKit

@main
struct FajrWatchComplicationsBundle: WidgetBundle {
  var body: some Widget {
    NextPrayerComplication()
  }
}

struct NextPrayerEntry: TimelineEntry {
  let date: Date
  let prayer: PrayerTime?
}

struct NextPrayerProvider: TimelineProvider {
  func placeholder(in context: Context) -> NextPrayerEntry {
    NextPrayerEntry(
      date: Date(),
      prayer: PrayerTime(name: "Fajr", date: Date().addingTimeInterval(3600))
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (NextPrayerEntry) -> Void) {
    let snapshot = PrayerSnapshot.load()
    completion(NextPrayerEntry(date: Date(), prayer: snapshot.next))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<NextPrayerEntry>) -> Void) {
    let snapshot = PrayerSnapshot.load()
    let upcoming = snapshot.upcoming

    guard !upcoming.isEmpty else {
      // No mirrored data (or it's stale) — show the empty state and ask
      // WidgetKit to check back in an hour in case the phone syncs.
      let timeline = Timeline(
        entries: [NextPrayerEntry(date: Date(), prayer: nil)],
        policy: .after(Date().addingTimeInterval(3600))
      )
      completion(timeline)
      return
    }

    // One entry now, then one at each prayer time so the complication flips
    // to the following prayer the moment one passes. WidgetKit handles the
    // schedule; nothing runs in between.
    var entries = [NextPrayerEntry(date: Date(), prayer: upcoming.first)]
    for (index, prayer) in upcoming.enumerated() {
      let following = index + 1 < upcoming.count ? upcoming[index + 1] : nil
      entries.append(NextPrayerEntry(date: prayer.date, prayer: following))
    }

    completion(Timeline(entries: entries, policy: .atEnd))
  }
}

struct NextPrayerComplication: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "FajrNextPrayer", provider: NextPrayerProvider()) { entry in
      NextPrayerView(entry: entry)
        .containerBackground(for: .widget) { Color.clear }
    }
    .configurationDisplayName("Next Prayer")
    .description("The upcoming prayer and its time.")
    .supportedFamilies([
      .accessoryCircular,
      .accessoryRectangular,
      .accessoryInline,
      .accessoryCorner,
    ])
  }
}

struct NextPrayerView: View {
  @Environment(\.widgetFamily) private var family
  let entry: NextPrayerEntry

  var body: some View {
    switch family {
    case .accessoryInline:
      inline
    case .accessoryRectangular:
      rectangular
    case .accessoryCorner:
      corner
    default:
      circular
    }
  }

  private var inline: some View {
    Group {
      if let prayer = entry.prayer {
        Text("\(prayer.name) \(prayer.displayTime)")
      } else {
        Text("Al-Manar — open iPhone app")
      }
    }
  }

  private var rectangular: some View {
    Group {
      if let prayer = entry.prayer {
        VStack(alignment: .leading, spacing: 1) {
          HStack(spacing: 4) {
            Image(systemName: prayer.symbol)
              .font(.system(size: 11))
              .widgetAccentable()
            Text(prayer.name)
              .font(.headline)
              .widgetAccentable()
          }
          Text(prayer.displayTime)
            .font(.system(.body, design: .rounded).weight(.semibold))
          Text(timerInterval: entry.date...prayer.date, countsDown: true)
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        VStack(alignment: .leading) {
          Text("Al-Manar").font(.headline).widgetAccentable()
          Text("Open the iPhone app to sync")
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }

  private var circular: some View {
    Group {
      if let prayer = entry.prayer {
        ZStack {
          AccessoryWidgetBackground()
          VStack(spacing: 0) {
            Image(systemName: prayer.symbol)
              .font(.system(size: 13))
              .widgetAccentable()
            Text(shortTime(prayer.date))
              .font(.system(size: 12, weight: .semibold, design: .rounded))
              .minimumScaleFactor(0.6)
          }
        }
      } else {
        ZStack {
          AccessoryWidgetBackground()
          Image(systemName: "moon.stars.fill")
            .font(.system(size: 16))
            .widgetAccentable()
        }
      }
    }
  }

  private var corner: some View {
    Group {
      if let prayer = entry.prayer {
        Image(systemName: prayer.symbol)
          .font(.system(size: 18))
          .widgetAccentable()
          .widgetLabel {
            Text("\(prayer.name) \(shortTime(prayer.date))")
          }
      } else {
        Image(systemName: "moon.stars.fill")
          .font(.system(size: 18))
          .widgetAccentable()
          .widgetLabel { Text("Al-Manar") }
      }
    }
  }

  /// Compact "5:12" (no am/pm) for the small families.
  private func shortTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm"
    return formatter.string(from: date)
  }
}
