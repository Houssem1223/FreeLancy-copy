import SwiftUI
import Combine

class PostulationViewModel: ObservableObject {
    @Published var applicationStatus: String = "" // To hold the status of the application
    private var cancellables = Set<AnyCancellable>()
    
    // This function retrieves the freelancer ID from Keychain using KeychainHelper
    func getFreelancerId() -> String? {
        // Use KeychainHelper to retrieve the freelancer's user ID from the Keychain
        return KeychainHelper.retrieve(key: "userId")
    }
    
    // Function to post the application
    func postulate(for projectId: String, completion: @escaping (Bool) -> Void) {
        guard let freelancerId = getFreelancerId() else {
            print("Freelancer ID is not available.")
            completion(false)
            return
        }
        
        // Define the endpoint for posting the application
        let url = URL(string: "http://172.18.6.197:3000/application")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the data to send in the body of the request
        let body: [String: Any] = [
            "freelancer": freelancerId,
            "project": projectId,
            "status": "pending" // Assuming the status starts as 'pending'
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error preparing the request body: \(error)")
            completion(false)
            return
        }

        // Perform the POST request to submit the application
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.applicationStatus = "Failed to submit application: \(error.localizedDescription)"
                    completion(false)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.applicationStatus = "Invalid response from server."
                    completion(false)
                }
                return
            }
            
            // Handle success
            DispatchQueue.main.async {
                self.applicationStatus = "Application submitted successfully."
                completion(true)
            }
            
        }.resume()
    }
}

