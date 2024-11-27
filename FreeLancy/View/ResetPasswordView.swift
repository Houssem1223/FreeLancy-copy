import SwiftUI
struct ResetPasswordView: View {
    @ObservedObject var viewModel: ResetPasswordViewModel
    @State private var navigateToLogin = false
    var body: some View {
        VStack(spacing: 20) {
            SecureField("Enter New Password", text: $viewModel.newPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Reset Password") {
                viewModel.resetPassword()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $viewModel.showSuccess) {
                Alert(title: Text("Success"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK"),action: {
                    navigateToLogin = true // Trigger navigation on success
                }))
            }
            NavigationLink(
                           destination: LoginView(),
                           isActive: $navigateToLogin
                       ) {
                           EmptyView()
                       }
                   }
        .padding()
    }
}
