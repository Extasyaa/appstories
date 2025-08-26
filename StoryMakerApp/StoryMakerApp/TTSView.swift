import SwiftUI

struct TTSView: View {
    @State private var voice: String = "default"
    @State private var speed: Double = 1.0

    var body: some View {
        Form {
            TextField("Voice", text: $voice)
            HStack {
                Text("Speed")
                Slider(value: $speed, in: 0.5...1.5, step: 0.1)
                Text(String(format: "%.1f", speed))
            }
            Button("Render MP3", action: renderAudio)
        }
        .padding()
    }

    func renderAudio() {
        let buildDir = URL(fileURLWithPath: "build/audio", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        try? FileManager.default.createDirectory(at: buildDir, withIntermediateDirectories: true)
        let output = buildDir.appendingPathComponent("story.mp3")
        FileManager.default.createFile(atPath: output.path, contents: Data())
    }
}
