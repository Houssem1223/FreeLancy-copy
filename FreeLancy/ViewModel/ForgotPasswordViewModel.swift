//
//  ForgotPasswordViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 17/11/2024.
//

import Foundation
import SwiftUI
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var showOtpField: Bool = false
    @Published var generatedOtp: String = ""
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func handleForgotPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your username."
            showError = true
            return
        }
        
        let url = URL(string: "http://172.18.6.197:3000/user/forgot-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = ["username": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let otp = jsonResponse["otp"] as? String {
                    return otp
                } else {
                    throw URLError(.cannotParseResponse)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure = completionStatus {
                    self.errorMessage = "No account found for this username."
                    self.showError = true
                }
            }, receiveValue: { otp in
                self.generatedOtp = otp
                self.showOtpField = true
            })
            .store(in: &cancellables)
    }
}
