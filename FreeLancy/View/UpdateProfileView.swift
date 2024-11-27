import SwiftUI

struct UpdateProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: UpdateProfileViewModel

    var body: some View {
        ZStack {
            Color.white // Set the background to white
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Title
                Text("Update Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue) // Blue title
                    .padding(.top, 50)

                // Username and Email Text Fields
                CustomTextField(
                    iconName: "person",
                    placeholder: "New Username",
                    text: $viewModel.newUsername
                )
                CustomTextField(
                    iconName: "envelope",
                    placeholder: "New Email",
                    text: $viewModel.newEmail
                )

                Spacer()

                // Update Button
                Button(action: {
                    viewModel.showConfirmationAlert = true
                }) {
                    Text("Update Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 20)
                }
                .alert(isPresented: $viewModel.showConfirmationAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to update this profile?"),
                        primaryButton: .default(Text("OK")) {
                            viewModel.updateProfile()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .onChange(of: viewModel.showSuccess) { success in
                if success {
                    presentationMode.wrappedValue.dismiss() // Automatically dismiss on success
                }
            }
//            .alert(isPresented: $viewModel.showError) {
//                Alert(
//                    title: Text("Error"),
//                    message: Text(viewModel.errorMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            .alert(isPresented: $viewModel.showSuccess) {
//                Alert(
//                    title: Text("Success"),
//                    message: Text("Profile updated successfully!"),
//                    dismissButton: .default(Text("OK")) {
//                        presentationMode.wrappedValue.dismiss() // Dismiss on success
//                    }
//                )
            
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        
    }
}
struct CustomTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.gray.opacity(0.1)) // Light gray background
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}



struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView(viewModel: UpdateProfileViewModel(username: ""))
    }
}


