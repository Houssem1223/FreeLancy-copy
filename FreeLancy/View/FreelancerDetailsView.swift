import SwiftUI

struct FreelancerDetailsView: View {
    let user: User  // Changed "User" to lowercase to follow Swift conventions

    var body: some View {
        VStack {
            // Displaying the user's profile picture (uncomment and use if available)
            // if let url = URL(string: user.profilePictureUrl) {
            //     AsyncImage(url: url) { image in
            //         image
            //             .resizable()
            //             .scaledToFill()
            //             .frame(width: 100, height: 100)
            //             .clipShape(Circle())
            //     } placeholder: {
            //         ProgressView()
            //     }
            // }

            Text(user.username)
                .font(.title)
                .padding()

            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Displaying skills as a simple string
            if let skills = user.skills, !skills.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Skills")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(skills)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.top)
            }

        

            Spacer()
        }
        .padding()
        .navigationTitle("Freelancer Details")
    }
}

