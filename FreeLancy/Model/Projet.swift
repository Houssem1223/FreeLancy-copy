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
struct Project: Decodable {
    let title: String
    let description: String
    let technologies: String
    let budget: String
    let duration: String
    let status: String
}
