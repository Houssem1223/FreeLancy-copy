import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var navigateToRoleScreen: Bool = false
    @State private var showSuccessMessage: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white // Set background to white
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue) // Use blue for title
                        .padding(.top, 50)
                    
                    // Text fields for signup
                    CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
                    CustomTextField(iconName: "envelope", placeholder: "Email", text: $viewModel.email)
                    CustomSecureField(iconName: "lock", placeholder: "Password", text: $viewModel.password, isShowingPassword: $isPasswordVisible)
                    CustomSecureField(iconName: "lock", placeholder: "Confirm Password", text: $viewModel.confirmPassword, isShowingPassword: $isConfirmPasswordVisible)
                    
                    // Signup Button
                    Button(action: {
                        Task {
                            await viewModel.signup() // If signup is async
                            if !viewModel.showError {
                                navigateToRoleScreen = true
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue) // Blue button
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                        .alert(isPresented: $viewModel.showError) {
                            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))}
                    // Navigation to login page
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Log In")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
                NavigationLink(
                    destination: RoleView(username: viewModel.username) { role in
                        print("Selected role: \(role)") // Handle role selection
                    },
                    isActive: $navigateToRoleScreen
                ) {
                    EmptyView()
                }
                
            }
            .navigationBarBackButtonHidden(false)
}
    }
    
    
    // Custom Text Field
    struct CustomTextField: View {
        let iconName: String
        let placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(Color.gray.opacity(0.1)) // Light gray background
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
    
    // Custom Secure Field
    struct CustomSecureField: View {
        let iconName: String
        let placeholder: String
        @Binding var text: String
        @Binding var isShowingPassword: Bool
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                
                if isShowingPassword {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    SecureField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                // Toggle password visibility
                Button(action: {
                    isShowingPassword.toggle()
                }) {
                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1)) // Light gray background
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            SignupView()
        }
    }
}
//import SwiftUI
//
//
//struct SignupView: View {
//    @StateObject private var viewModel = SignupViewModel()
//    @State private var isPasswordVisible: Bool = false
//    @State private var isConfirmPasswordVisible: Bool = false
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
//                    Text("Sign Up")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.top, 50)
//                    
//                    // Champs de texte pour l'inscription
//                    // Champs de texte pour l'inscription
//                                      CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
//                                      CustomTextField(iconName: "envelope", placeholder: "Email", text: $viewModel.email)
//                                      
//                // Use CustomSecureField for password and confirm password
//                                      CustomSecureField(iconName: "lock", placeholder: "Password", text: $viewModel.password, isShowingPassword: $isPasswordVisible)
//                                      CustomSecureField(iconName: "lock", placeholder: "Confirm Password", text: $viewModel.confirmPassword, isShowingPassword: $isConfirmPasswordVisible)
//                    Button(action: {
//                        viewModel.signup() // Appeler la méthode d'inscription
//                    }) {
//                        Text("Sign Up")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
//                            .padding(.horizontal, 20)
//                    }
//                    .padding(.top, 20)
//                    
//                    Spacer()
//                    
//                    // Affichage de l'erreur si elle est présente
//                    .alert(isPresented: $viewModel.showError) {
//                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
//                    }
//                    
//                    // Lien vers la vue de connexion si l'utilisateur a déjà un compte
//                    HStack {
//                        Text("Already have an account?")
//                            .foregroundColor(.white.opacity(0.7))
//                        
//                        NavigationLink(destination: LoginView()) {
//                            Text("Log In")
//                                .foregroundColor(.black)
//                                .underline()
//                        }
//                    }
//                    .padding(.top, 10)
//                }
//                .padding()
//            }
//        //    .navigationTitle("Sign Up")
//        }
//    }
//    struct CustomTextField: View {
//        let iconName: String
//        let placeholder: String
//        @Binding var text: String
//        
//        var body: some View {
//            HStack {
//                Image(systemName: iconName)
//                    .foregroundColor(.white.opacity(0.7))
//                TextField(placeholder, text: $text)
//                    .foregroundColor(.white)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//            }
//            .padding()
//            .background(Color.black.opacity(0.3))
//            .cornerRadius(10)
//            .padding(.horizontal, 20)
//        }
//    }
//    
//    // Custom SecureField with Icon and Visibility Toggle
//    struct CustomSecureField: View {
//        let iconName: String
//        let placeholder: String
//        @Binding var text: String
//        @Binding var isShowingPassword: Bool
//
//        var body: some View {
//            HStack {
//                // Icon for the text field
//                Image(systemName: iconName)
//                    .foregroundColor(.white.opacity(0.7))
//                
//                // Show the password in plain text if isShowingPassword is true
//                if isShowingPassword {
//                    TextField(placeholder, text: $text)
//                        .foregroundColor(.white)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                } else {
//                    // Otherwise, use SecureField to mask the password
//                    SecureField(placeholder, text: $text)
//                        .foregroundColor(.white)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                }
//                
//                // Eye button to toggle visibility
//                Button(action: {
//                    isShowingPassword.toggle()
//                }) {
//                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
//                        .foregroundColor(.white.opacity(0.7))
//                }
//            }
//            .padding()
//            .background(Color.black.opacity(0.3))
//            .cornerRadius(10)
//            .padding(.horizontal, 20)
//        }
//    }
//
//    struct LoginView_Previews: PreviewProvider {
//        static var previews: some View {
//            SignupView()
//        }
//    }
//    
//}
