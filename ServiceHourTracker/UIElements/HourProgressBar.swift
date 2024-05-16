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
    var colors: [Color]
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
//                .border(.black, width: 0.1).cornerRadius(30, corners: .allCorners).opacity(0.5)
                .shadow(radius: 1, x: 0.5, y: 0.5)
                
                .progressViewStyle(.linear)
                .tint(LinearGradient(colors: colors , startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        } else {
            ProgressView(value: 2, total: 2)
                .border(.black, width: 0.1)
//                .cornerRadius(30, corners: .allCorners).opacity(0.5)
                .shadow(radius: 1, x: 0.5, y: 0.5)
                .progressViewStyle(.linear)
                .tint(LinearGradient(colors: colors , startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
        }
    }
}

