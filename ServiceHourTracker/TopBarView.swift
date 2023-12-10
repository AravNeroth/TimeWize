//
//  TopBarView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/8/23.
//

import SwiftUI

struct TopBarView: View {
    
    var title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("green-bar-color"))
                .frame(width: 400, height: 50)
            HStack(spacing: 0) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 150, alignment: .center)
                    .padding(.leading, 100)
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.leading, 70)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    TopBarView(title: "Test Title")
}
