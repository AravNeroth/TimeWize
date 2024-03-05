//
//  LoadingScreen.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/6/24.
//

import Foundation
import SwiftUI

struct LoadingScreen : View {
    var body: some View {
        ProgressView().ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ignoresSafeAreaEdges: .all)
    }
        
}

#Preview {
    LoadingScreen()
}
