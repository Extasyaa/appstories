import SwiftUI

struct AssembleView: View {
    @State private var fps: Int = 30
    @State private var autoDuration: Bool = true
    @State private var fixedDuration: Double = 5

    var body: some View {
        Form {
            Stepper("FPS: \(fps)", value: $fps, in: 1...120)
            Toggle("Auto duration per image", isOn: $autoDuration)
            if !autoDuration {
                HStack {
                    Text("Fixed duration (s)")
                    TextField("", value: $fixedDuration, formatter: NumberFormatter())
                }
            }
            Button("Assemble Video", action: assemble)
        }
        .padding()
    }

    func assemble() {
        // Placeholder for video assembly
        let outDir = URL(fileURLWithPath: "out", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        try? FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)
    }
}
