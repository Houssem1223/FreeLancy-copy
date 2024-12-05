//
//  Message.swift
//  FreeLancy
//
//  Created by Mac Mini 5 on 12/5/24.
//


import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
