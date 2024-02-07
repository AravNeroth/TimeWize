//
//  bottomPicks.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/6/24.
//

import Foundation
import SwiftUI

struct bottomPicks: View {
    @Binding var selection: Int
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        HStack{
            Spacer()
            Button{
//                currentView = .HourBoardView
                settingsManager.tab = 0
            }label: {
                VStack{
//                                    Spacer()
                    Image(systemName: "clock.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Hours Log").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{
//                currentView = .ClassesView
//                selection = 2
                settingsManager.tab = 2
            }label: {
                VStack{
//                                    Spacer()
                    Image(systemName: "house.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{
//                currentView = .SettingsView
                settingsManager.tab = 3
            }label: {
                VStack{

                    Image(systemName: "gearshape.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Settings").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
        }.padding(.top)
    }
}
