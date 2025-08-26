import SwiftUI

struct AppCommands: Commands {
    @ObservedObject var jobQueue: JobQueue

    var body: some Commands {
        CommandMenu("File") {
            Button("New Story") { jobQueue.add(Job(type: .story)) }
            Button("Run") { jobQueue.add(Job(type: .render)) }
            Button("Open Releases") { jobQueue.openReleasesFolder() }
        }
    }
}
