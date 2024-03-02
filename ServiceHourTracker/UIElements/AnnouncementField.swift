//
//  AnnouncementField.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/1/24.
//

import SwiftUI

struct AnnouncementField: View {
    @State private var currMessage = ""
    @State private var time = Date()
    @State private var messages: [String] = []
    
    var body: some View {
       
        ScrollView{
            Spacer()
            HStack{
                
                TextField("Announce a message to class", text: $currMessage).textFieldStyle(RoundedBorderTextFieldStyle())
                Button{
                    if currMessage != "" {
                        messages.append(currMessage)
                        currMessage = ""
                    }
                }label: {
                    
                    Image(systemName: "square.and.arrow.up")
                }
                .padding()
                
            }
            Spacer()
            ForEach(messages, id: \.self){ message in
                Text(message).frame(minWidth: 350).padding().overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
            }
        }.padding()
    }
            
            
            
    
    }


#Preview {
    VStack{
        AnnouncementField().padding()
    }
}
