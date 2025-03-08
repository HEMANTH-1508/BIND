import SwiftUI

struct SettingsScreen: View {
    
    var userId: String?
    
    var body: some View {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                NavigationLink(destination: ChangeUsernameView(userId: userId)) {
                    Text("Change Username")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                
                NavigationLink(destination: ChangePasswordView(userId: userId)) {
                    Text("Change Password")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                
                NavigationLink(destination: DeleteAccountView(userId: userId)) {
                    Text("Delete Account")
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true) 
        }
    }
