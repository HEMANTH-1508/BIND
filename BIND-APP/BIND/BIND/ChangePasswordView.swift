import SwiftUI

struct ChangePasswordView: View {
    var userId: String?
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isPasswordChanged = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Change Password")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 40)

                VStack(spacing: 20) {
                    SecureField("Enter old password", text: $oldPassword)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    SecureField("Enter new password", text: $newPassword)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    SecureField("Confirm new password", text: $confirmPassword)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                Button(action: {
                    changePassword()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 250, height: 50)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.red)
                            .cornerRadius(25)
                    } else {
                        Text("Change Password")
                            .font(.title2)
                            .frame(width: 250, height: 50)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.red)
                            .cornerRadius(25)
                    }
                }
                .padding(.top, 30)
                .disabled(isLoading)

                if isPasswordChanged {
                    NavigationLink(destination: LoginView(), isActive: $isPasswordChanged) {
                        EmptyView()
                    }
                }

                Spacer()
            }
            .padding(.top, 100)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(false)
    }

    private func changePassword() {
        guard let userId = userId, !oldPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        guard newPassword == confirmPassword else {
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }

        isLoading = true
        let parameters: [String: String] = [
            "user_id": userId,
            "old_password": oldPassword,
            "new_password": newPassword
        ]

        APIService.shared.sendPostRequest(url: APIHandler.changePassword, parameters: parameters) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        isPasswordChanged = true
                    } else {
                        alertMessage = response.message
                        showAlert = true
                    }
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
