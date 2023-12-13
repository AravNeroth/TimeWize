//
//  BottomBarView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/9/23.
//

import SwiftUI

struct BottomBarView: View {
    
    @Binding var tabSelection: Int
    @Binding var title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 400, height: 70)
                .foregroundColor(Color("custom-green"))
                
            HStack {
                Spacer()
                
                Button(action: {
                    tabSelection = 1
                    title = "Hour Log"
                }) {
                    VStack(spacing: 0) {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .top)
                        Text("Hour Log")
                            .font(.custom("Metropolis-RegularItalic", size: 14))
                            .bold()
                    }
                    .frame(width: 90)
                }
                .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                Button(action: {
                    tabSelection = 2
                    title = "Classes"
                }) {
                    VStack(spacing: 0) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .top)
                        Text("Class")
                            .font(.custom("Metropolis-RegularItalic", size: 14))
                            .bold()
                    }
                    .frame(width: 90)
                }
                .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                Button(action: {
                    tabSelection = 3
                    title = "Settings"
                }) {
                    VStack(spacing: 0) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .top)
                        Text("Settings")
                            .font(.custom("Metropolis-RegularItalic", size: 14))
                            .bold()
                    }
                    .frame(width: 90)
                }
                .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
}
