//
//  ProfileView.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//
//
//import SwiftUI
//
//
//struct ProfileView: View {
//    @StateObject private var viewModel: ProfileViewModel
//   // @Environment(\.presentationMode) var presentationMode // To handle navigation after deletion
////    @State private var showDeleteConfirmation: Bool = false
//
//    // ProfileView receives the username and email from the previous view (after login)
//    init(user: String) {
//        _viewModel = StateObject(wrappedValue: ProfileViewModel(username: user))
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
//                               startPoint: .topLeading,
//                               endPoint: .bottomTrailing)
//                    .ignoresSafeArea()
//
//                VStack(spacing: 20) {
//                    
//                    Text("Welcome, \(viewModel.username)!")
//                                  .font(.largeTitle)
//                                  .fontWeight(.bold)
//                                  .padding()
//                              
//                    
//                    Text("Profile")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.top, 50)
//
//                    // Display username and email
//                    Text(" \(viewModel.username)")
//                        .font(.headline)
//                        .foregroundColor(.white)
//
//                 
//
//                    // Edit Profile Button
//                    NavigationLink(destination: UpdateProfileView(viewModel: UpdateProfileViewModel(username: viewModel.username))) {
//                        Text("Edit Profile")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
//                            .padding(.horizontal, 20)
//                    }
////
////                    // Delete Profile Button
////                    Button(action: {
////                        showDeleteConfirmation = true
////                    }) {
////                        Text("Delete Profile")
////                            .font(.headline)
////                            .foregroundColor(.white)
////                            .padding()
////                            .frame(maxWidth: .infinity)
////                            .background(Color.red)
////                            .cornerRadius(12)
////                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
////                            .padding(.horizontal, 20)
////                    }
////                    .alert(isPresented: $showDeleteConfirmation) {
////                        Alert(
////                            title: Text("Delete Profile"),
////                            message: Text("Are you sure you want to delete your profile? This action cannot be undone."),
////                            primaryButton: .destructive(Text("Delete")) {
////                                viewModel.deleteProfile()
////                                navigateToLogin()
////                            },
////                            secondaryButton: .cancel()
////                        )
////                    }
//
//                    Spacer()
//                }
//                .padding()
//            }
//            
//        }
//    }
//
//    private func navigateToLogin() {
//        // Navigate back to LoginView after profile is deleted
//       // presentationMode.wrappedValue.dismiss()
//    }
//    
//    
//    struct LoginView_Previews: PreviewProvider {
//        static var previews: some View {
//            ProfileView(user:"")
//        }
//    }
//}
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    // ProfileView receives the username from the previous view (after login)
    init(user: String) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(username: user))
        print("Navigated to ProfileView with user: \(user)")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.white // White background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Welcome Message
                    Text("Welcome, \(viewModel.username)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue) // Blue text for the "Welcome"
                        .padding(.top, 50)
                    
                    // Username in Blue
                    //                    Text(viewModel.username)
                    //                        .font(.largeTitle)
                    //                        .fontWeight(.bold)
                    //                        .foregroundColor(.blue) // Blue username
                    //                        .padding(.bottom, 20)
                    
                    // "Profile" Section Title
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    // Edit Profile Button
                    NavigationLink(destination: UpdateProfileView(viewModel: UpdateProfileViewModel(username: viewModel.username))) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue) // Blue button
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                } .onAppear {
                    print("ProfileView Loaded for user: \(viewModel.username)")
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline) // Inline title to avoid stacking
            .navigationBarBackButtonHidden(false)            }
        }
        
    }
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(user: "")
        }
    }
}



