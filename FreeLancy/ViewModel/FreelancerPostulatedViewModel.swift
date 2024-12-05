import SwiftUI
import Combine

class FreelancerPostulatedViewModel: ObservableObject {
    @Published var freelancers: [application] = []  // Array of freelancers using User model
    @Published var isLoading: Bool = false         // Loading state
    @Published var errorMessage: String = ""       // Error message
    @Published var status: String = ""
// Error message
    private var cancellables = Set<AnyCancellable>()
    
    // API call to get freelancers by project ID
    func fetchFreelancers(for projectId: String) {
        isLoading = true
        errorMessage = ""
      
        print("Project ID: \(projectId)")
        
        // Correct URL with string interpolation to insert projectId
        guard let url = URL(string: "http://172.18.4.45:3000/application/project1/\(projectId)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                // Check for a valid HTTP response and status code 200
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                
                print("HTTP Status Code: \(response.statusCode)")
                
                // Check for status code 200
                
                
                // Log the raw response data here
                let rawResponse = String(data: output.data, encoding: .utf8) ?? "Invalid Response"
                print("Raw Response: \(rawResponse)")
                
                return output.data
            }
            .decode(type: [application].self, decoder: JSONDecoder())  // Decode directly to User (not Freelancer)
            .receive(on: DispatchQueue.main)  // Ensure that UI updates occur on the main thread
            .sink(receiveCompletion: { completion in
                // Handle completion
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { freelancers in
                // Update freelancers array with the data received
                self.freelancers = freelancers
                print("Decoded Freelancers: \(freelancers)") // Log decoded freelancers
            })
            .store(in: &cancellables)
    }
    
        func updateApplicationStatus(applicationId: String, status: String) {
            // Find the freelancer by ID and update the local status
            guard let index = freelancers.firstIndex(where: { $0.id == applicationId }) else {
                self.errorMessage = "Application not found"
                print("Error: \(self.errorMessage)")
                return
            }

            // Update the status locally
            freelancers[index].status = status // Now it works because status is var
            print("Updating status for freelancer \(applicationId) to \(status)")

            // Simulate API call to update the status
            let url = URL(string: "http://172.18.4.45:3000/application/\(applicationId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Body of the PATCH request
            let body: [String: String] = ["status": status]
            
            // Try encoding the body into JSON
            guard let httpBody = try? JSONEncoder().encode(body) else {
                self.errorMessage = "Failed to encode request body"
                print("Error: \(self.errorMessage)")
                return
            }
            request.httpBody = httpBody
            
            // Log the request details
            print("Request URL: \(url)")
            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
            print("Request Body: \(String(data: httpBody, encoding: .utf8) ?? "")")

            // Perform the network request
            URLSession.shared.dataTaskPublisher(for: request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Request completed successfully.")
                    case .failure(let error):
                        // Handle error
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                        print("Request failed with error: \(error.localizedDescription)")
                    }
                }, receiveValue: { output in
                    // 'output' is a tuple containing 'data' and 'response'
                    let responseData = output.data
                    
                    // Log the response data
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) {
                        print("Response Data: \(jsonResponse)")
                    } else {
                        print("Response Data could not be parsed as JSON.")
                    }
                    
                })
                .store(in: &cancellables)


        }
    }

    

