//
//  ContentView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//

import SwiftUI

struct StudentHomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Classes")
                .background(Color("bar-color").ignoresSafeArea())
                
            ScrollView {
                VStack(spacing: -5) {
                    ClassTabView(name: "Verlyn's Class", mainManager: "Verlyn")
                    ClassTabView(name: "Parker's Class", mainManager: "Parker")
                    ClassTabView(name: "Arav's Class", mainManager: "Arav")
                    ClassTabView(name: "Jonathan's Class", mainManager: "Jonathan")
                    ClassTabView(name: "Khoa's Class", mainManager: "Khoa")
                }
            }
            
            BottomBarView()
                .ignoresSafeArea(edges: .bottom)
                .background(Color("bar-color").ignoresSafeArea())
        }
        .background(Color("Background?"))
    }
}

#Preview {
    StudentHomeView()
}
