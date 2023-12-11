//
//  TestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/10/23.
//

import SwiftUI

struct StudentView: View {
    
    @State var tabSelection = 2
    @State var title = "Classes"
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HourBoardView()
                .tag(1)
            
            ClassesView()
                .tag(2)
            
            SettingsView()
                .tag(3)
        }
        .overlay(alignment: .bottom) {
            BottomBarView(tabSelection: $tabSelection, title: $title)
                .background(Color("green-7").ignoresSafeArea())
        }
        .overlay(alignment: .top) {
            TopBarView(tabSelection: $tabSelection, title: $title)
                .background(Color("green-7").ignoresSafeArea())
        }
    }
}

#Preview {
    StudentView().preferredColorScheme(.dark)
}
