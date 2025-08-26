import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "square.grid.2x2") }
            StoryView()
                .tabItem { Label("Story", systemImage: "text.book.closed") }
            ImagesView()
                .tabItem { Label("Images", systemImage: "photo") }
            TTSView()
                .tabItem { Label("TTS", systemImage: "waveform") }
            AssembleView()
                .tabItem { Label("Assemble", systemImage: "film") }
            PublishView()
                .tabItem { Label("Publish", systemImage: "paperplane") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
