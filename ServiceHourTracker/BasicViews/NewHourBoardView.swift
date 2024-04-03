//
//  NewHourBoardView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 4/2/24.
//

import SwiftUI

struct NewHourBoardView: View {
    
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @Binding var totalHoursEarned: [Classroom:Int]
    
    var body: some View {
        ForEach (classInfoManager.allClasses, id: \.self) { classroom in
            HourProgressBar(goal: Float(classroom.minServiceHours + classroom.minSpecificHours), hoursEarned: Float(totalHoursEarned[classroom] ?? 0), classroomName: classroom.title)
        }
    }
}
