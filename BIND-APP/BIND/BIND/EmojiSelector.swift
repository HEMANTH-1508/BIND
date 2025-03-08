import SwiftUI

struct EmojiSelector: View {
    var userId: String?
    let emojiNames = ["happy", "angry", "sad", "cry", "disappointed", "crazy", "cool", "funny", "excited"]
    
    @State private var selectedEmoji: String?
    
    var body: some View {
        VStack {
            Text("Select an Emoji")
                .font(.title)
                .foregroundColor(.black)
                .bold()
                .padding(.top, 120)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(emojiNames, id: \.self) { emoji in
                    Button(action: {
                        selectedEmoji = emoji
                    }) {
                        Image(emoji)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(5)
                }
            }
            .padding()

            if let selectedEmoji = selectedEmoji {
                NavigationLink(destination: CreateJournal(selectedEmoji: selectedEmoji, userId: userId)) {
                    Text("Proceed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 200, height: 50)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
            }

            NavigationLink(destination: HomeView(userId: userId)) {
                Text("Back")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(Color.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .shadow(radius: 10)
            }
            .padding(.top, 10)

            Spacer()
        }
        .background(Color(red: 0.62, green: 0.84, blue: 0.92))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}
