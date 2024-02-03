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
    @StateObject private var classInfoManager = ClassInfoManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var userData = UserData(user:User())
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(settingsManager).preferredColorScheme(settingsManager.isDarkModeEnabled ? .dark : .light)
                .environmentObject(userData)
                .environmentObject(classInfoManager)
                
        }
    }
}

class SettingsManager: ObservableObject{
    static let shared =  SettingsManager()
//    @Published var isDarkModeEnabled = false
    @Published var perfHourRange = 20
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    @Published var title:String = "Classes"
    @Published var classes: [String] = UserDefaults.standard.stringArray(forKey: "classes") ?? [""]{
            didSet{
                updateUserDefaults()
            }
    }
    @Published var inClass = false
    @Published var tab: Int = 2
    
    private func updateUserDefaults() {
           UserDefaults.standard.set(classes, forKey: "classes")
       }
    
    internal init() {
        
    }
}
class ClassInfoManager: ObservableObject {
    @Published var classInfo: [Classroom] = []
}
