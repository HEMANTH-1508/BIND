import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("1. Data Collection")
                            .font(.title2)
                            .bold()
                        Text("We collect personal data such as your username, email, and the entries you make in your journal. This data is stored securely and is used only for the purpose of providing personalized journal entries and other app features.")

                        Text("2. Data Security")
                            .font(.title2)
                            .bold()
                        Text("Your data is encrypted and securely stored on our servers. We take all necessary steps to ensure your information remains private and protected from unauthorized access.")
                        
                        Text("3. User Consent")
                            .font(.title2)
                            .bold()
                        Text("By using our app, you consent to the collection and use of your personal data as described in this policy. You can revoke consent at any time by deleting your account.")

                        Text("4. Data Sharing")
                            .font(.title2)
                            .bold()
                        Text("We do not share your personal information with third parties unless required by law or necessary for app functionality, such as sending notifications or updates.")

                        Text("5. Data Retention")
                            .font(.title2)
                            .bold()
                        Text("Your journal entries and personal data will be retained as long as you continue to use the app. You can request deletion of your account and data at any time via the settings.")

                        Text("6. Changes to Policy")
                            .font(.title2)
                            .bold()
                        Text("We may update our privacy policy from time to time. All changes will be communicated via the app.")

                        Text("7. Contact Us")
                            .font(.title2)
                            .bold()
                        Text("If you have any questions about this privacy policy, please contact us at")
                        
                        Button(action:{
                            sendEmail()
                        }) {
                            Text("bind@gmail.com")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(false)
    }
    
    func sendEmail() {
        let email = "hemanthkonathala2004@gmail.com"
        let subject = "Inquiry about Privacy Policy"
        let body = "Hello, I have a question about your privacy policy."
        
        let emailString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        if let emailURL = URL(string: emailString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                print("❌ Error: Cannot open Mail app.")
            }
        } else {
            print("❌ Error: Invalid email URL.")
        }
    }
}

