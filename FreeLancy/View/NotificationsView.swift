import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @State private var isFreelancerSheetPresented = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Notifications...")
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.notifications.isEmpty {
                    Text("No new notifications.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.notifications) { notification in
                        NotificationRow(notification: notification) {
                            viewModel.fetchFreelancerDetails(freelancerId: notification.freelancerId)
                            isFreelancerSheetPresented = true
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                viewModel.fetchNotifications()
            }
            .navigationTitle("Notifications")
            .sheet(isPresented: $isFreelancerSheetPresented) {
                if let freelancer = viewModel.selectedFreelancer {
                    FreelancerDetailsView(user: freelancer)  // Make sure to pass 'freelancer' here
                } else {
                    ProgressView("Loading...")
                }
            }
        }
    }
}

struct NotificationRow: View {
    let notification: Notification
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(notification.message)
                .font(.body)
                .foregroundColor(notification.status == "read" ? .gray : .black)

            Text("Status: \(notification.status.capitalized)")
                .font(.footnote)
                .foregroundColor(notification.status == "read" ? .gray : .green)
        }
        .padding()
        .background(notification.status == "read" ? Color.gray.opacity(0.2) : Color.white)
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}

// FreelancerDetailsView (Example View)


// Preview
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = NotificationViewModel()
        mockViewModel.notifications = [
            Notification(id: "1", projectId: "101", entrepreneurId: "E1", message: "New project update", status: "unread", freelancerId: "freelancer1"),
            Notification(id: "2", projectId: "102", entrepreneurId: "E2", message: "Message received", status: "read", freelancerId: "freelancer2")
        ]
        
        return NotificationsView()
            .environmentObject(mockViewModel)
    }
}

