//
//  ContentView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        //TopBarView(title: "Classes")
            
        ScrollView {
            VStack {
                    ClassTabView(name: "Verlyn's Class", mainManager: "Verlyn")
                    ClassTabView(name: "Parker's Class", mainManager: "Parker")
                    ClassTabView(name: "Arav's Class", mainManager: "Arav")
                    ClassTabView(name: "Jonathan's Class", mainManager: "Jonathan")
            }
        }
    }
}

#Preview {
    HomeView()
}
