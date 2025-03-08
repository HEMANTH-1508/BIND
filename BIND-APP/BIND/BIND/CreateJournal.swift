import SwiftUI

struct CreateJournal: View {
    var selectedEmoji: String
    var userId: String?

    @State private var journalText = ""
    @State private var navigateToHome = false
    @State private var isSaving = false
    @State private var isRecording = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldNavigate = false
    @State private var username: String = "Loading..."

    let currentDate = Date()

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: currentDate)
    }

    var body: some View {
        VStack {
            HStack {
                Text("Welcome  \(username)")
                    .font(.title)
                    .textCase(.uppercase)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 120)

            }
            .padding(.horizontal, 20)

            Text(formattedDate)
                .font(.body)
                .foregroundColor(.black)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .topTrailing)

            ScrollView {
                TextEditor(text: $journalText)
                    .frame(minHeight: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
            }

            Spacer()

            Button(action: toggleRecording) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 60, height: 60)
                    .background(isRecording ? Color.red : Color.green)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.bottom, 10)

            Button(action: saveJournalEntry) {
                if isSaving {
                    ProgressView()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                } else {
                    Text("Save")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            }
            .padding(.top, 10)
            .disabled(isSaving)

            Button(action: { navigateToHome = true }) {
                Text("Back to Home")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(width: 200)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.top, 10)

            Spacer(minLength: 20)

            NavigationLink(destination: HomeView(userId: userId), isActive: $navigateToHome) {
                EmptyView()
            }

            NavigationLink(destination: HomeView(userId: userId), isActive: $shouldNavigate) {
                EmptyView()
            }
        }
        .background(Color(red: 0.62, green: 0.84, blue: 0.92))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage == "Journal saved successfully!" {
                        shouldNavigate = true
                    }
                }
            )
        }
        .onAppear {
            fetchUsername()
        }
        .onReceive(SpeechRecognizer.shared.$transcript) { newText in
            if isRecording {
                journalText = newText
            }
        }
    }

    private func fetchUsername() {
        guard let userId = userId else { return }

        let parameters: [String: String] = ["user_id": userId]

        APIService.shared.sendPostRequest(url: APIHandler.getUsername, parameters: parameters) { (result: Result<UsernameResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        username = response.username
                    } else {
                        username = ""
                    }
                case .failure:
                    username = "Error"
                }
            }
        }
    }

    private func saveJournalEntry() {
        guard let userId = userId, !journalText.isEmpty else {
            alertMessage = "Please enter journal text before saving."
            showAlert = true
            return
        }

        isSaving = true

        let parameters: [String: String] = [
            "user_id": userId,
            "mood": selectedEmoji,
            "data": journalText
        ]

        APIService.shared.sendPostRequest(url: APIHandler.addData, parameters: parameters) { (result: Result<JournalResponse, Error>) in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success(let response):
                    alertMessage = response.status ? "Journal saved successfully!" : "Failed to save: \(response.message)"
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                }
                showAlert = true
            }
        }
    }

    private func toggleRecording() {
        if isRecording {
            SpeechRecognizer.shared.stopTranscribing()
        } else {
            SpeechRecognizer.shared.startTranscribing()
        }
        isRecording.toggle()
    }
}

#Preview{
    CreateJournal(selectedEmoji: "happy", userId: "4")
}
