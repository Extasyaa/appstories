import SwiftUI

struct PublishView: View {
    @State private var publishYouTube: Bool = false
    @State private var publishDrive: Bool = false
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tags: String = ""

    var body: some View {
        Form {
            Toggle("YouTube (draft)", isOn: $publishYouTube)
            Toggle("Drive", isOn: $publishDrive)
            Toggle("Telegram", isOn: .constant(false))
                .disabled(true)
            TextField("Title", text: $title)
            TextField("Description", text: $description)
            TextField("Tags", text: $tags)
            Button("Publish", action: publish)
        }
        .padding()
    }

    func publish() {
        let releases = URL(fileURLWithPath: "releases", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
        try? FileManager.default.createDirectory(at: releases, withIntermediateDirectories: true)
    }
}
