import SwiftUI
import SwiftUI
struct VerifyOtpView: View {
    @Binding var otpText: String
    @Binding var showResetView: Bool
    @Binding var showNextView: Bool
    @ObservedObject var viewModel: VerifyOtpViewModel
    
    @Environment(\.dismiss) private var dismiss

    @State private var resendDisabled = true
    @State private var countdown = 60
    @Binding var email: String // Add the email property
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: {
                dismiss() // Dismiss current sheet
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.gray)
            })
            .padding(.top, 15)

            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)

            Text("A 6-digit code has been sent to your email.")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.top, -5)

            VStack(spacing: 25) {
                OTPVerificationView(otpText: $otpText)

                Button(action: {
                    print("Email received in VerifyOtpView: \(email)")
                    viewModel.otp = otpText
                    viewModel.verifyOtp()
                    
                    if viewModel.showPasswordField {
                      
                        dismiss() // Dismiss current sheet
                        showNextView = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Verify")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .disabled(otpText.isEmpty)
                .opacity(otpText.isEmpty ? 0.5 : 1)

                if resendDisabled {
                    Text("Resend OTP in \(countdown) seconds")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Button("Resend OTP") {
                        viewModel.generatedOtp = viewModel.generateNewOtp()
                        startCountdown()
                    }
                    .font(.callout)
                    .foregroundColor(.blue)
                }
            }
            .padding(.top, 30)
        }
        .padding()
        .onAppear(perform: startCountdown)
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        NavigationLink(
            destination: ResetPasswordView(viewModel: ResetPasswordViewModel(email:email, otp: viewModel.otp)),
            isActive: $showNextView
        ) {
            EmptyView()
        }

         
    }

    private func startCountdown() {
        resendDisabled = true
        countdown = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 {
                resendDisabled = false
                timer.invalidate()
            }
        }
    }
}

//
//struct VerifyOtpView: View {
//    @Binding var otpText: String
//    @Binding var showResetView: Bool
//    @Binding var showNextView: Bool
//    @ObservedObject var viewModel: VerifyOtpViewModel
//    var email: String
//
//    var body: some View {
//        VStack {
//            Text("Verify OTP for \(email)") // Display email for debugging
//
//            Button(action: {
//                print("VerifyOtpView Email: \(email)")
//                print("VerifyOtpView OTP: \(otpText)")
//                viewModel.otp = otpText
//                viewModel.verifyOtp()
//
//                if viewModel.showPasswordField {
//                    showNextView = true
//                }
//            }) {
//                Text("Verify")
//            }
//
//            NavigationLink(
//                destination: ResetPasswordView(viewModel: ResetPasswordViewModel(email: email, otp: viewModel.otp)),
//                isActive: $showNextView
//            ) {
//                EmptyView()
//            }
//        }
//    }
//}

