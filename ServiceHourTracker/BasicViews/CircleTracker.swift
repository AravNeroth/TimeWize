//
//  CircleTracker.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 5/2/24.
//

import SwiftUI

struct CircleTracker: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    var totalGoal: Int
    var totalHours: Int
    var classes: [Classroom]
    var points: [CGFloat]
    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
            Circle()
                .fill(.gray.opacity(0.3))
                .overlay(
                    Text("\(totalHours) Hours")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    
                )
            Circle()
                .trim(from: 0, to: 1)
                .stroke(.gray, style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -90))
            
            ForEach(0..<classes.count, id: \.self){ index in
                
                Circle()
                    .trim(from: points[index], to: points[index+1])
                    .stroke(
                        LinearGradient(
                            colors: classInfoManager.classColors[classes[index]] ?? settingsManager.userColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .shadow(radius: 20, y: 3)
            }
            
            /*
            Circle()
                .trim(from: currentPoint, to: nextPoint)
                .stroke(
                    LinearGradient(
                        colors: classInfoManager.classColors[Array(totalHoursEarned.keys)[ind]] ?? settingsManager.userColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 20, y: 3)
            */
        }
    }
    
}
