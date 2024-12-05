//
//  AcceptedFreelancersViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 12/5/24.
//

import Foundation



class AcceptedFreelancersViewModel: ObservableObject {
    @Published var applications: [application] = []
    @Published var hasError = false
    @Published var errorMessage = ""

    func fetchAcceptedFreelancers() {
        guard let url = URL(string: "http://172.18.4.45:3000/application/freelancers/accepted") else {
            self.hasError = true
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.hasError = true
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self?.hasError = true
                    self?.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode([application].self, from: data)
                    self?.applications = decodedResponse.filter { $0.status == "Accepted" }
                } catch {
                    self?.hasError = true
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
