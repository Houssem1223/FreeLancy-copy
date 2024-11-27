//
//  RoleView.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 25/11/2024.
//

import SwiftUI



struct RoleView: View {
    @StateObject private var viewModel = RoleViewModel()
    var username: String
    var onRoleSelected: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToLogin = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Welcome Text
                Text("Hi \(username), are you joining as a Freelancer or Entrepreneur?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)

                Text("This lets us know how much help to give you along the way.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 32)

                // Freelancer Card
                RoleCard(
                    title: "Freelancer",
                    description: "I am looking for work opportunities.",
                    imageName: "freelancer", // Replace with your asset name
                    onTap: { updateRole(to: "Freelancer") }
                )

                Spacer().frame(height: 16)

                // Entrepreneur Card
                RoleCard(
                    title: "Entrepreneur",
                    description: "I want to hire freelancers for projects.",
                    imageName: "entrepreneur", // Replace with your asset name
                    onTap: { updateRole(to: "Entrepreneur") }
                )
                .navigationBarBackButtonHidden(true) // Hide the duplicate back button
                     .padding()
                 
                NavigationLink(
                 destination: LoginView(), // Replace with your actual login view
                 isActive: $navigateToLogin,
                
                 label: { EmptyView() } // Hidden NavigationLink
                                 )
            }
         .navigationBarBackButtonHidden(true) 
            .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Background color
        }
    }
    private func updateRole(to role: String) {
          viewModel.updateRole(for: username, to: role) { success in
              if success {
                  print("Role updated successfully to \(role).")
                  navigateToLogin = true 
                  // Navigate back or handle as needed
              } else {
                  print("Failed to update role.")
              }
          }
      }
}

// Role Card Component
struct RoleCard: View {
    var title: String
    var description: String
     var imageName: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

// Preview
struct RoleSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        RoleView(
            username: "",
            onRoleSelected: { role in
                print("Selected role: \(role)")
            }
        )
    }
}


