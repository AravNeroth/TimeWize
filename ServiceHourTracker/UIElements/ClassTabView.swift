//
//  ClassTabView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/8/23.
//

import SwiftUI

struct ClassTabView: View {
    
    var name: String
    var mainManager: String
    @EnvironmentObject var settingsManager: SettingsManager
    @State var navToClass = false
    @Binding var tabNum: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30) //background
                .frame(width: 375, height: 120)
                .foregroundColor(Color("green-5"))
            VStack {
                Spacer()
                Text(name) //name of class
                .underline()
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .frame(width: 315, alignment: .leading)
                .foregroundStyle((settingsManager.isDarkModeEnabled) ? .black : .white)
                .onTapGesture {
                    tabNum = 4
                    print("tap")
                    currentView = .classroomView
                    settingsManager.title = name
                    
                }
                
                Spacer()
             
                Text(mainManager) //description or sum
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(width: 315, alignment: .leading)
                    .foregroundStyle((settingsManager.isDarkModeEnabled) ? .black : .white)
                Spacer()
            }
            .frame(height: 90)
            
        }
            .padding(.vertical, 5.0)
        

    }
   
}

