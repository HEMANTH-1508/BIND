import SwiftUI

struct ChangeUsernameView: View {
    var userId: String?
    @State private var oldUsername = ""
    @State private var newUsername = ""
    @State private var isUsernameChanged = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Change Username")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 40)

                VStack(spacing: 20) {
                    TextField("Enter old username", text: $oldUsername)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    TextField("Enter new username", text: $newUsername)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                Button(action: {
                    changeUsername()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(width: 250, height: 50)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.red)
                            .cornerRadius(25)
                    } else {
                        Text("Change Username")
                            .font(.title2)
                            .frame(width: 250, height: 50)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.red)
                            .cornerRadius(25)
                    }
                }
                .padding(.top, 30)
                .disabled(isLoading)

                if isUsernameChanged {
                    NavigationLink(destination: LoginView(), isActive: $isUsernameChanged) {
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

    private func changeUsername() {
        guard let userId = userId, !oldUsername.isEmpty, !newUsername.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        isLoading = true
        let parameters: [String: String] = [
            "user_id": userId,
            "old_username": oldUsername,
            "new_username": newUsername
        ]

        APIService.shared.sendPostRequest(url: APIHandler.changeUserName, parameters: parameters) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        isUsernameChanged = true
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

