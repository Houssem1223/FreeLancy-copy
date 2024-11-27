import SwiftUI
import Combine
class ResetPasswordViewModel: ObservableObject {
    @Published var newPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    @Published var email: String
    @Published  var otp: String
    
    init(email: String, otp: String) {
        self.email = email
        self.otp = otp
        print("Initialized ResetPasswordViewModel with email: \(self.email), otp: \(self.otp)")
    }
    
  
     
    func resetPassword() {
        print("Email: \(email)") // Debug log
        print("OTP: \(otp)") // Debug log
        
        guard !newPassword.isEmpty else {
            errorMessage = "New password is required."
            showError = true
            return
        }

        let url = URL(string: "http://172.18.24.114:3000/user/reset-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = ["username": email, "otp": otp, "newPassword": newPassword]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure = completionStatus {
                    self.errorMessage = "Failed to reset password."
                    self.showError = true
                }
            }, receiveValue: { success in
                if success {
                    self.errorMessage = "Password reset successful."
                    self.showSuccess = true
                }
            })
            .store(in: &cancellables)
    }
}
