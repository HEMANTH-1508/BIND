import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var dob = Date()
    @State private var navigateToLogin = false
    @State private var message = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.62, green: 0.84, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)

                    VStack(spacing: 15) {
                        TextField("Username", text: $username)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)

                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)

                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .foregroundColor(.black)
                            } else {
                                SecureField("Password", text: $password)
                                    .foregroundColor(.black)
                            }
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm Password", text: $confirmPassword)
                                    .foregroundColor(.black)
                            } else {
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .foregroundColor(.black)
                            }
                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                        DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }

                    Button(action: {
                        if validateInputs() {
                            signUp()
                        }
                    }) {
                        Text("Sign Up")
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

                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        EmptyView()
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.black)

                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.top, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func validateInputs() -> Bool {
        if username.isEmpty {
            message = "Username cannot be empty."
            return false
        }
        if email.isEmpty {
            message = "Email cannot be empty."
            return false
        }
        if password.isEmpty {
            message = "Password cannot be empty."
            return false
        }
        if confirmPassword.isEmpty {
            message = "Please confirm your password."
            return false
        }
        if password != confirmPassword {
            message = "Passwords do not match."
            return false
        }
        return true
    }

    func signUp() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dobString = formatter.string(from: dob)

        let parameters: [String: String] = [
            "username": username,
            "email": email,
            "password": password,
            "confirm_password": confirmPassword,
            "dob": dobString
        ]

        APIService.shared.sendPostRequest(url: APIHandler.signUp, parameters: parameters) { (result: Result<SignUpResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.message = "User registered successfully!"
                        self.navigateToLogin = true
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
