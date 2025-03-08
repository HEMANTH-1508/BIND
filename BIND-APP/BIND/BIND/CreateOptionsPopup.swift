import SwiftUI

struct CreateOptionsPopup: View {
    @Binding var showCreateOptions: Bool
    var userId: String?
    
    var body: some View {
        VStack {
            Text("Select an option:")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
            
            HStack {
                NavigationLink(destination: CreateEvent(userId: userId)) {
                    Text("Event")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: EmojiSelector(userId: userId)) {
                    Text("Journal")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom)
            
            Button(action: {
                self.showCreateOptions = false
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 40)
                    .background(Color.red)
                    .cornerRadius(20)
                    .padding(.vertical, 10)
            }
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
