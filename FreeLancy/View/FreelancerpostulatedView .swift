import SwiftUI



struct FreelancerpostulatedView: View {
    let project: Project
    @StateObject private var viewModel = FreelancerPostulatedViewModel() // ViewModel to fetch freelancers
    
    var body: some View {
        ScrollView { // ScrollView for vertical scrolling
            VStack(spacing: 16) { // Stack all the cards vertically with spacing
                // Use ProjectCardVieww to display project details
                ProjectCardVieww(
                    title: project.title,
                    description: project.description,
                    tags: project.technologies.components(separatedBy: ", "), // Assuming technologies is a comma-separated string
                    budget: project.budget,
                    deadline: project.duration
                )
                .padding()
                
                Text("Freelancers Who Postulated:")
                    .font(.headline)
                    .padding(.top)
                
                if viewModel.isLoading {
                    ProgressView("Loading freelancers...")
                        .padding(.top)
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                } else if viewModel.freelancers.isEmpty {
                    Text("No freelancers found.")
                        .foregroundColor(.gray)
                        .padding(.top)
                } else {
                    // Display freelancers using FreelancerCardVieww
                    ForEach(viewModel.freelancers) { freelancer in
                        FreelancerCardVieww(
                            username: freelancer.username,
                            email: freelancer.email,
                            skills: freelancer.skills ?? "No skills listed",
                            status: freelancer.status ,

                            onAccept: {
                                viewModel.updateApplicationStatus(applicationId: freelancer.id, status: "Accepted")
                                       print("Accepted \(freelancer.username)")
                                       // Call your accept API or handle logic here
                                   },
                                   onReject: {
                                       viewModel.updateApplicationStatus(applicationId: freelancer.id, status: "Rejected")
                                       print("Rejected \(freelancer.username)")
                                       // Call your reject API or handle logic here
                                   }
                        )
                        .padding(.horizontal) // Add padding for each card
                    }
                }
            }
            .padding(.top) // Padding at the top of the ScrollView
        }
        .onAppear {
            // Fetch freelancers when the view appears
            viewModel.fetchFreelancers(for: project.id)
        }
        .navigationBarTitle("Project Details", displayMode: .inline)
    }
}

struct ProjectCardVieww: View {
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
import SwiftUI

struct FreelancerCardVieww: View {
    let username: String
    let email: String
    let skills: String
    let status: String

    let onAccept: () -> Void
    let onReject: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Username: \(username)")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Email: \(email)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Skills: \(skills)")
                .font(.footnote)
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Change the background color based on the status
            Text("Status: \(status)")
                .font(.footnote)
                .foregroundColor(status == "Rejected" ? .red : .green) // Change text color to red if rejected
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Spacer() // Push icons to the right
                
                // Accept icon
                Button(action: onAccept) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle()) // Removes button's default styling
                
                // Reject icon
                Button(action: onReject) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle()) // Removes button's default styling
            }
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensure the card takes the full width
        .background(status == "Rejected" ? Color.red.opacity(0.2) : Color(.systemGray6)) // Set background to a light red if rejected
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}


