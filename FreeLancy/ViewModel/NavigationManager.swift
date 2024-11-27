//
//  NavigationManager.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 21/11/2024.
//
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var currentView: NavigationDestination? = nil
}

enum NavigationDestination: Hashable {
    case profile
    case stats
    case reports
    case requests
    case offers
    case settings
    case support
}
