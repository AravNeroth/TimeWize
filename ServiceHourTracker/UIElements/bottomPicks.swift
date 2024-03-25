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
//            Button {
//                settingsManager.tab = 0
//            } label: {
//                
//                
//                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
//                    VStack{
//                        Image(systemName: (settingsManager.tab == 0) ? "clock.fill" : "clock").resizable().scaledToFit().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
//                        Text("Hours Log").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                    }
//                ).frame(width: 65, height: 50)
//            }
            Button {
                settingsManager.tab = 6
            } label: {
                
                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{
                        Image(systemName: (settingsManager.tab == 6) ? "message.fill" : "message").resizable().scaledToFit().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                        Text("Messages").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }
                ).frame(width: 65, height: 50)
            }
            Spacer()
            Button{

                settingsManager.tab = 2
            } label: {
                                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{
                        Image(systemName: (settingsManager.tab == 2) ? "house.fill" : "house").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).scaledToFill().frame(width: 25, height:25)
                        Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }

                ).frame(width: 65, height: 50)
            }
            Spacer()
            Button{

                settingsManager.tab = 7
            }label: {
                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{

                        Image(systemName: (settingsManager.tab == 7) ? "person.fill" : "person").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                        Text("Profile").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }
                ).frame(width: 65, height: 50)
            }
            Spacer()
        }.padding(.top).background(.clear).background(.ultraThinMaterial).ignoresSafeArea(edges:[.bottom, .horizontal]).frame(height: 55)
    }
}
