//
//  WelcomeView.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 20/11/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showLoginView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white // White background
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Image Placeholder with TabView for slides
                    TabView {
                        // Slide 1
                        VStack(spacing: 20) {
                            Image("photo1") // Replace with the first image name
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Text("Find opportunities for every stage of your freelance career")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black) // Black text for contrast
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Search and apply for jobs, save job searches, and more.")
                                .font(.body)
                                .foregroundColor(.gray) // Gray for secondary text
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Slide 2
                        VStack(spacing: 20) {
                            Image("photo2") // Replace with the second image name
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Text("Collaborate on the go")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Chat, share files, and share progress.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        // slide 3
                        VStack(spacing: 20) {
                            Image("photo3") // Replace with the second image name
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Text("find great work")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Meet clients you're excited to work with and grow your independent career of business .")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle()) // Page indicator for multiple slides
                    
                    // Button to navigate to LoginView
                    Button(action: {
                        showLoginView = true
                    }) {
                        Text("Let’s Start")
                            .font(.headline)
                            .foregroundColor(.white) // White text
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue) // Blue background
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: LoginView(), isActive: $showLoginView) {
                    EmptyView()
                }
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


#Preview {
    WelcomeView()
}
