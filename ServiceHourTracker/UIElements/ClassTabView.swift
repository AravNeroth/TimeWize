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
            RoundedRectangle(cornerRadius: 7.5)
                .frame(width: 375, height: 150)
                .foregroundColor(Color("green-5"))
            VStack {
                Spacer()
                Text(name)
                    .underline()
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(width: 315, alignment: .leading)
                Spacer()
                Spacer()
                Text(mainManager)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
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
