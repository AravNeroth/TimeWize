//
//  NewMessage.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 4/11/24.
//

import SwiftUI

struct NewMessage: View {
    @State private var recipientEmail = "" //who are they trying to contact
    @State private var goodEmail = false
    @EnvironmentObject private var messageManager: MessageManager
    @EnvironmentObject private var settingsManager: SettingsManager
    var body: some View {
        VStack{
            
            //Text Field to enter email of contact
            customTextField(placeholder: Text("Contact Email"), text: $recipientEmail).foregroundStyle(goodEmail || recipientEmail == "" ? .black : .redWrong)
                .padding(.horizontal).padding(.vertical,10).background(Color(.systemGray4)).cornerRadius(50).padding().onSubmit {
                    doesEmailExistInDB(email: recipientEmail) { exists in
                        if exists{
                            self.goodEmail = true
                            settingsManager.dm = recipientEmail
                        }else{
                            self.goodEmail = false
                        }
                    }
                }
            
            if goodEmail {

                MessageLogView(lastChats: $messageManager.lastMessages, recipientEmail: recipientEmail)
                    
                
                
            }else{
                Spacer()
            }
            
            
        }
    }
}

#Preview {
    NewMessage()
}
