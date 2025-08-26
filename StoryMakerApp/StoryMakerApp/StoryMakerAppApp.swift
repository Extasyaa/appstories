import SwiftUI

@main
struct StoryMakerAppApp: App {
    @StateObject private var jobQueue = JobQueue()
    @StateObject private var settingsStore = SettingsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(jobQueue)
                .environmentObject(settingsStore)
        }
        .commands {
            AppCommands(jobQueue: jobQueue)
        }
    }
}
