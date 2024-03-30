//
//  HourProgressBar.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/30/24.
//

import SwiftUI

struct HourProgressBar: View {
    var goal: Float
    var hoursEarned: Float
    var classroomname: String
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        
        HStack{
            Text(classroomname).font(.headline)
            Spacer()
            Text("\(hoursEarned)"+"/\(goal)")
        }
        .padding([.leading, .trailing])
        
        
        ProgressView(value: hoursEarned, total: goal)
            .progressViewStyle(.linear)
            .foregroundStyle(LinearGradient(colors: settingsManager.userColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .padding()
    }
}

#Preview {
    HourProgressBar(goal: 3, hoursEarned: 2.5, classroomname: "MUAT - CPHS")
}
