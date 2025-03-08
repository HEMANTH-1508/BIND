import SwiftUI

struct EventCard: View {
    var title: String
    var date: String
    
    private var randomColor: Color {
        let colors: [Color] = [
            Color.yellow.opacity(0.8),
            Color.blue.opacity(0.6),
            Color.green.opacity(0.5),
            Color.orange.opacity(0.6),
            Color.purple.opacity(0.4),
            Color.pink.opacity(0.5),
            Color.brown.opacity(0.4),
            Color.indigo.opacity(0.6),
            Color.cyan.opacity(0.5),
            Color.mint.opacity(0.4)
        ]
        return colors.randomElement() ?? Color.yellow.opacity(0.8)
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(" Event Date: \(date)")
                .font(.subheadline)
                .foregroundColor(.black)
            
            Text(title)
                .font(.body)
                .foregroundColor(.black)
                .bold()
        }
        .padding()
        .frame(width: 320, height: 80)
        .background(randomColor)
        .cornerRadius(15)
        .padding(.vertical, 5)
    }
}
