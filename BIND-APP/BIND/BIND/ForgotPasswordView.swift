import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var dob = Date()
    @State private var isVerified = false
    @State private var verificationMessage = ""
    @State private var verifiedEmail: String?
    @State private var verifiedDob: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.62, green: 0.84, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Forgot Password?")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)

                    Text("Enter your email and DOB to reset your password")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.black)
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

                    NavigationLink(destination: ResetPasswordView(email: verifiedEmail ?? "", dob: verifiedDob ?? ""), isActive: $isVerified) {
                        EmptyView()
                    }

                    Button(action: {
                        if validateInputs() {
                            verifyUser()
                        }
                    }) {
                        Text("Verify & Reset")
                            .font(.title2)
                            .frame(width: 200, height: 50)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.red)
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)

                    Text(verificationMessage)
                        .foregroundColor(.black)
                        .padding(.top, 10)

                    Spacer()
                }
                .padding(.top, 100)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func validateInputs() -> Bool {
        if email.isEmpty {
            verificationMessage = "Email cannot be empty."
            return false
        }
        if Calendar.current.isDate(dob, inSameDayAs: Date()) {
            verificationMessage = "Please select a valid date of birth."
            return false
        }
        return true
    }

    func verifyUser() {
        let parameters: [String: String] = [
            "email": email,
            "dob": formatDate(dob)
        ]

        APIService.shared.sendPostRequest(url: APIHandler.forgotPassword, parameters: parameters) { (result: Result<VerifyResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.verificationMessage = "Verified! You can reset your password."
                        self.verifiedEmail = self.email
                        self.verifiedDob = self.formatDate(self.dob)
                        self.isVerified = true
                    } else {
                        self.verificationMessage = response.message
                    }
                case .failure(let error):
                    self.verificationMessage = "Network error: \(error.localizedDescription)"
                }
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
