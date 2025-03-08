import SwiftUI

struct EventDetailPopup: View {
    var event: Event
    @Binding var showEventDetail: Bool
    @Binding var eventList: [Event]
    
    private let backgroundColor: Color = [
        Color(red: 0.7, green: 0.85, blue: 1.0),
                Color(red: 0.75, green: 1.0, blue: 0.75),
                Color(red: 1.0, green: 0.85, blue: 0.7),
                Color(red: 0.85, green: 0.75, blue: 1.0),
                Color(red: 1.0, green: 0.7, blue: 0.7)
    ].randomElement() ?? Color.white
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        deleteEvent(eventId: event.id)
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 5)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("📅 Event Date: \(event.event_date)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                            Text(event.description)
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                
                        Text("⚡Priority: \(event.priority)")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    
                }
                
                Spacer()
                
                Button(action: {
                    showEventDetail = false
                }) {
                    Text("Close")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 45)
                        .background(Color.blue)
                        .cornerRadius(22)
                        .shadow(radius: 5)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)
            }
            .padding()
            .frame(width: 320, height: 500)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
    
    private func deleteEvent(eventId: Int) {
        APIService.shared.sendPostRequest(url: APIHandler.deleteEvent, parameters: ["event_id": "\(eventId)"]) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        eventList.removeAll { $0.id == eventId }
                        showEventDetail = false
                    } else {
                        print("Failed to delete event: \(response.message)")
                    }
                case .failure(let error):
                    print("API error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    EventDetailPopup(
        event: Event(id: 1, title: "Meeting", description: "Discuss project details. iur uht duhrg erhg erhne ruehg erhg ergn erguer germ e8rue ehrh ie nurh 9eh r0ug0erj goejrg erujgler gerjgeo fgjer jeore o eijrejr oerigj erjgekr erugj.", event_date: "2025-02-14", priority: "High"),
        showEventDetail: .constant(true),
        eventList: .constant([
            Event(id: 1, title: "Meeting", description: "Discuss project details", event_date: "2025-02-14", priority: "High"),
            Event(id: 2, title: "Doctor Appointment", description: "Visit Dr. Smith", event_date: "2025-02-15", priority: "Medium")
        ])
    )
}
