import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.62, green: 0.84, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 40) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 255, height: 215)
                        .cornerRadius(20)

                    Text("WAITING FOR YOUR MEMORIES")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.orange)

                    Spacer()

                    VStack(spacing: 20) {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.title2)
                                .frame(width: 255, height: 64)
                                .background(Color.white.opacity(0.25))
                                .cornerRadius(50)
                                .foregroundColor(Color.red)
                        }

                        NavigationLink(destination: SignUpView()) {
                            Text("Create Account")
                                .font(.title2)
                                .frame(width: 255, height: 64)
                                .background(Color.white.opacity(0.25))
                                .cornerRadius(50)
                                .foregroundColor(Color.red)
                        }
                    }

                    Spacer()
                }
                .padding(.vertical, 50)
            }
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    WelcomeView()
}
