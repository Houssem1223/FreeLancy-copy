//
//  RoleViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 26/11/2024.
//


import Foundation

class RoleViewModel: ObservableObject {
    // Default role
    
    // Function to update role in the database
    func updateRole(for username: String, to newRole: String, completion: @escaping (Bool) -> Void) {
        print(newRole)
        // Simulate an API call or database update
        guard let url = URL(string: "http://172.18.4.45:3000/user/update-role") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = ["userId": username, "role": newRole]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating role: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                      print("Invalid response")
                      completion(false)
                      return
                  }

                  if httpResponse.statusCode == 200 {
                      print("Role updated successfully!")
                      completion(true)
                  } else {
                      print("Failed to update role, status code: \(httpResponse.statusCode)")
                      completion(false)
                  }
              }.resume()
          }
}
