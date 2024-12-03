import SwiftUI

// Notifications View
struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel()

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
//                            viewModel.markNotificationAsRead(notificationId: notification.id)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                viewModel.fetchNotifications()
            }
            .navigationTitle("Notifications")
        }
    }
}
struct NotificationRow: View {
    let notification: Notification
    let markAsRead: () -> Void

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
            markAsRead()
        }
    }
}

// Preview
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = NotificationViewModel()
        mockViewModel.notifications = [
            Notification(id: "1", projectId: "101", entrepreneurId: "E1", message: "New project update", status: "unread"),
            Notification(id: "2", projectId: "102", entrepreneurId: "E2", message: "Message received", status: "read")
        ]
        
        return NotificationsView()
            .environmentObject(mockViewModel)
    }
}
