import SwiftUI

struct MyRequestsView: View {
    @ObservedObject var viewModel = HistoriqueViewModel() // ViewModel to fetch projects from postulations

    var body: some View {
        VStack {
            // Display error messages
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            // Display when there are no projects
            else if viewModel.projects.isEmpty {
                Text("No applications found.")
                    .foregroundColor(.gray)
                    .padding()
            }
            // Display list of projects
            else {
                List(viewModel.projects, id: \.title) { project in // Use project title as unique identifier
                    HStack(alignment: .top) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                            .padding(.top, 5)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("You have postulated to the project:")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            Text(project.title)
                                .font(.headline)
                                .foregroundColor(.blue)

                            Text("Status: \(project.status)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            viewModel.fetchProjects() // Fetch projects on appear
        }
        .navigationTitle("My Applications")
    }
}

struct MyRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRequestsView()
    }
}

