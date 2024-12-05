//
//  NotificationViewModel.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 12/3/24.
//

import Foundation
import SwiftUI
import Combine

class NotificationViewModel: ObservableObject {
    @Published var unreadCount: Int = 0
    @Published var notifications: [Notification] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    @Published var selectedUser: User? = nil    // You already have this property for selectedUser
    @Published var selectedFreelancer: User? = nil
    private var cancellables = Set<AnyCancellable>()
    var entrepreneurId: String = ""
    func fetchNotifications() {
        guard let userId = KeychainHelper.retrieve(key: "userId") else {
            errorMessage = "User not logged in. Please log in again."
            showError = true
            return
        }
        
        guard let url = URL(string: "http://172.18.4.45:3000/notifications/entrepreneur") else {
            print("Invalid URL")
            return
        }
        
        // Create the request body
        let requestBody: [String: String] = ["entrepreneurId": userId]
        
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
                               print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid Response")")
                
                do {
                    let notification = try JSONDecoder().decode([Notification].self, from: data)
                    self?.notifications = notification
                    self?.unreadCount = (self?.notifications.filter { $0.status == "unread" }.count)!
                    
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to decode project data."
                    self?.showError = true
                }
            }
        }.resume()
    }
    func fetchFreelancerDetails(freelancerId: String) {
        guard let url = URL(string: "http://172.18.4.45:3000/notifications/freelancer") else {
            errorMessage = "Invalid URL."
            showError = true
            return
        }

        let requestBody: [String: String] = ["freelancerId": freelancerId]
        
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
                    self?.errorMessage = "Failed to fetch freelancer details: \(error.localizedDescription)"
                    self?.showError = true
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    self?.errorMessage = "No data received from server."
                    self?.showError = true
                    return
                }

                do {
                    let freelancer = try JSONDecoder().decode(FreeLancy.User.self, from: data)
                    self?.selectedFreelancer = freelancer
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to decode freelancer data."
                    self?.showError = true
                }
            }
        }.resume()
    }

//    func markNotificationAsRead(notificationId: String) {
//        guard let url = URL(string: "http://172.18.6.197:3000/notifications/\(notificationId)") else {
//            self.errorMessage = "Invalid URL."
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        
//        URLSession.shared.dataTask(with: request) { _, _, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error marking notification as read: \(error.localizedDescription)"
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.fetchNotifications()
//            }
//        }.resume()
//    }
}

