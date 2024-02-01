//
//  classroomView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/30/24.
//

import SwiftUI

struct classroomView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        NavigationView{
            ScrollView{
                Text("\(settingsManager.title)").padding()
//                NavigationLink {
//                    ClassesView()
//                } label: {
//                    Image(systemName: "case.fill")
//                }
                
           
            }
            
            
            

        }
        
    }
}

#Preview {
    classroomView()
}
