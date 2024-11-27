//
//  VerifyOtpViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 17/11/2024.
//

import Foundation

class VerifyOtpViewModel: ObservableObject {
    @Published var otp: String = ""
    @Published var showPasswordField: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false

    var generatedOtp: String

   
    @Published  var email: String = ""

       init(email: String, generatedOtp: String) {
           self.email = email
           self.generatedOtp = generatedOtp
       }

    // Verify OTP Logic
    func verifyOtp() {
        guard !otp.isEmpty else {
            errorMessage = "OTP is required."
            showError = true
            return
        }

        if otp == generatedOtp {
            showPasswordField = true
        } else {
            errorMessage = "Invalid OTP."
            showError = true
        }
    }

    // Generate New OTP (Mock Functionality)
    func generateNewOtp() -> String {
        let newOtp = String((0..<6).map { _ in "0123456789".randomElement()! })
        return newOtp
    }
}
