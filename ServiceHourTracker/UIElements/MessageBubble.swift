//
//  MessageBubble.swift
//  messageMe
//
//  Created by kalsky_953982 on 9/1/23.
//

import SwiftUI

struct MessageBubble: View {
    
    
    var message: Message
    //state = static
    @State private var showTime = false
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading){
            HStack{
                Text(message.message).foregroundColor(.white).padding([.top,.bottom],10).padding([.leading,.trailing],15).background( LinearGradient(colors: message.isSender ? (settingsManager.userColors) : [Color(.systemGray2)], startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(30)
            }.frame(maxWidth: 375, alignment: message.isSender ? .trailing : .leading)
                .onTapGesture {
                    showTime.toggle()
                }
            if showTime{
                Text("\(message.time.formatted(.dateTime.hour().minute()))").foregroundColor(.gray).font(.caption2).padding(message.isSender ? .trailing : .leading, 10)
            }
        }.frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
            .padding(message.isSender ? .trailing : .leading)
            .padding(.horizontal, 5)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(fromID: "jonathan.cs@gmail.com", time: Date(), toID: "parker.cs@gmail.com", message: "Test message sent", isSender: true))
    }
    //change to true/false to see different examples of either reciver or sender
}
