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
        let loginUrl = URL(string: "http://172.18.4.45:3000/user/loginA")! // Login endpoint
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
                       let userId = responseJSON["id"] as? String ,
                        let username = responseJSON["username"] as? String{
                        DispatchQueue.main.async {
                            // Save access token and user ID to UserDefaults
                            KeychainHelper.save(key: "accessToken", value: accessToken)
                            KeychainHelper.save(key: "userId", value: userId)
                            KeychainHelper.save(key: "username", value: username)
                           
                            
                            print("JWT Token: \(accessToken)")
                            print("User ID: \(userId)")
                            print("User : \(username)")
                            // Fetch role details
                            self.fetchRoleDetails(userId: userId)
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
        let roleUrl = URL(string: "http://172.18.4.45:3000/user/getIdRole")! // Adjust endpoint
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
                       let roleId = roleJSON["idRole"] as? String {
                        DispatchQueue.main.async {
                            // Save role ID to UserDefaults
                            KeychainHelper.save(key: "roleId", value: roleId)
                            
                            self.role = roleId
                            self.isLoggedIn = true
                            
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
    func logout() {
            // Clear session data
            KeychainHelper.delete(key: "accessToken")
            KeychainHelper.delete(key: "userId")
            KeychainHelper.delete(key: "roleId")

            // Reset app state
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.username = ""
                self.role = ""
            }

            print("User logged out successfully.")
        }
    }

