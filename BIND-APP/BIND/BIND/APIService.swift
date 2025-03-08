import Foundation

class APIService {
    static let shared = APIService()
    private init() {}
    
    func sendPostRequest<T: Decodable>(url: String, parameters: [String: String], completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestURL = URL(string: url) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createFormDataBody(with: parameters, boundary: boundary)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func sendGetRequest<T: Decodable>(url: String, parameters: [String: String], completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestURL = URL(string: url) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createFormDataBody(with: parameters, boundary: boundary)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func createFormDataBody(with parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        for (key, value) in parameters {
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
            body.append("\(value)\(lineBreak)".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
}

