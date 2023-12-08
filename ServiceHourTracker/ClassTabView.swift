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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 360, height: 125)
                .foregroundColor(.gray)
                .shadow(radius: 20, y: 10)
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
    ClassTabView(name: "Test", mainManager: "Test Person")
}
