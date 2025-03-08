import SwiftUI
import Charts

struct InsightsScreen: View {
    var userId: String?

    @State private var moodData: [MoodEntry] = []
    @State private var moodCounts: [(String, Int)] = []
    @State private var isLoading = true
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var selectedMood: String? = nil
    
    let moodColors: [String: Color] = [
        "happy": .yellow,
        "cool": .blue,
        "angry": .red,
        "crazy": .green,
        "excited": .orange,
        "disappointed": .gray,
        "sad": .purple,
        "funny": .pink,
        "cry": .cyan
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Loading insights...")
                        .padding()
                } else if moodCounts.isEmpty {
                    VStack{
                        Text("No journal entries found for this month.")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                        Image("no data")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding()
                    }
                } else {
                    VStack {
                        Chart {
                            ForEach(moodCounts, id: \.0) { mood, count in
                                SectorMark(
                                    angle: .value("Count", count),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 5
                                )
                                .foregroundStyle(moodColors[mood] ?? .black)
                            }
                            .cornerRadius(15)
                        }
                        .frame(height: 300)
                        .padding()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(moodCounts, id: \.0) { mood, count in
                                    Button(action: {
                                        selectedMood = mood
                                    }) {
                                        HStack(spacing: 8) {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(moodColors[mood] ?? .black)
                                                .frame(width: 25, height: 25)
                                            
                                            Text(mood.capitalized)
                                                .foregroundColor(.black)
                                                .font(.body)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(selectedMood == mood ? Color.black.opacity(0.2) : Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .overlay(
                            Group {
                                if let selectedMood = selectedMood, let percentage = calculateMoodPercentage(mood: selectedMood) {
                                    Text("\(String(format: "%.2f", percentage))%")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background((moodColors[selectedMood] ?? Color.white).opacity(0.9))
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                        .transition(.opacity)
                                        .offset(x:0, y: -200)
                                }
                            }
                        )

                            

                    }


                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Emotional Trends")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.bottom, 5)

                        if let analysis = generateInsights() {
                            ForEach(analysis, id: \.self) { insight in
                                Text(insight)
                            }
                        }
                        
                        if let suggestion = Suggestion() {
                            Text("💡 Advice:")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                            
                            Text(suggestion)
                                .foregroundColor(.black)
                        }
                    }
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            fetchMoodData()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
    }

    private func fetchMoodData() {
        guard let userId = userId else { return }
        isLoading = true

        let parameters: [String: String] = ["user_id": userId]

        APIService.shared.sendPostRequest(url: APIHandler.getData, parameters: parameters) { (result: Result<JournalAPIResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        let currentMonthData = filterCurrentMonthEntries(response.data)
                        moodData = currentMonthData
                        moodCounts = processMoodData(moodData)
                    } else {
                        alertMessage = "Failed to retrieve data: \(response.message)"
                        showAlert = true
                    }
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func calculateMoodPercentage(mood: String) -> Double? {
            guard let moodCount = moodCounts.first(where: { $0.0 == mood })?.1 else { return nil }
            let totalMoods = moodCounts.reduce(0) { $0 + $1.1 }
            return (Double(moodCount) / Double(totalMoods)) * 100
        }

    private func filterCurrentMonthEntries(_ data: [MoodEntry]) -> [MoodEntry] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())

        return data.filter {
            guard let entryDate = parseDate($0.date) else { return false }
            let entryMonth = Calendar.current.component(.month, from: entryDate)
            let entryYear = Calendar.current.component(.year, from: entryDate)
            return entryMonth == currentMonth && entryYear == currentYear
        }
    }

    private func processMoodData(_ data: [MoodEntry]) -> [(String, Int)] {
        var moodFrequency: [String: Int] = [:]

        for entry in data {
            moodFrequency[entry.mood, default: 0] += 1
        }

        return moodFrequency.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }

    private func generateInsights() -> [String]? {
        guard !moodData.isEmpty else { return nil }

        let mostFrequentMood = moodCounts.max { $0.1 < $1.1 }?.0 ?? "Unknown"
        let totalEntries = moodData.count
        let positiveDays = findPositiveDays()
        let negativeDays = findNegativeDays()

        return [
            "😊 Most Frequent Mood: \(mostFrequentMood)",
            "📅 Total Entries: \(totalEntries)",
            "🌟 Positive Dates: \(positiveDays)",
            "⚡ Negative Dates: \(negativeDays)"
        ]
    }

    private func Suggestion() -> String? {
        guard let mostFrequentMood = moodCounts.max(by: { $0.1 < $1.1 })?.0 else { return nil }

        switch mostFrequentMood.lowercased() {
            case "happy":
                return "You're feeling happy! Keep engaging in activities that bring you joy, and share your positivity with others. Consider writing about what made you happy to reinforce those feelings."

            case "cool":
                return "You're in a relaxed and confident state. Enjoy the calm, and use this energy to focus on things that matter to you. Stay open to new experiences while maintaining this balance."

            case "angry":
                return "Anger can be a sign of frustration or unmet expectations. Try identifying the cause and addressing it calmly. Deep breaths, a short walk, or creative outlets like music or writing can help manage your emotions."

            case "crazy":
                return "You're feeling spontaneous and energetic! Use this burst of enthusiasm for something fun and creative. Just make sure to balance it with moments of rest and reflection."

            case "excited":
                return "Excitement is a great motivator! Channel your energy into something productive, whether it’s starting a new project, socializing, or celebrating an achievement."

            case "disappointed":
                return "Feeling disappointed can be tough, but setbacks are a part of growth. Try to shift your focus on what you’ve learned from the situation and remind yourself that better moments are ahead."

            case "sad":
                return "It's okay to feel sad. Acknowledge your emotions and take care of yourself. Talking to a close friend, listening to soothing music, or doing something comforting can help lighten your mood."

            case "funny":
                return "You're in a playful and humorous mood! Keep spreading laughter—it’s great for mental health. Watching something funny or sharing jokes with friends can keep the good vibes going."

            case "cry":
                return "You might be feeling overwhelmed. Allow yourself to express emotions and take a moment to breathe. Comforting activities like journaling, a warm drink, or talking to someone who understands can help."

            default:
                return "Your emotions are valid. Take a moment to reflect on what’s influencing your mood and do something that supports your well-being."
        }
    }

    private func findPositiveDays() -> String {
        let positiveMoods = ["happy", "excited", "cool"]
        let filteredEntries = moodData.filter { positiveMoods.contains($0.mood) }

        let uniqueDays = Set(filteredEntries.compactMap { extractDay(from: $0.date) })
        return uniqueDays.isEmpty ? "None" : uniqueDays.sorted().joined(separator: ", ")
    }

    private func findNegativeDays() -> String {
        let negativeMoods = ["angry", "sad", "cry", "disappointed"]
        let filteredEntries = moodData.filter { negativeMoods.contains($0.mood) }

        let uniqueDays = Set(filteredEntries.compactMap { extractDay(from: $0.date) })
        return uniqueDays.isEmpty ? "None" : uniqueDays.sorted().joined(separator: ", ")
    }

    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    private func extractDay(from dateString: String) -> String? {
        guard let date = parseDate(dateString) else { return nil }
        let day = Calendar.current.component(.day, from: date)
        return String(day)
    }
}


#Preview {
    InsightsScreen(userId: "1")
}
