//
//  ProfileViewModel.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var username: String
    //@Published var email: String
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    init(username: String) {
        self.username = username
        
    }

    // Method to update the profile information
    func updateProfile(newUsername: String, newEmail: String) {
        // Example logic: Validate new data and update it (could be saved in CoreData or API)
        if newUsername.isEmpty || newEmail.isEmpty {
            self.errorMessage = "Please fill in both fields"
            self.showError = true
        } else {
            self.username = newUsername
            //self.email = newEmail
            // Save to CoreData or API here
        }
    }

    // Method to delete the profile
    func deleteProfile() {
        // Logic to delete the profile (from CoreData or API)
        self.username = ""
    }
}

