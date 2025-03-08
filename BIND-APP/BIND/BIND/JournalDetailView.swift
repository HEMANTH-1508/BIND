import SwiftUI

struct JournalDetailView: View {
    let entry: JournalEntry
    var onDelete: (() -> Void)?

    private var randomColor: Color {
        let colors: [Color] = [
            Color.yellow.opacity(0.8),
            Color.indigo.opacity(0.6),
            Color.green.opacity(0.5),
            Color.orange.opacity(0.6),
            Color.purple.opacity(0.4),
            Color.pink.opacity(0.5)
        ]
        return colors.randomElement() ?? Color.yellow.opacity(0.8)
    }
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            randomColor
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    HStack {
                        Spacer()

                        Button(action: {
                            deleteEntry(entryId: entry.id)
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.title2)
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .padding()

                    Text(entry.date.capitalized)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)

                    Text(entry.mood.capitalized)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)
                    Text(entry.data)
                        .font(.body)
                        .padding()

                    Spacer()
                }
                .padding()
            }
        }
    }

    private func deleteEntry(entryId: Int) {
        APIService.shared.sendPostRequest(url: APIHandler.deleteData, parameters: ["data_id": "\(entryId)"]) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        onDelete?()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Failed to delete entry: \(response.message)")
                    }
                case .failure(let error):
                    print("API error: \(error.localizedDescription)")
                }
            }
        }
    }
}


