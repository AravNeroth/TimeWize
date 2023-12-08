//
//  ContentView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 12/5/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            ClassTab(name: "Verlyn's Class", mainManager: "Verlyn")
            ClassTab(name: "Parker's Class", mainManager: "Parker")
            ClassTab(name: "Arav's Class", mainManager: "Arav")
            ClassTab(name: "Jonathan's Class", mainManager: "Jonathan")
        }
        .padding()
    }
}

struct ClassTab: View {
    
    var name: String
    var mainManager: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 360, height: 125)
                .foregroundColor(.gray)
                .shadow(radius: 20, y: 15)
            VStack {
                Spacer()
                Text(name)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .frame(width: 315, alignment: .leading)
                Spacer()
                Text(mainManager)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 315, alignment: .leading)
                Spacer()
            }
            .frame(height: 90)
        }
            .padding(.vertical, 5.0)
    }
}

#Preview {
    HomeView()
}
