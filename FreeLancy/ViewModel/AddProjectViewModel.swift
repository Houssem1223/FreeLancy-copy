//
//  AddProjectViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 25/11/2024.
//

import SwiftUI
import Combine

class AddProjectViewModel: ObservableObject {
    // Published properties for the form inputs
    @Published var projectTitle: String = ""
    @Published var projectDescription: String = ""
    @Published var projectTechnologies: String = ""
    @Published var projectBudget: String = ""
    @Published var projectDeadline: Date = Date()
    @Published var projectStatus: String = ""
    
    // Published properties for UI state
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isProjectAdded: Bool = false

    private var cancellables = Set<AnyCancellable>() // For handling Combine publishers
    
    // Function to validate form inputs
    func validateInputs() -> Bool {
        guard !projectTitle.isEmpty,
              !projectDescription.isEmpty,
              !projectTechnologies.isEmpty,
              !projectBudget.isEmpty else {
            errorMessage = "All fields are required."
            showError = true
            return false
        }
        return true
    }
    
    // Function to submit the project to the backend
    func submitProject() {
        guard validateInputs() else { return }
        // Retrieve userId from Keychain
        guard let userId = KeychainHelper.retrieve(key: "userId") else {
            errorMessage = "User not logged in. Please log in again."
            showError = true
            return
        }
        // Show loading indicator
        isLoading = true
        showError = false

        // Create the request body
        let projectData: [String: Any] = [
            "title": projectTitle,
            "description": projectDescription,
            "technologies": projectTechnologies,
            "budget": projectBudget,
            "duration": ISO8601DateFormatter().string(from: projectDeadline),
            "status": projectStatus,
            "userId": userId
        ]

        // Convert the request body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: projectData) else {
            errorMessage = "Failed to encode project data."
            showError = true
            isLoading = false
            return
        }

        // Create the URL and request
        guard let url = URL(string: "http://172.18.4.45:3000/projet/add") else {
            errorMessage = "Invalid URL."
            showError = true
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Perform the API call
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Void in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    let responseError = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let errorMessage = responseError?["message"] as? String ?? "Failed to add the project."
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                case .finished:
                    self?.isProjectAdded = true
                    self?.resetForm()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    // Reset the form
    func resetForm() {
        projectTitle = ""
        projectDescription = ""
        projectTechnologies = ""
        projectBudget = ""
        projectDeadline = Date()
        projectStatus = "To Do"
    }
    @Published var projects: [Project] = [] // To store fetched projects
    @Published var project: [Projectf] = [] // To store fetched projects

       // Fetch projects from the backend
    func fetchProjects() {
        guard let userId = KeychainHelper.retrieve(key: "userId") else {
            errorMessage = "User not logged in. Please log in again."
            showError = true
            return
        }

        guard let url = URL(string: "http://172.18.4.45:3000/projet/user") else {
            print("Invalid URL")
            return
        }
               // Create the request body
        let requestBody: [String: String] = ["userId": userId]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            errorMessage = "Failed to encode request data."
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to fetch projects: \(error.localizedDescription)"
                    self?.showError = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    print("No data received.")
                    self?.errorMessage = "No data received from server."
                    self?.showError = true
                    return
                }

               // print("Response Size: \(data.count) bytes")
               // print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid Response")")

                do {
                    let decoder = JSONDecoder()
                    let projects = try decoder.decode([Project].self, from: data)
                    self?.projects = projects
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to decode project data."
                    self?.showError = true
                }
            }
        }.resume()
    }
    func fetchFreelancerProjects() {
        guard let userId = KeychainHelper.retrieve(key: "userId") else {
            errorMessage = "User not logged in. Please log in again."
            showError = true
            return
        }
        
        guard let url = URL(string: "http://172.18.4.45:3000/project-filter/filterPer") else {
            print("Invalid URL")
            return
        }
        
        // Create the request body
        let requestBody: [String: String] = ["userId": userId]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            errorMessage = "Failed to encode request data."
            showError = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to fetch projects: \(error.localizedDescription)"
                    self?.showError = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    print("No data received.")
                    self?.errorMessage = "No data received from server."
                    self?.showError = true
                    return
                }

//                print("Response Size: \(data.count) bytes")
//                print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid Response")")

                do {
                    let rankedProjects = try JSONDecoder().decode([Projectf].self, from: data)
                    self?.project = rankedProjects

                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to decode project data."
                    self?.showError = true
                }
            }
        }.resume()
    }
    func filterProjects(_ projects: [Project], searchText: String) -> [Project] {
           guard !searchText.isEmpty else { return projects } // If no search text, return all projects
           return projects.filter { project in
               project.title.lowercased().contains(searchText.lowercased()) // Filter by project title
           }
       }
    func filterProjects1(_ project: [Projectf], searchText: String) -> [Projectf] {
           guard !searchText.isEmpty else { return project } // If no search text, return all projects
           return project.filter { project in
               project.title.lowercased().contains(searchText.lowercased()) // Filter by project title
           }
       }


}
