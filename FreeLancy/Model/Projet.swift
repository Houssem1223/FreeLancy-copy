//
//  Projet.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 25/11/2024.
//

import Foundation

struct Projectf: Decodable {
    let id: String
    let title: String
    let description: String
    let technologies: String
    let budget: String
    let duration: String
    let status: String
    let score: Double
}
class Project: Identifiable, Decodable {
    var id: String  // This will correspond to the _id field from the backend
    var title: String
    var description: String
    var technologies: String
    var budget: String
    var duration: String
    var status: String

    // Custom initializer for Decodable
    enum CodingKeys: String, CodingKey {
        case id = "_id" // This maps the _id field to id in Swift
        case title
        case description
        case technologies
        case budget
        case duration
        case status
    }
}

