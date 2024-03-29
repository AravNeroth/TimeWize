//
//  TopBarView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/8/23.
//

import SwiftUI

struct TopBarView: View {
    
    @Binding var tabSelection: Int
    @Binding var title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("green-7"))
                .frame(width: 400, height: 10)
            HStack(spacing: 0) {
                Text(title)
                    .foregroundColor(.primary)
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
