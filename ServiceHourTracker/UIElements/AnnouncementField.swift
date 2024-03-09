//
//  AnnouncementField.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/1/24.
//

import SwiftUI

struct AnnouncementField: View {
    
    @AppStorage("uid") var userID = ""
    @State var colors: [Color] = [.green4, .green6]
    @State var currMessage = ""
    @State var time = Date()
    @State var announcements: [Announcement] = []
    @Binding var refresh: Bool
    @EnvironmentObject var classData: ClassData
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15.0)
            .fill(.background)
            .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
            .frame(height: 100)
            .padding(.horizontal, 10.0)
            .shadow(radius: 2.0, y: 2.0)
            .overlay(
                VStack(alignment: .leading) {
                    HStack {
                        Text("Make An Announcement")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal, 30.0)
                            .padding(.top, 15.0)
                        
                        Spacer()
                    }
                    
                    GeometryReader { geometry in
                        HStack {
                            Spacer()
                            
                            TextField("Announce Here", text: $currMessage)
                                .frame(width: geometry.size.width * 0.7, height: 40)
                                .padding(.horizontal, 20.0)
                            
                            Button {
                                if currMessage != "" {
                                    postAnnouncement(maker: userID, message: currMessage, classCode: classData.code) {}
                                    currMessage = ""
                                    refresh = true
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.leading, 10.0)
                            .padding(.trailing, 20.0)
                            
                            Spacer()
                        }
                    }
                }
            )
        
//        ScrollView{
//            Spacer()
//            HStack{
//                
//                TextField("Announce a message to class", text: $currMessage).textFieldStyle(RoundedBorderTextFieldStyle())
//                Button{
//                    if currMessage != "" {
//                        
//                        postAnnouncement(maker: userID, message: currMessage, classCode: classData.code) {}
//                        
//                        currMessage = ""
//                        
//                    }
//                }label: {
//                    
//                    Image(systemName: "square.and.arrow.up")
//                }
//                .padding()
//                
//            }
//            Spacer()
//            ForEach(messages.reversed(), id: \.self){ message in
//                Text(message).frame(minWidth: 350).padding().overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
//                )
//            }
//        }.padding()
    }
}
