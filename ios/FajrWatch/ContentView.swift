import SwiftUI

/// Watch-face-independent theme approximating the iOS app's dark green +
/// gold look.
enum WatchTheme {
  static let background = Color(red: 0.05, green: 0.27, blue: 0.20)
  static let gold = Color(red: 0.91, green: 0.76, blue: 0.35)
  static let goldSoft = Color(red: 0.91, green: 0.76, blue: 0.35).opacity(0.7)
}

struct ContentView: View {
  @EnvironmentObject var connector: PhoneConnector

  var body: some View {
    let snapshot = connector.snapshot
    Group {
      if snapshot.hasData && !snapshot.isStale {
        prayerList(snapshot)
      } else {
        emptyState(stale: snapshot.isStale)
      }
    }
    .containerBackground(WatchTheme.background.gradient, for: .navigation)
  }

  private func prayerList(_ snapshot: PrayerSnapshot) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 6) {
        if let next = snapshot.next {
          nextPrayerHeader(next)
            .padding(.bottom, 6)
        }

        ForEach(snapshot.todaysList) { prayer in
          prayerRow(prayer, isNext: prayer.id == snapshot.next?.id)
        }

        footer(snapshot)
          .padding(.top, 8)
      }
      .padding(.horizontal, 4)
    }
    .navigationTitle("Al-Manar")
  }

  private func nextPrayerHeader(_ next: PrayerTime) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("NEXT PRAYER")
        .font(.system(size: 11, weight: .semibold))
        .kerning(1.5)
        .foregroundStyle(WatchTheme.goldSoft)
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: next.symbol)
          .foregroundStyle(WatchTheme.gold)
        Text(next.name)
          .font(.system(size: 22, weight: .bold, design: .rounded))
        Spacer()
      }
      HStack {
        Text(next.displayTime)
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(WatchTheme.goldSoft)
        Spacer()
        // Auto-updating countdown — no timers needed.
        Text(timerInterval: Date.now...next.date, countsDown: true)
          .font(.system(size: 14, weight: .semibold).monospacedDigit())
          .foregroundStyle(WatchTheme.gold)
          .multilineTextAlignment(.trailing)
      }
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(WatchTheme.gold.opacity(0.12))
    )
  }

  private func prayerRow(_ prayer: PrayerTime, isNext: Bool) -> some View {
    HStack {
      Image(systemName: prayer.symbol)
        .font(.system(size: 12))
        .foregroundStyle(isNext ? WatchTheme.gold : .secondary)
        .frame(width: 18)
      Text(prayer.name)
        .font(.system(size: 14, weight: isNext ? .semibold : .regular))
      Spacer()
      Text(prayer.displayTime)
        .font(.system(size: 13, weight: isNext ? .semibold : .regular).monospacedDigit())
        .foregroundStyle(isNext ? WatchTheme.gold : .secondary)
    }
    .padding(.vertical, 3)
    .padding(.horizontal, 6)
    .background(
      isNext
        ? RoundedRectangle(cornerRadius: 8).fill(WatchTheme.gold.opacity(0.10))
        : nil
    )
    .opacity(prayer.date < Date() ? 0.5 : 1)
  }

  private func footer(_ snapshot: PrayerSnapshot) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      if !snapshot.hijri.isEmpty {
        Text(snapshot.hijri)
          .font(.system(size: 11))
          .foregroundStyle(.secondary)
      }
      if !snapshot.city.isEmpty {
        HStack(spacing: 3) {
          Image(systemName: "location.fill")
            .font(.system(size: 9))
          Text(snapshot.city)
            .font(.system(size: 11))
        }
        .foregroundStyle(.secondary)
      }
    }
  }

  private func emptyState(stale: Bool) -> some View {
    VStack(spacing: 8) {
      Image(systemName: stale ? "arrow.triangle.2.circlepath" : "iphone")
        .font(.system(size: 28))
        .foregroundStyle(WatchTheme.gold)
      Text(stale
           ? "Times are out of date. Open Al-Manar on your iPhone to sync."
           : "Open Al-Manar on your iPhone to sync prayer times.")
        .font(.system(size: 13))
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
    }
    .padding()
  }
}
