import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var jobQueue: JobQueue
    @State private var selectedJob: Job?

    var body: some View {
        VStack(alignment: .leading) {
            Table(jobQueue.jobs, selection: $selectedJob) {
                TableColumn("ID") { job in
                    Text(job.id.uuidString.prefix(8))
                }
                TableColumn("Status") { job in
                    Text(job.status.rawValue)
                }
                TableColumn("Progress") { job in
                    Text("\(Int(job.progress * 100))%")
                }
            }
            HStack {
                Button("New Story") { jobQueue.add(Job(type: .story)) }
                Button("Render") { jobQueue.add(Job(type: .render)) }
                Button("Publish") { jobQueue.add(Job(type: .publish)) }
                Button("Open Folder") { jobQueue.openReleasesFolder() }
            }
            .padding(.vertical)
            if let job = selectedJob ?? jobQueue.jobs.last {
                ScrollView {
                    ForEach(job.logs.suffix(20), id: \.self) { line in
                        Text(line)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
        .padding()
    }
}
