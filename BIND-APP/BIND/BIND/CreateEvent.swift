import SwiftUI

struct CreateEvent: View {
    var userId: String?
    
    @State private var title = ""
    @State private var description = ""
    @State private var eventDate = Date()
    @State private var priority = "Medium"
    
    @State private var isLoading = false
    @State private var isEventCreated = false
    @State private var errorMessage: String?

    let priorities = ["High", "Medium", "Low"]
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(red: 0.62, green: 0.84, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Create Event")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.top, 40)

                TextField("Event Title", text: $title)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)

                TextEditor(text: $description)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                    .overlay(
                        Group {
                            if description.isEmpty {
                                Text("Event Description")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 10)
                                    .padding(.top, 10)
                            }
                        }
                    )

                DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)

                HStack {
                    Text("Priority")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                    Picker("Priority", selection: $priority) {
                       
                        ForEach(priorities, id: \.self) { priority in
                            Text(priority)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                   
                    .cornerRadius(10)

                }
                .background(Color.white.opacity(0.6))
                .cornerRadius(10)
                .padding(.horizontal,40)
                

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: createEvent) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 200, height: 50)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(25)
                    } else {
                        Text("Create Event")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(width: 200, height: 50)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                }
                .disabled(isLoading)
                .padding(.top, 20)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
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
            .padding(.top, 40)
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isEventCreated) {
            Alert(
                title: Text("Success"),
                message: Text("Event created successfully!"),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func createEvent() {
        guard let userId = userId, !title.isEmpty, !description.isEmpty else {
            errorMessage = "All fields are required!"
            return
        }

        isLoading = true
        errorMessage = nil

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: eventDate)

        let parameters: [String: String] = [
            "user_id": userId,
            "title": title,
            "description": description,
            "event_date": formattedDate,
            "priority": priority
        ]

        APIService.shared.sendPostRequest(url: APIHandler.addEvent, parameters: parameters) { (result: Result<GenericResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        isEventCreated = true
                    } else {
                        errorMessage = response.message
                    }
                case .failure(let error):
                    errorMessage = "Failed to create event: \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    CreateEvent()
}
