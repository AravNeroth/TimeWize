//
//  ContentView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//

import SwiftUI

struct ClassesView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
                .frame(width: 400, height: 50)
            
            ScrollView {
                VStack(spacing: -5) {
                    ClassTabView(name: "Verlyn's Class", mainManager: "Verlyn")
                    ClassTabView(name: "Parker's Class", mainManager: "Parker")
                    ClassTabView(name: "Arav's Class", mainManager: "Arav")
                    ClassTabView(name: "Jonathan's Class", mainManager: "Jonathan")
                    ClassTabView(name: "Khoa's Class", mainManager: "Khoa")
                }
            }
        }
        .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
    }
}
    
#Preview {
    ClassesView()
}

