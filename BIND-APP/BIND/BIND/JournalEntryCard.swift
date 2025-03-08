import SwiftUI

struct JournalEntryCard: View {
    let entry: JournalEntry
    @State private var showDetail = false
    var onDelete: (() -> Void)?

    var body: some View {
        VStack {
            Button(action: {
                showDetail.toggle()
            }) {
                HStack {
                    Image(entry.mood)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showDetail) {
                JournalDetailView(entry: entry) {
                    showDetail = false
                    onDelete?()
                }
            }
        }
    }
}
