import SwiftUI


struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showVerifyOtpSheet = false
    @State private var email = ""
    @State private var isPasswordVisible: Bool = false // State for toggling password visibility

    var body: some View {
        NavigationView {
            ZStack {
                Color.white // White background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue) // Blue text for title
                        .padding(.top, 50)
                    
                    // Bind username and password to ViewModel
                    CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
                    CustomSecureField(
                        iconName: "lock",
                        placeholder: "Password",
                        text: $viewModel.password,
                        isShowingPassword: $isPasswordVisible // Bind the toggle state
                    )
                    
                    // Forgot Password Section
                    HStack {
                        Text("Forgot your password?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            viewModel.resetEmail = viewModel.username
                            viewModel.showResetPassword = true
                        }) {
                            Text("Reset Password")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    
                    // Log In Button
                    Button(action: {
                       viewModel.handleLogin()
                      //  viewModel.fetchRoleDetails(idrole: "")
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Sign Up Section
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            viewModel.showSignup = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    
                    
                    // Navigation Links
                    NavigationLink(
                        destination: destinationView(), // Pass only the username
                        isActive: $viewModel.isLoggedIn
                    ) {
                        EmptyView()
                    }   
                    .navigationBarBackButtonHidden(true)


                    
                    NavigationLink(
                        destination: ForgotPasswordView(viewModel: ForgotPasswordViewModel(), showVerifyOtpSheet: $showVerifyOtpSheet, email: email),
                        isActive: $viewModel.showResetPassword
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: SignupView(),
                        isActive: $viewModel.showSignup
                    ) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
                .padding()
                .alert(isPresented: $viewModel.showError) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    @ViewBuilder
      private func destinationView() -> some View {
          if viewModel.role == "Freelancer" {
              HomePage(username: viewModel.username) // Navigate to Freelancer Home Page
          } else if viewModel.role == "Entrepreneur" {
              EntrepreneurHomePage(username: viewModel.username) // Navigate to Entrepreneur Home Page
          } else {
              Text("Unknown Role").foregroundColor(.red) // Fallback for unknown roles
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
    
    // Custom Secure Field with Eye Toggle
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
                    TextField(placeholder, text: $text) // Plain text field for visible password
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    SecureField(placeholder, text: $text) // SecureField for hidden password
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                // Toggle Password Visibility
                Button(action: {
                    isShowingPassword.toggle()
                }) {
                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}
//
//import SwiftUI
//
//struct LoginView: View {
//    @StateObject private var viewModel = LoginViewModel()
//    @State private var showVerifyOtpSheet = false // Define showVerifyOtpSheet
//        @State private var email = ""
//    
//        var body: some View {
//            NavigationView {
//                ZStack {
//                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
//                                   startPoint: .topLeading,
//                                   endPoint: .bottomTrailing)
//                        .ignoresSafeArea()
//
//                    VStack(spacing: 30) {
//                        Text("Welcome Back!")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .padding(.top, 50)
//
//                        // Bind username and password to ViewModel
//                        CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
//                        CustomSecureField(iconName: "lock", placeholder: "Password", text: $viewModel.password, isShowingPassword: .constant(false))
//
//                        HStack {
//                            Text("Forgot your password?")
//                                .foregroundColor(.white.opacity(0.7))
//
//                            Button(action: {
//                                viewModel.resetEmail = viewModel.username
//                                viewModel.showResetPassword = true
//                            }) {
//                                Text("Reset Password")
//                                    .foregroundColor(.black)
//                                    .underline()
//                            }
//                        }
//
//                        Button(action: {
//                            viewModel.handleLogin() // Call login function from ViewModel
//                        }) {
//                            Text("Log In")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.blue)
//                                .cornerRadius(12)
//                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
//                                .padding(.horizontal, 20)
//                        }
//                        .padding(.top, 20)
//                        
//                        HStack {
//                            Text("Don't have an acount?")
//                                .foregroundColor(.white.opacity(0.7))
//                            
//                            Button(action: {
//                                
//                                viewModel.showSignup = true
//                            }) {
//                                Text("Sign Up")
//                                    .foregroundColor(.black)
//                                    .underline()
//                            }
//                        }
//
//                        // NavigationLink to ProfileView if logged in, passing loggedInUsername
//                        NavigationLink(
//                            destination: ProfileView(user: viewModel.loggedInUsername), // Pass username to ProfileView
//                            isActive: $viewModel.isLoggedIn
//                        ) {
//                            EmptyView() // The NavigationLink itself is invisible
//                        }
//                        NavigationLink(
//                            destination:  ForgotPasswordView(viewModel: ForgotPasswordViewModel(), showVerifyOtpSheet: $showVerifyOtpSheet, email: email),
//                            isActive: $viewModel.showResetPassword
//                        )
//                        {
//                            EmptyView()
//                        }
//                        NavigationLink(
//                            destination: SignupView(),
//                            isActive: $viewModel.showSignup
//                        ) {
//                            EmptyView()
//                        }
//
//                        // Navigate to ResetPasswordView if reset requested
////                        NavigationLink(
////                            destination: ResetPasswordView(email: viewModel.resetEmail),
////                            isActive: $viewModel.showResetPassword
////                        ) {
////                            EmptyView()
////                        }
//
//                        Spacer()
//                    }
//                    .padding()
//                    .alert(isPresented: $viewModel.showError) {
//                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
//                    }
//                }
//            }
//        }
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
//                Image(systemName: iconName)
//                    .foregroundColor(.white.opacity(0.7))
//                
//                if isShowingPassword {
//                    TextField(placeholder, text: $text)
//                        .foregroundColor(.white)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                } else {
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
//            LoginView()
//        }
//    }
//}
