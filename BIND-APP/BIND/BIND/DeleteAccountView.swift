import SwiftUI

struct DeleteAccountView: View {
    var userId: String?
    @State private var email = ""
    @State private var password = ""
    @State private var isAccountDeleted = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Delete Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 40)

                VStack(spacing: 20) {
                    TextField("Enter your email", text: $email)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    SecureField("Enter your password", text: $password)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                if !email.isEmpty && !password.isEmpty {
                    Text("Are you sure you want to delete your account? This action cannot be undone.")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                }

                Button(action: {
                    deleteAccount()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 250, height: 50)
                            .background(Color.gray)
                            .cornerRadius(25)
                    } else {
                        Text("Verify & Delete Account")
                            .font(.title2)
                            .frame(width: 250, height: 50)
                            .background(email.isEmpty || password.isEmpty ? Color.gray : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1)
                    }
                }
                .padding(.top, 30)
                .disabled(isLoading || email.isEmpty || password.isEmpty)

                Spacer()

                if isAccountDeleted {
                    NavigationLink(destination: WelcomeView(), isActive: $isAccountDeleted) {
                        EmptyView()
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Account"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(false)
    }

    private func deleteAccount() {
        guard let userId = userId, !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        isLoading = true

        let parameters: [String: String] = [
            "user_id": userId,
            "email": email,
            "password": password
        ]

        APIService.shared.sendPostRequest(url: APIHandler.deleteUser, parameters: parameters) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        isAccountDeleted = true
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
