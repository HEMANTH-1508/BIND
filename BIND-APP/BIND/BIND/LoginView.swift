import SwiftUI

struct LoginView: View {
    @State private var email = "test@gmail.com"
    @State private var password = "147258"
    @State private var message = ""
    @State private var navigateToHome = false
    @State private var userId: String? = nil
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.62, green: 0.84, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)

                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)

                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }

                    NavigationLink(destination: HomeView(userId: userId), isActive: $navigateToHome) {
                        EmptyView()
                    }

                    Button(action: {
                        validateAndLogin()
                    }) {
                        Text("Login")
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

                    VStack(spacing: 10) {
                        NavigationLink(destination: SignUpView()) {
                            Text("Create one? Sign up")
                                .foregroundColor(.red)
                        }

                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.top, 100)

                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)

                        ProgressView("Logging in...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func validateAndLogin() {
        if email.isEmpty || password.isEmpty {
            message = "Please fill in both email and password."
            return
        }
        login()
    }

    func login() {
        isLoading = true

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        APIService.shared.sendPostRequest(url: APIHandler.login, parameters: parameters) { (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false 
                
                switch result {
                case .success(let response):
                    if response.status {
                        if let userData = response.data {
                            self.userId = String(userData.id)
                            self.message = "Login successful!"
                            self.navigateToHome = true
                        } else {
                            self.message = "Invalid response format"
                        }
                    } else {
                        self.message = response.message
                    }
                case .failure:
                    self.message = "Wrong Credentials. Please try again."
                }
            }
        }
    }
}
