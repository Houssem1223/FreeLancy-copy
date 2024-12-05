//
//  SignupViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 26/11/2024.
//

import SwiftUI
import Combine

class SignupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var role: String = "Freelancer"
    @Published var avatarUrl: String = ""
    @Published var skills: String = ""



    

    @Published var confirmPassword: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showSuccess: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    func signup() {
        guard validateInputs() else { return }
        
        let url = URL(string: "http://172.18.4.45:3000/user/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = [
            "username": username,
            "email": email,
            "password": password,
            "role": role,
            "avatarUrl": avatarUrl,
            "skills": skills,

           

        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Sign-up failed: \(error.localizedDescription)"
                    self?.showError = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self?.errorMessage = "Account created successfully."
                } else {
                    self?.errorMessage = "Failed to create account."
                    
                }
                self?.showError = true
            }
        }.resume()
    }
    
    private func validateInputs() -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please check your entries."
            showError = true
            return false
        }
        return true
    }
}

