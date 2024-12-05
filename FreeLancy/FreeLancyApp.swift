//
//  FreeLancyApp.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//

import SwiftUI
import FirebaseCore

@main
struct FreeLancyApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
    LoginView()         
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
