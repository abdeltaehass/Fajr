import SwiftUI

@main
struct FajrWatchApp: App {
  @StateObject private var connector = PhoneConnector.shared

  init() {
    PhoneConnector.shared.activate()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(connector)
    }
  }
}
