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
                .foregroundColor(Color("bar-color"))
                .frame(width: 400, height: 50)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    TopBarView(title: "Test Title")
}
