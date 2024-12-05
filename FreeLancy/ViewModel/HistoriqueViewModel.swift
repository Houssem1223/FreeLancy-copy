import Foundation
import Combine

class HistoriqueViewModel: ObservableObject {
    @Published var projects: [Project] = [] // Replace Postulation with Project
    @Published var errorMessage: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    // Retrieve freelancer ID from Keychain
    func getFreelancerId() -> String? {
        return KeychainHelper.retrieve(key: "userId")
    }
    
    // Fetch projects associated with the freelancer's applications
    func fetchProjects() {
        guard let freelancerId = getFreelancerId() else {
            self.errorMessage = "Freelancer ID is not available."
            return
        }
        
        // API URL with freelancer ID
        let urlString = "http://172.18.4.45:3000/application/freelancer/\(freelancerId)"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        // Set up the URLRequest, ensuring that it's a GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Ensure it's a GET request
        
        // Add any headers if needed (e.g., Authorization, Content-Type)
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // API Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching projects: \(error.localizedDescription)"
                }
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                          print("HTTP Status Code: \(httpResponse.statusCode)") // Log the status code
                      }
                      
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server."
                }
                return
            }
            
            do {
                // Decode the JSON response into an array of Project objects
                let decoder = JSONDecoder()
                let projects = try decoder.decode([Project].self, from: data)
                
                DispatchQueue.main.async {
                              self.projects = projects
                              for project in projects {
                                  print("Project Title: \(project.title)")
                              }
                          }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode project data."
                }
            }
        }.resume()
    }
}

