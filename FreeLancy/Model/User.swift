//
//  User.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//
import Foundation

class User: ObservableObject {
    @Published var username: String
    @Published var email: String
    @Published var password: String
 


    
    init(username: String, email: String, password: String , role : String,avatarUrl : String) {
        self.username = username
        self.email = email
        self.password = password
   

    }
}

