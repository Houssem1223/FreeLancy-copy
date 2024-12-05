import SwiftUI

struct AcceptedFreelancersView: View {
    @StateObject private var viewModel = AcceptedFreelancersViewModel()
    @State private var searchQuery = "" // State variable for search input

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    // Search bar
                    TextField("Search freelancers by name", text: $searchQuery)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    List(filteredFreelancers) { application in
                        NavigationLink(destination: Chatview(freelancerName: application.username)) {
                            HStack {
                                // Circle with the first letter of the freelancer's username
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(width: 40, height: 40)
                                    Text(String(application.username.prefix(1)))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                VStack(alignment: .leading) {
                                    Text(application.username)
                                        .font(.headline)
                                    Text(application.email)
                                        .font(.subheadline)
                                    if !application.skills.isEmpty {
                                        Text("Skills: \(application.skills)")
                                            .font(.caption)
                                    }
                                    Text("Status: \(application.status)")
                                        .font(.caption)
                                        .foregroundColor(application.status == "Accepted" ? .green : .red)
                                }
                            }
                        }
                    }
                    .navigationTitle("Accepted Freelancers")
                    .navigationBarTitleDisplayMode(.inline) // This removes the extra space
                    .onAppear {
                        viewModel.fetchAcceptedFreelancers()
                    }
                    .alert(isPresented: $viewModel.hasError) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
            }
        }
    }
    
    // Filter freelancers based on the search query
    private var filteredFreelancers: [application] {
        if searchQuery.isEmpty {
            return viewModel.applications
        } else {
            return viewModel.applications.filter { $0.username.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}
