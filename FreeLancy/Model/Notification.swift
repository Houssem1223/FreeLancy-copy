//
//  Notification.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 12/3/24.
//

import Foundation


struct Notification: Codable, Identifiable {
    var id: String
    var projectId: String
    var entrepreneurId: String
    var message: String
    var status: String
    var freelancerId : String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Map _id in JSON to id in Swift
        case projectId
        case entrepreneurId
        case message
        case status
        case freelancerId
    }
}
