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
    var classroomName: String
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        
        if hoursEarned < goal {
            HStack {
                Text(classroomName).font(.headline)
                Spacer()
                Text("\(hoursEarned)" + " / \(goal)")
            }
            .padding([.leading, .trailing])
        } else {
            HStack {
                Text(classroomName).font(.headline)
                Spacer()
                Text("Hours Complete")
            }
            .padding([.leading, .trailing])
        }
        
        if hoursEarned < goal {
            ProgressView(value: hoursEarned, total: goal)
                .progressViewStyle(.linear)
                .tint(LinearGradient(colors: settingsManager.userColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        } else {
            ProgressView(value: 2, total: 2)
                .progressViewStyle(.linear)
                .tint(LinearGradient(colors: settingsManager.userColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        }
    }
}

#Preview {
    HourProgressBar(goal: 3, hoursEarned: 2.5, classroomName: "MUAT - CPHS")
}
