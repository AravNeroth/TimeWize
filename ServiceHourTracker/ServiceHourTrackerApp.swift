//
//  ServiceHourTrackerApp.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//  Coded by Jonathan Kalsky

import SwiftUI
import FirebaseCore

@main
struct ServiceHourTrackerApp: App {
    @StateObject private var settingsManager = SettingsManager()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView().environmentObject(settingsManager).preferredColorScheme(settingsManager.isDarkModeEnabled ? .dark : .light)
        }
    }
}

class SettingsManager: ObservableObject{
    
//    @Published var isDarkModeEnabled = false
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
}
