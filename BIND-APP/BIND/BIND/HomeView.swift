import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    var userId: String?

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 60)
                    

                    Spacer()

                    Button(action: {
                        UIApplication.shared.windows.first?.rootViewController =
                            UIHostingController(rootView: WelcomeView())
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                switch selectedTab {
                case 0: HomeScreen(userId: userId)
                case 1: CalendarScreen(userId: userId)
                case 2: InsightsScreen(userId: userId)
                case 3: SettingsScreen(userId: userId)
                default: HomeScreen(userId: userId)
                }

                Spacer()

                CurvedTabBar(selectedTab: $selectedTab)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    struct CurvedTabBar: View {
        @Binding var selectedTab: Int

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 80)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 5)
                    .overlay(
                        HStack {
                            TabBarButton(icon: "house.fill", index: 0, selectedTab: $selectedTab)
                            Spacer()
                            TabBarButton(icon: "calendar", index: 1, selectedTab: $selectedTab)
                            Spacer()
                            TabBarButton(icon: "chart.bar.fill", index: 2, selectedTab: $selectedTab)
                            Spacer()
                            TabBarButton(icon: "gearshape.fill", index: 3, selectedTab: $selectedTab)
                        }
                        .padding(.horizontal, 40)
                    )
                    .padding(.horizontal, 20)
            }
        }
    }

    struct TabBarButton: View {
        var icon: String
        var index: Int
        @Binding var selectedTab: Int

        var body: some View {
            Button(action: {
                selectedTab = index
            }) {
                VStack {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == index ? .red : .gray)

                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(selectedTab == index ? .red : .clear)
                }
                .padding(.vertical, 10)
            }
        }
    }
}
