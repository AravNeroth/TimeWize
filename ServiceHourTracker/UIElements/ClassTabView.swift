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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7.5) //background
                .frame(width: 375, height: 150)
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
                        print("tapped")
                    }
                Spacer()
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

#Preview {
    ClassTabView(name: "Test", mainManager: "Test Person")
}
