//
//  AnnouncementField.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/1/24.
//

import SwiftUI

struct AnnouncementField: View {
    @AppStorage("uid") var userID = ""
    @State private var currMessage = ""
    @State private var time = Date()
    @State private var announcements: [Announcement] = []
    @EnvironmentObject private var classData: ClassData
    var body: some View {
       
        ScrollView{
            Spacer()
            HStack{
                
                TextField("Announce a message to class", text: $currMessage).textFieldStyle(RoundedBorderTextFieldStyle())
                Button{
                    if currMessage != "" {
                        
                        postAnnouncement(maker: userID, message: currMessage, classCode: classData.code) {}
                        
                        currMessage = ""
                        
                    }
                }label: {
                    
                    Image(systemName: "square.and.arrow.up")
                }
                .padding()
                
            }
            Spacer()
//            ForEach(messages.reversed(), id: \.self){ message in
//                Text(message).frame(minWidth: 350).padding().overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
//                )
//            }
        }.padding()
    }
            
            
            
    
    }


#Preview {
    VStack{
        AnnouncementField().padding()
    }
}
