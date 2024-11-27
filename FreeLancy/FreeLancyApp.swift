//
//  FreeLancyApp.swift
//  FreeLancy
//
//  Created by Mac-Mini-2021 on 14/11/2024.
//

import SwiftUI

@main
struct FreeLancyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
    LoginView()         
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
