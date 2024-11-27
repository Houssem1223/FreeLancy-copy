//
//  LoginViewModel.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var role: String = ""
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var loggedInUsername: String = ""
    @Published var resetEmail: String = ""
    @Published var showResetPassword: Bool = false
    @Published var showSignup: Bool = false
    // Handle login logic
    func handleLogin() {
        // Validate input fields
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password required."
            showError = true
            return
        }

        // Configure API URL and request
        let loginUrl = URL(string: "http://172.18.6.197:3000/user/loginA")! // Login endpoint
        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = ["username": username, "password": password]
        loginRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        // Perform the login API call
        URLSession.shared.dataTask(with: loginRequest) { data, response, error in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.showError = true
                }
                return
            }

            // Handle invalid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid username or password."
                    self.showError = true
                }
                return
            }

            // Handle valid response
            if let data = data {
                do {
                    // Parse the login response
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let accessToken = responseJSON["access_token"] as? String,
                       let userId = responseJSON["id"] as? String { // Assume the login response includes a "role" field
                        DispatchQueue.main.async {
                            print("JWT Token: \(accessToken)")
                            print("id: \(userId)")
                            
                            // Fetch role details
                        self.fetchRoleDetails(userId: userId) // Fetch role details based on the name
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Invalid response format."
                            self.showError = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse server response."
                        self.showError = true
                    }
                }
            }
        }.resume()
    }

    func fetchRoleDetails(userId: String) {
        // API URL for fetching role ID
        let roleUrl = URL(string: "http://172.18.6.197:3000/user/getIdRole")! // Adjust endpoint
        var roleRequest = URLRequest(url: roleUrl)
        roleRequest.httpMethod = "POST"
        roleRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add the userId to the request body
        let requestBody: [String: String] = ["id": userId]
        roleRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        // Perform the role API call
        URLSession.shared.dataTask(with: roleRequest) { data, response, error in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch role: \(error.localizedDescription)"
                    self.showError = true
                }
                return
            }

            // Handle invalid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch role details."
                    self.showError = true
                }
                return
            }

            // Handle valid response
            if let data = data {
                do {
                    // Parse the role response
                    if let roleJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let roleId = roleJSON["idRole"] as? String { // Adjust based on your API response
                        DispatchQueue.main.async {
                            self.role = roleId // Update the role ID
                            self.isLoggedIn = true // Trigger navigation or update UI
                            print("Role ID: \(roleId)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Invalid role response format."
                            self.showError = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse role response."
                        self.showError = true
                    }
                }
            }
        }.resume()
    }

    func handleForgotPassword() {
        guard !username.isEmpty else {
            errorMessage = "Please enter your username."
            showError = true
            return
        }

        let url = URL(string: "http://172.18.24.114:3000/user/forgot-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: String] = ["username": username]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Request failed: \(error.localizedDescription)"
                    self.showError = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.resetEmail = self.username
                    self.showResetPassword = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "No account found for this username."
                    self.showError = true
                }
            }
        }.resume()
    }
}

