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
            Button {
                settingsManager.tab = 0
            } label: {
                VStack{
                    Image(systemName: "clock.fill").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                    Text("Hours Log").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{

                settingsManager.tab = 2
            } label: {
                VStack{
                    Image(systemName: "house.fill").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).scaledToFill().frame(width: 25, height:25)
                    Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{

                settingsManager.tab = 3
            }label: {
                VStack{

                    Image(systemName: "gearshape.fill").resizable().tint((settingsManager.isDarkModeEnabled) ? .white : .green5).frame(width: 25, height:25)
                    Text("Settings").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
        }.padding(.top).background(.clear).background(.ultraThinMaterial).ignoresSafeArea(edges:[.bottom, .horizontal]).frame(height: 55)
    }
}
