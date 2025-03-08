import SwiftUI
import AVKit

struct IntroVideoView: View {
    @State private var player: AVPlayer?
    @State private var isVideoFinished = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let videoURL = Bundle.main.url(forResource: "intro", withExtension: "mp4") {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onAppear {
                        let playerItem = AVPlayerItem(url: videoURL)
                        let avPlayer = AVPlayer(playerItem: playerItem)
                        player = avPlayer
                        avPlayer.play()

                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: playerItem,
                            queue: .main
                        ) { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isVideoFinished = true
                            }
                        }
                    }
                    .allowsHitTesting(false)
            } else {
                Text("❌ Video Not Found in Bundle!")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
            }
        }
        .fullScreenCover(isPresented: $isVideoFinished) {
            WelcomeView()
        }
    }
}


