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
                .foregroundColor(.gray)
                .frame(width: 400, height: 100)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 45)
        }
    }
}

#Preview {
    TopBarView(title: "Test Title")
}
