//
//  bottomPicks.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/6/24.
//

import Foundation
import SwiftUI

struct ManagerBottomBar: View {
    @Binding var selection: Int
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        HStack{
            Spacer()
            
//            Button{
//
//                settingsManager.manTab = 2
//            }label: {
//                
//                
//                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
//                    VStack{
//
//                        Image(systemName: (settingsManager.manTab == 2) ? "list.clipboard.fill" : "list.clipboard").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 18, height:27)
//                        Text("Requests").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                    }
//                ).frame(width: 65, height: 50)
//
//            }
            Button{

                settingsManager.manTab = 5
            }label: {
                
                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{

                        Image(systemName: (settingsManager.manTab == 5) ? "person.crop.rectangle.stack.fill" : "person.crop.rectangle.stack").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                        Text("Actions").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }
                ).frame(width: 65, height: 50)

            }
            
            Spacer()
            
            Button{

                settingsManager.manTab = 0
            }label: {
                
                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{

                        Image(systemName: (settingsManager.manTab == 0) ? "house.fill" : "house").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                        Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }
                ).frame(width: 65, height: 50)
            }
            Spacer()
            Button{

                settingsManager.manTab = 1
            }label: {
                
                LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                    VStack{

                        Image(systemName: (settingsManager.manTab == 1) ? "gearshape.fill" : "gearshape").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                        Text("Settings").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    }
                ).frame(width: 65, height: 50)
            }
            Spacer()
        }.padding(.top).background(.clear).background(.ultraThinMaterial).ignoresSafeArea(edges:[.bottom, .horizontal]).frame(height: 55)
    }
}
