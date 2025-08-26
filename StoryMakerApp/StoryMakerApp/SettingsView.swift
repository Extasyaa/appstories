import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    @State private var enginePath: String = ""
    @State private var apiKey: String = ""
    @State private var releasesPath: String = "releases"
    @State private var defaultFPS: Int = 30

    var body: some View {
        Form {
            TextField("Engine Path", text: $enginePath)
            SecureField("OpenAI API Key", text: $apiKey)
            TextField("Releases Path", text: $releasesPath)
            Stepper("Default FPS: \(defaultFPS)", value: $defaultFPS, in: 1...120)
            Button("Save", action: save)
        }
        .padding()
        .onAppear {
            enginePath = settings.enginePath
            releasesPath = settings.releasesPath
            defaultFPS = settings.defaultFPS
            apiKey = settings.apiKey
        }
    }

    func save() {
        settings.enginePath = enginePath
        settings.releasesPath = releasesPath
        settings.defaultFPS = defaultFPS
        settings.apiKey = apiKey
        settings.save()
    }
}
