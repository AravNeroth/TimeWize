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
            RoundedRectangle(cornerRadius: 30, style: .circular).overlay {
                TextField("Announce a message to class", text: $currMessage).foregroundStyle(.white)
            }.frame(width:200, height: 30).padding().background(.blue)
            
           Image(systemName: "square.and.arrow.up")
                .padding()
        }
    }
}

#Preview {
    AnnouncementField()
}
