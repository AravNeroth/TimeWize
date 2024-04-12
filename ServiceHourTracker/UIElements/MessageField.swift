//
//  MessageField.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/15/24.
//

import SwiftUI

struct MessageField: View {
    
    @State private var textMessage = ""
    var recipientEmail: String
    @AppStorage("uid") private var userID = ""
    @Binding var lastChats: [String:Message]
    var body: some View {
        HStack{
            customTextField(placeholder: Text("Enter Text"), text: $textMessage)
            
            Button{
                if !(textMessage == "" || textMessage.isOnlyWhitespace()) {
                    let newMessage = Message(fromID: userID, toID: recipientEmail, message: textMessage)
                    sendMessage(message: newMessage )
                    lastChats[recipientEmail] = newMessage
                    textMessage = "" //reset
                }
            }label: {
                Image(systemName: "paperplane.circle.fill")
            }
        }.padding(.horizontal).padding(.vertical,10).background(Color(.systemGray4)).cornerRadius(50).padding()
    }
}


struct customTextField: View{
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var comit: () -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder.opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: comit)
                .autocorrectionDisabled(true).onSubmit {
                    
                }
        }
    }
}


