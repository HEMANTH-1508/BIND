import SwiftUI

struct ResetPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var message = ""
    @State private var isPasswordReset = false
    @State private var isNewPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    var email: String
    var dob: String

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)

                passwordField("Enter New Password", text: $newPassword, isVisible: $isNewPasswordVisible)
                    .foregroundColor(.black)

                passwordField("Confirm New Password", text: $confirmPassword, isVisible: $isConfirmPasswordVisible)
                    .foregroundColor(.black)

                Button(action: {
                    if validateInputs() {
                        resetPassword()
                    }
                }) {
                    Text("Save")
                        .font(.title2)
                        .frame(width: 200, height: 50)
                        .background(Color.white.opacity(0.25))
                        .foregroundColor(.red)
                        .cornerRadius(25)
                }
                .padding(.top, 10)

                Text(message)
                    .foregroundColor(.black)
                    .padding(.top, 10)

                Spacer()
            }
            .padding(.top, 100)

            NavigationLink(destination: LoginView(), isActive: $isPasswordReset) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func passwordField(_ placeholder: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        ZStack(alignment: .trailing) {
            Group {
                if isVisible.wrappedValue {
                    TextField(placeholder, text: text)
                } else {
                    SecureField(placeholder, text: text)
                }
            }
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .padding(.horizontal, 40)

            Button(action: {
                isVisible.wrappedValue.toggle()
            }) {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .padding(.trailing, 50)
            }
        }
    }

    func validateInputs() -> Bool {
        if newPassword.isEmpty || confirmPassword.isEmpty {
            message = "Please fill in both password fields."
            return false
        }
        if newPassword != confirmPassword {
            message = "Passwords do not match."
            return false
        }
        if newPassword.count < 6 {
            message = "Password must be at least 6 characters long."
            return false
        }
        return true
    }

    func resetPassword() {
        let parameters: [String: String] = [
            "email": email,
            "dob": dob,
            "new_password": newPassword,
            "confirm_password": confirmPassword
        ]

        APIService.shared.sendPostRequest(url: APIHandler.resetPassword, parameters: parameters) { (result: Result<PasswordResetResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.message = "Password reset successful."
                        self.isPasswordReset = true
                    } else {
                        self.message = response.message
                    }
                case .failure(let error):
                    self.message = "Network error: \(error.localizedDescription)"
                }
            }
        }
    }
}
