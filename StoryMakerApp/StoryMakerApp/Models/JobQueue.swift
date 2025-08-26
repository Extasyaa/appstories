import Foundation
import SwiftUI

class JobQueue: ObservableObject {
    @Published var jobs: [Job] = []

    func add(_ job: Job) {
        jobs.append(job)
    }

    func update(id: UUID, status: JobStatus? = nil, progress: Double? = nil, log: String? = nil) {
        guard let index = jobs.firstIndex(where: { $0.id == id }) else { return }
        if let status = status {
            jobs[index].status = status
        }
        if let progress = progress {
            jobs[index].progress = progress
        }
        if let log = log {
            jobs[index].logs.append(log)
        }
    }

    func openReleasesFolder() {
        // Placeholder for opening releases folder
    }
}
