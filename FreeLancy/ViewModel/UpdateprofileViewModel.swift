import SwiftUI
import Combine

class UpdateProfileViewModel: ObservableObject {
    @Published var username: String
    @Published var newUsername: String = ""
    @Published var newEmail: String = ""
    
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMessage: String = ""
    @Published var showConfirmationAlert: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "http://172.18.24.114:3000" // Replace with your actual backend base URL
    
    init(username: String) {
        self.username = username
        self.newUsername = username
    }
    
    func fetchUserId(username: String, completion: @escaping (String?) -> Void) {
            guard let fetchUrl = URL(string: "\(baseURL)/user/get-id") else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL."
                    self.showError = true
                    completion(nil)
                }
                return
            }
            
        var request = URLRequest(url: fetchUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = ["username": username]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> String in
                    // Ensure the server response is valid
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "No valid server response."])
                    }
                    
                    guard httpResponse.statusCode == 201 else {
                        let serverMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                        throw NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Unexpected server response (\(httpResponse.statusCode)): \(serverMessage)"]
                        )
                    }

                    // Parse the response JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let id = json?["id"] as? String else {
                        throw NSError(
                            domain: "Parse Error",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Unable to parse user ID from response."]
                        )
                    }

                    return id
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completionStatus in
                    switch completionStatus {
                    case .failure(let error):
                        // Handle errors
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                        completion(nil)
                    case .finished:
                        break
                    }
                }, receiveValue: { id in
                    // Provide the user ID on success
                    completion(id)
                })
                .store(in: &cancellables)
        }
    func updateProfile() {
        guard !newUsername.isEmpty,!newEmail.isEmpty else {
            errorMessage = "Username cannot be empty."
            showError = true
            print("Error: Username and email are empty.")
            return
        }

        // Fetch the user ID first
        fetchUserId(username: self.username) { [weak self] userId in
            guard let self = self else { return } // Safeguard against potential memory leaks
            guard let userId = userId else {
                // Error handling is already managed in fetchUserId
                return
            }

            // Construct the update request
            guard let updateUrl = URL(string: "\(self.baseURL)/user/update") else {
                       self.errorMessage = "Invalid URL."
                       self.showError = true
                       return
                   }

                   var updateRequest = URLRequest(url: updateUrl)
                   updateRequest.httpMethod = "PATCH"
                   updateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                   
                   let updateBody: [String: String] = [
                       "id": userId,
                       "username": self.newUsername,
                       "email":newEmail
                   ]
                   updateRequest.httpBody = try? JSONSerialization.data(withJSONObject: updateBody)

                   URLSession.shared.dataTask(with: updateRequest) { data, response, error in
                       DispatchQueue.main.async {
                           if let error = error {
                               self.errorMessage = "Network error: \(error.localizedDescription)"
                               self.showError = true
                               return
                           }

                           guard let httpResponse = response as? HTTPURLResponse else {
                               self.errorMessage = "Unexpected response from the server."
                               self.showError = true
                               return
                           }
                           print("updateProfile Response Code: \(httpResponse.statusCode)")
                           if httpResponse.statusCode == 200 {
                               self.username = self.newUsername
                               self.newEmail = self.newEmail
                               self.errorMessage = "Profile updated successfully."
                               self.showSuccess = true
                               print("Profile updated successfully.")
                           } else {
                               let serverError = data.flatMap {
                                   String(data: $0, encoding: .utf8)
                               } ?? "Unknown error"
                               
                               self.errorMessage = "Update failed: \(serverError) (Code: \(httpResponse.statusCode))"
                               self.showError = true
                               print("Update failed: \(serverError) (Code: \(httpResponse.statusCode))")
                           }
                       }
                   }.resume()
               }
    }

}
