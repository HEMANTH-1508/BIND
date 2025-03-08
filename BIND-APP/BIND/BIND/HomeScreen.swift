import SwiftUI

struct HomeScreen: View {
    @State private var showEventDetail = false
    @State private var showCreateOptions = false
    @State private var selectedEvent: Event?
    
    @State private var quote: String = ""
    @State private var author: String = ""
    
    @State private var eventList: [Event] = []
    @State private var noEventsMessage: String = ""
    @State private var errorMessage: String?
    
    @State private var username: String = "Loading..."
    
    var userId: String?
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Welcome  \(username)")
                        .font(.title)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .bold()
                        .padding()
                }
                .padding(.horizontal, 20)
                VStack {
                    ScrollView {
                        VStack {
                            Text("QUOTE OF THE DAY")
                                .italic()
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                            Text(quote)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .italic()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Text("- \(author)")
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                                .italic()
                                .padding(.top, 5)
                        }
                    }
                    .frame(width: 355, height: 175)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(25)
                    .scrollIndicators(.hidden)
                }
                
                Spacer()
                
                VStack {
                    Text("Upcoming Events")
                        .font(.title)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top)
                    
                    ScrollView {
                        if let error = errorMessage {
                            Text(error)
                                .font(.body)
                                .foregroundColor(.red)
                                .padding()
                        } else if eventList.isEmpty {
                            Text(noEventsMessage)
                                .font(.body)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack {
                                ForEach(sortedEvents(), id: \.id) { event in
                                    EventCard(title: event.title, date: event.event_date)
                                        .onTapGesture {
                                            self.selectedEvent = event
                                            self.showEventDetail.toggle()
                                        }
                                }
                            }
                        }
                    }
                    .frame(width: 355, height: 220)
                    .scrollIndicators(.hidden)
                }
                .background(Color.black.opacity(0.1))
                .cornerRadius(25)
                .padding(.bottom, 10)
                
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        self.showCreateOptions = true
                    }
                }) {
                    Text("Create")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }
            .padding()
            
            if showEventDetail, let event = selectedEvent {
                EventDetailPopup(event: event, showEventDetail: $showEventDetail, eventList: $eventList)
            }

            if showCreateOptions {
                CreateOptionsPopup(showCreateOptions: $showCreateOptions, userId: userId)
                    .transition(.scale.combined(with: .opacity))
                            .zIndex(1)
            }
        }
        .onAppear {
            fetchUsername()
            fetchQuote()
            fetchEvents()
            showCreateOptions = false
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
    private func fetchQuote() {
        guard let url = URL(string: APIHandler.quote) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(QuoteResponse.self, from: data)
                    if response.status {
                        DispatchQueue.main.async {
                            self.quote = response.data.quote
                            self.author = response.data.author
                        }
                    } else {
                        print("No quote found.")
                    }
                } catch {
                    print("Failed to decode quote: \(error)")
                }
            }
        }.resume()
    }

    private func fetchEvents() {
        guard let userId = userId else { return }
        
        APIService.shared.sendPostRequest(url: APIHandler.eventList, parameters: ["user_id": userId]) { (result: Result<EventResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.eventList = response.data
                        self.errorMessage = nil
                    } else {
                        self.eventList = []
                        self.noEventsMessage = "No events available.\n\n\t✍🏻✍🏻✍🏻✍🏻"
                    }
                case .failure(let error):
                    self.eventList = []
                    self.errorMessage = "Failed to fetch events: \(error.localizedDescription)"
                }
            }
        }
    }

    private func sortedEvents() -> [Event] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return eventList.sorted { event1, event2 in
            guard let date1 = dateFormatter.date(from: event1.event_date),
                  let date2 = dateFormatter.date(from: event2.event_date) else {
                return false
            }
            return date1 < date2
        }
    }
}


#Preview {
    HomeView(userId: "1")
}
