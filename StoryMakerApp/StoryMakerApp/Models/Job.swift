import Foundation

enum JobType: String, Codable {
    case story
    case render
    case publish
    case tts
    case assemble
}

enum JobStatus: String, Codable {
    case pending
    case running
    case done
    case error
}

struct Job: Identifiable, Codable {
    var id = UUID()
    var type: JobType
    var status: JobStatus = .pending
    var progress: Double = 0.0
    var logs: [String] = []
}
