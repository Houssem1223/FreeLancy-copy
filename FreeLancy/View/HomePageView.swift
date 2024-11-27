import SwiftUI

struct HomePage: View {
    var username: String
    @State private var navigateToProfile = false
    @State private var isDrawerOpen = false // State to toggle the drawer
    @State private var navigateToLogin = false
    @State private var searchText = "" // For the search bar
    @State private var selectedTab = "Best Matches" // Default selected tab
    let tabs = ["Best Matches", "Most Recent"] // Tabs for filtering

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.white // Background for home page
                        .ignoresSafeArea()

                    VStack(alignment: .leading) {
                        // Search Bar
                        TextField("Search for jobs", text: $searchText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)

                        // Tabs for Filtering
                        HStack {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab)
                                    .font(.headline)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                    .onTapGesture {
                                        selectedTab = tab
                                    }
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 5)

                        Text("Browse jobs that match your experience to a client's hiring preferences. Ordered by most relevant.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)

                        // Job Listings
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(0..<5, id: \.self) { _ in
                                    JoblistingCardView(
                                        title: "Beta Test for Google PlayStore",
                                        description: "I need 20 beta testers for my app that I want to publish on PlayStore. Android is needed.",
                                        tags: ["Android", "Bug Reports", "Usability Testing"],
                                        budget: "$5",
                                        location: "Sweden",
                                        proposals: "20 to 50"
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }

                        Spacer()
                        HStack {
                            NavigationBarItem(icon: "magnifyingglass", title: "Jobs", isActive: true)
                            NavigationBarItem(icon: "pencil", title: "Proposals")
                            NavigationBarItem(icon: "doc.text", title: "Contracts")
                            NavigationBarItem(icon: "message", title: "Messages")
                            NavigationBarItem(icon: "bell", title: "Alerts")
                        }
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: -5)
                
                    }
                    .navigationTitle("Jobs")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                isDrawerOpen.toggle() // Toggle drawer
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true) // Hide back button
                }

                // Navigate to ProfileView
                .background(
                    NavigationLink(destination: ProfileView(user: username), isActive: $navigateToProfile) {
                        EmptyView()
                    }
                )
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
            }

            // Drawer Overlay
            if isDrawerOpen {
                DrawerView(isDrawerOpen: $isDrawerOpen, username: username, navigateToProfile: $navigateToProfile, navigateToLogin: $navigateToLogin)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut, value: isDrawerOpen)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Job Card View for Each Listing
struct JoblistingCardView: View {
    let title: String
    let description: String
    let tags: [String]
    let budget: String
    let location: String
    let proposals: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Tags
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(5)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(5)
                }
            }

            // Budget, Location, and Proposals
            HStack {
                Text("Budget: \(budget)")
                Spacer()
                Text("Location: \(location)")
                Spacer()
                Text("Proposals: \(proposals)")
            }
            .font(.caption)
            .foregroundColor(.gray)

            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

struct DrawerMenuItem: View {
    let iconName: String
    let title: String
    let action: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 25, height: 25)

            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.vertical, 10)
        .onTapGesture {
            action?() // Trigger the action
        }
    }
}

struct DrawerView: View {
    @Binding var isDrawerOpen: Bool
    var username: String
    @Binding var navigateToProfile: Bool
    @Binding var navigateToLogin: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.4) // Background overlay
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isDrawerOpen = false // Close drawer when tapping outside
                    }
                }

            VStack(alignment: .leading, spacing: 20) {
                // Profile Section
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(username.prefix(2)).uppercased())
                                .foregroundColor(.white)
                                .font(.title3)
                        )

                    VStack(alignment: .leading) {
                        Text(username)
                            .font(.headline)
                            .foregroundColor(.black)

                        Text("Freelancer")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 40)

                Divider()

                // Drawer Menu Items
                DrawerMenuItem(iconName: "person", title: "Profile") {
                    withAnimation {
                        isDrawerOpen = false
                        navigateToProfile = true // Trigger navigation
                    }
                }

                DrawerMenuItem(iconName: "chart.bar", title: "My Stats") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to My Stats") // Navigate to Stats
                    }
                }
                DrawerMenuItem(iconName: "doc.text", title: "Reports") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to Reports") // Navigate to Reports
                    }
                }
                DrawerMenuItem(iconName: "hammer", title: "My Requests") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to My Requests") // Navigate to My Requests
                    }
                }
                DrawerMenuItem(iconName: "square.grid.2x2", title: "Apps and Offers") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to Apps and Offers") // Navigate to Apps and Offers
                    }
                }
                DrawerMenuItem(iconName: "gearshape", title: "Settings") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to Settings") // Navigate to Settings
                    }
                }
                DrawerMenuItem(iconName: "questionmark.circle", title: "Help & Support") {
                    withAnimation {
                        isDrawerOpen = false
                        print("Navigating to Help & Support") // Navigate to Help & Support
                    }
                }

                Spacer()

                // Logout Section
                Button(action: {
                    isDrawerOpen = false
                    navigateToLogin = true
                }) {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                            .foregroundColor(.green)

                        Text("Log out")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .padding()
                }

                Text("Version 1.76.0.22")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .ignoresSafeArea()
            .padding(.horizontal, 20)
            .frame(maxWidth: 300)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(username: "John Doe") // Example username
    }
}
