import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: ForgotPasswordViewModel
    @Binding var showVerifyOtpSheet: Bool
    @State var email: String
    
    @State private var otpText = ""
    @State private var showNextView = false // State to navigate to the next view

    var body: some View {
        VStack {
            // Email TextField
            TextField("Enter your email", text: $viewModel.email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 20)

            // Send OTP Button
            Button(action: {
                print("Email entered in ForgotPasswordView: \(viewModel.email)")
                viewModel.handleForgotPassword()
                showVerifyOtpSheet = true // Trigger the sheet
            }) {
                Text("Send OTP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }

            // NavigationLink to ResetPasswordView
            NavigationLink(
                destination: ResetPasswordView(
                    viewModel: ResetPasswordViewModel(
                        email: viewModel.email, // Use email from ViewModel
                        otp: otpText            // Use otpText from state
                    )
                ),
                isActive: $showNextView
            ) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showVerifyOtpSheet) {
            VerifyOtpView(
                otpText: $otpText,
                showResetView: .constant(false),
                showNextView: $showNextView,
                viewModel: VerifyOtpViewModel(email: viewModel.email, generatedOtp: viewModel.generatedOtp),
                email: $viewModel.email
            )
            .presentationDetents([.medium, .large]) // Stops at the middle or goes full-screen
            .presentationDragIndicator(.visible) // Optional: Drag indicator at the top
        }
    }
}
