//
//  Postulation.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 12/4/24.
//

import Foundation
struct Postulation: Identifiable, Decodable {
    let id: String
    let projectId: String
    let freelancerId: String
    let status: String
}
struct application: Identifiable, Decodable {
    let id :String
    let username : String
    let email: String
    let skills: String
    var status: String
    
    
}

