import SwiftUI

@main
struct BINDApp: App {
    
    init() {
        addKeyboardDismissGesture()
    }
    
    
    var body: some Scene {
        WindowGroup {
            IntroVideoView()
                .preferredColorScheme(.light)
        }
    }
}

extension BINDApp {
    private func addKeyboardDismissGesture() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapGesture.cancelsTouchesInView = false
            window.addGestureRecognizer(tapGesture)
        }
    }
}
