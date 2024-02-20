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
            
            Button{

                settingsManager.manTab = 2
            }label: {
                VStack{

                    Image(systemName: "list.clipboard.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Requests").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            
            Spacer()
            
            Button{

                settingsManager.manTab = 0
            }label: {
                VStack{

                    Image(systemName: "house.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{

                settingsManager.manTab = 1
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
