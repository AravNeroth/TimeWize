//
//  BottomBarView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/9/23.
//

import SwiftUI

struct BottomBarView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 400, height: 70)
                .foregroundColor(Color("blue-bar-color"))
            
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .top)
                    Text("Hours Log")
                }
                .frame(width: 80)
                Spacer()
                Spacer()
                VStack(spacing: 0) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .top)
                    Text("Classes")
                }
                .frame(width: 80)
                Spacer()
                Spacer()
                VStack(spacing: 0) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .top)
                    Text("Settings")
                }
                .frame(width: 80)
                Spacer()
            }
        }
    }
}

#Preview {
    BottomBarView()
}
