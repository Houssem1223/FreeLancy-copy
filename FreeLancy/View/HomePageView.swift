import SwiftUI

struct HomePage: View {
    var username: String
   
    @State private var navigateToProfile = false
    @State private var isDrawerOpen = false // State to toggle the drawer
    @State private var navigateToLogin = false
    @State private var searchText = "" // For the search bar
    @State private var selectedTab = "Best Matches" // Default selected tab
    let tabs = ["Best Matches", "Projects"] // Tabs for filtering
    @StateObject private var viewModel = AddProjectViewModel()

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
                        // In HomePage
                        ScrollView {
                            if selectedTab == "Best Matches" {
                                // Show Projects Automatically
                                if viewModel.isLoading {
                                    ProgressView("Loading...")
                                } else if !viewModel.errorMessage.isEmpty {
                                    Text(viewModel.errorMessage)
                                        .foregroundColor(.red)
                                        .padding()
                                } else if viewModel.project.isEmpty {
                                    Text("No projects found.")
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    // Filter the projects here to show only those with score > 0.6
                                    let filteredProjects = viewModel.project.filter { $0.score > 0.6 }
                                    
                                    // If filteredProjects is empty, show a message
                                    if filteredProjects.isEmpty {
                                        Text("No best matches found.")
                                            .foregroundColor(.gray)
                                            .padding()
                                    } else {
                                        ForEach(filteredProjects, id: \.title) { project in
                                            JoblistingCardView(
                                                title: project.title,
                                                description: project.description,
                                                tags: project.technologies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                                                budget: project.budget,
                                                deadline: project.duration,
                                                score: String(format: "%.2f%%", project.score * 100),
                                                scoreDouble: Int(project.score * 100),project: project
                                            )
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
 else {
                                    if viewModel.isLoading {
                                        ProgressView("Loading...")
                                    } else if !viewModel.errorMessage.isEmpty {
                                        Text(viewModel.errorMessage)
                                            .foregroundColor(.red)
                                            .padding()
                                    } else if viewModel.project.isEmpty {
                                        Text("No projects found.")
                                            .foregroundColor(.gray)
                                            .padding()
                                    } else {
                                        let filteredProjects = viewModel.filterProjects1(viewModel.project, searchText: searchText)
                                        ForEach(filteredProjects, id: \.title) { project in
                                            JoblistingCardView(
                                                title: project.title,
                                                description: project.description,
                                                tags: project.technologies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                                                budget: project.budget,
                                                deadline: project.duration,
                                                score: String(format: "%.2f%%", project.score*100),
                                                scoreDouble: Int(project.score*100), project: project
                                                // Assuming score is a Double
                                            )
                                            .padding(.horizontal)
                                        }
                                    }
                                
                            }
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
                NavigationLink(destination: LoginView()   .navigationBarBackButtonHidden(true), isActive: $navigateToLogin) {
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
        .onAppear{
            viewModel.fetchFreelancerProjects()
        }
        
    }
}

// Job Card View for Each Listing
struct JoblistingCardView: View {
    let title: String
    let description: String
    let tags: [String]
    let budget: String
    let deadline: String
    let score : String
    let scoreDouble : Int
    var  project: Projectf
    var body: some View {
        NavigationLink(destination: ProjectDetailsView(project: project)) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text("Technologies: \(tags.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Budget: \(budget)")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
                
                Text("Deadline: \(deadline)")
                    .font(.footnote)
                    .foregroundColor(.red)
                Text("Score: \(scoreDouble)%")
                    .font(.footnote)
                    .foregroundColor(scoreDouble >= 50 ? .green : .red)
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
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
        @StateObject private var viewModel = LoginViewModel()
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
                        viewModel.logout()// Call logout function from the ViewModel
                        navigateToLogin = true // Navigate to login screen
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

