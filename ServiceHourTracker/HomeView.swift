//
//  ContentView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Classes")
                .background(Color.indigo.ignoresSafeArea(edges: .top))
                
            ScrollView {
                VStack(spacing: 0) {
                    ClassTabView(name: "Verlyn's Class", mainManager: "Verlyn")
                    ClassTabView(name: "Parker's Class", mainManager: "Parker")
                    ClassTabView(name: "Arav's Class", mainManager: "Arav")
                    ClassTabView(name: "Jonathan's Class", mainManager: "Jonathan")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
