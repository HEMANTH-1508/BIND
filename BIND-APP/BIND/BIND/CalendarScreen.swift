import SwiftUI

struct CalendarScreen: View {
    @State private var selectedDate = Date()
    @State private var journalEntries: [JournalEntry] = []
    @State private var isLoading = true
    @State private var alertMessage = ""
    @State private var showAlert = false

    var userId: String?
    let columns = [GridItem(.adaptive(minimum: 70))]

    var body: some View {
        ScrollView {
            VStack {
                Text("Select a Date")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)

                DatePicker("Pick a date", selection: $selectedDate, displayedComponents: .date)
                    .foregroundColor(.black)
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)

                if isLoading {
                    ProgressView("Loading entries...")
                        .padding()
                } else {
                    let filteredEntries = journalEntries.filter {
                        $0.date == formattedDate(selectedDate, format: "yyyy-MM-dd")
                    }

                    if filteredEntries.isEmpty {
                        Text("No entries for this date.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filteredEntries, id: \.id) { entry in
                                JournalEntryCard(entry: entry, onDelete: fetchJournalEntries)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                Spacer()
            }
            .background(Color(red: 0.62, green: 0.84, blue: 0.92))
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            fetchJournalEntries()
        }
        .onChange(of: journalEntries) { _ in
            fetchJournalEntries()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func formattedDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    private func fetchJournalEntries() {
        guard let userId = userId else { return }
        isLoading = true

        let parameters: [String: String] = ["user_id": userId]

        APIService.shared.sendPostRequest(url: APIHandler.getData, parameters: parameters) { (result: Result<JournalResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        journalEntries = response.data ?? []
                    } else {
                        alertMessage = "Failed to fetch entries: \(response.message)"
                        showAlert = true
                    }
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
