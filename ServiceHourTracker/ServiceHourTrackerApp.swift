//
//  ServiceHourTrackerApp.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//  Coded by Jonathan Kalsky

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
@main

struct ServiceHourTrackerApp: App {
    @StateObject private var classInfoManager = ClassInfoManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var userData = UserData(user:User())
    @StateObject private var classData = ClassData(code: "")
    @StateObject private var messageManager = MessageManager()
    @AppStorage("uid") var userID = ""
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //check PushNotificationsManager
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.isDarkModeEnabled ? .dark : .light)
                .environmentObject(userData)
                .environmentObject(classData)
                .environmentObject(classInfoManager)
                .environmentObject(messageManager)
                .onReceive(timer) { _ in
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                }
        }
    }
}

