import SwiftUI

struct EntrepreneurHomePage: View {
    var username: String
    @State private var navigateToProfile = false
    @State private var isDrawerOpen = false
    @State private var navigateToLogin = false
    @State private var searchText = ""
    @State private var selectedTab = "My Projects"
    let tabs = ["My Projects", "New Proposals"]
    @StateObject private var viewModel = AddProjectViewModel()
    @State private var showProjects = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        TextField("Search projects or freelancers", text: $searchText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        // Tab Selection
                        HStack {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab)
                                    .font(.headline)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                    .onTapGesture {
                                        selectedTab = tab
                                if selectedTab == "My Projects" {
                                    viewModel.fetchProjects()
                                                }
                                    }
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 5)
                        
                        // Informational Text
                        Text("Browse your projects and find the best freelancers for your needs.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        // Content Based on Tab Selection
                        ScrollView {
                            if selectedTab == "My Projects" {
                                                       // Show Projects Automatically
                                                       if viewModel.isLoading {
                                                           ProgressView("Loading...")
                                                       } else if !viewModel.errorMessage.isEmpty {
                                                           Text(viewModel.errorMessage)
                                                               .foregroundColor(.red)
                                                               .padding()
                                                       } else if viewModel.projects.isEmpty {
                                                           Text("No projects found.")
                                                               .foregroundColor(.gray)
                                                               .padding()
                                                       } else {
                                                           ForEach(viewModel.projects, id: \.title) { project in
                                                               ProjectCardView(
                                                                   title: project.title,
                                                                   description: project.description,
                                                                   tags: project.technologies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                                                                   budget: project.budget,
                                                                   deadline: project.duration
                                                               )
                                                               .padding(.horizontal)
                                                           }
                                                       }
                                                   } else {
                                                       // Placeholder for "New Proposals" tab
                                                       Text("No new proposals available.")
                                                           .foregroundColor(.gray)
                                                           .padding()
                                                   }
                                               }
                        
                        Spacer()
                        
                        // Bottom Navigation Bar
                        HStack {
                            NavigationBarItem(icon: "magnifyingglass", title: "Projects", isActive: true)
                            NavigationBarItem(icon: "person", title: "Freelancers")
                            NavigationLink(destination: AddProjectView()) {
                                NavigationBarItem(icon: "doc.badge.plus", title: "Add Project")
                            }
                            NavigationBarItem(icon: "message", title: "Messages")
                            NavigationBarItem(icon: "bell", title: "Alerts")
                        }
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: -5)
                    }
                    .navigationTitle("Entrepreneur")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                isDrawerOpen.toggle()
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .background(
                    NavigationLink(destination: ProfileView(user: username), isActive: $navigateToProfile) {
                        EmptyView()
                    }
                )
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
            }
            
            if isDrawerOpen {
                DrawerView(isDrawerOpen: $isDrawerOpen, username: username, navigateToProfile: $navigateToProfile, navigateToLogin: $navigateToLogin)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut, value: isDrawerOpen)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

    
    struct ProjectCardView: View {
        let title: String
        let description: String
        let tags: [String]
        let budget: String
        let deadline: String
        
        var body: some View {
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
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
    struct ProjectView_Previews: PreviewProvider {
        static var previews: some View {
            EntrepreneurHomePage(username: "" )
        }
    }