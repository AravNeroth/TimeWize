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
import Network
@main

struct ServiceHourTrackerApp: App {
    @StateObject private var classInfoManager = ClassInfoManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var userData = UserData(user:User())
    @StateObject private var classData = ClassData(code: "")
    @StateObject private var messageManager = MessageManager()
    @AppStorage("uid") var userID = ""
    @State var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //check PushNotificationsManager
    
    init() {
        FirebaseApp.configure()
      
        UNUserNotificationCenter.current().getDeliveredNotifications { notis in
            UNUserNotificationCenter.current().setBadgeCount(notis.count)
        }
        
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
                    print("\n\n\(speedTest())\n\n")
                    refreshVars(settingsManager: settingsManager, messageManager: messageManager, classInfoManager: classInfoManager)
                }
                .onAppear{
                    appDelegate.settingsManager = settingsManager
                }
        }
    }
}

