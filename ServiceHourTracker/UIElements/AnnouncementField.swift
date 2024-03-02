//
//  AnnouncementField.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/1/24.
//

import SwiftUI

struct AnnouncementField: View {
    @State private var currMessage = ""
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 20, style: .circular).frame(width:250, height: 30).padding().background(.blue).cornerRadius(20, corners: .allCorners)
                .overlay {
                    TextField(text: $currMessage) {
                        Text("Announce a message to class").background(.white)
                    }
            }
            
           Image(systemName: "square.and.arrow.up")
                .padding()
        }
    }
}

#Preview {
    AnnouncementField()
}
