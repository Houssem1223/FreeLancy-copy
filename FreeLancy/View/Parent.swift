//
//  Parent.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 19/11/2024.
//

import SwiftUI
struct ParentView: View {
    @State private var otpText = ""
    @State private var showNextView = false
    @State private var email = "test@example.com" // Now a @State variable

    var body: some View {
        VerifyOtpView(
            otpText: $otpText,
            showResetView: .constant(false),
            showNextView: $showNextView,
            viewModel: VerifyOtpViewModel(email: email, generatedOtp: "123456"),
            email: $email // Pass as a Binding
        )
    }
}

#Preview {
    ParentView()
}

