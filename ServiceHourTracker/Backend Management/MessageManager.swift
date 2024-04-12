//
//  MessageManager.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/11/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Message: Codable, Hashable, Identifiable {
    var id: String {
        return "\(UUID())"
    }
    
    var fromID: String
    var time: Date
    var toID: String
    var message: String
    var isSender: Bool
    init(fromID: String, time: Date = Date(), toID: String, message: String, isSender: Bool = true) {
        
        self.fromID = fromID
        self.time = time
        self.toID = toID
        self.message = message
        self.isSender = isSender
        
    }
    
   
}


func sendMessage(message: Message){

//        var currMessage = message
    let messageRef = db.collection("userInfo").document(message.toID).collection("Messages").document(message.fromID)
    let sendingRef = db.collection("userInfo").document(message.fromID).collection("Messages").document(message.toID)
    
    messageRef.getDocument { doc, error in
            if let error = error {
                print("Error getting document:", error.localizedDescription)
            } else {
                if let doc = doc, doc.exists  {
                    // Parent document exists, continue with setting data for the subcollection document
                    addMessage(message: message)
                } else {
                    // Parent document doesn't exist, create it
                    messageRef.setData([:]) { error in
                        if let error = error {
                            print("Error creating document:", error.localizedDescription)
                        } else {
                            
                            // Now set data for the subcollection document
                            sendingRef.getDocument { doc, error in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    if let doc = doc, doc.exists{
                                        addMessage(message: message)
                                    }else{
                                        sendingRef.setData([:]){ error in
                                            if let error = error{
                                                print(error.localizedDescription)
                                            }else{
                                                addMessage(message: message)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    
    


}

func addMessage(message: Message){
    var currMessage = message
    do{
        currMessage.isSender = false
        try db.collection("userInfo").document(message.toID).collection("Messages").document(message.fromID).collection("chat").document(currMessage.id).setData(from: currMessage)
        //to someone
        
        currMessage.isSender = true
        try db.collection("userInfo").document(message.fromID).collection("Messages").document(message.toID).collection("chat").document(currMessage.id).setData(from: currMessage)
        //this guy sent it
        try db.collection("messages").document(message.toID).collection(message.fromID).addDocument(from: message)
    }catch{
        print("cannot save message in database")
    }
    
}



func getMessages(user: String, from:String, completion: @escaping ([Message]) -> Void){
   
    db.collection("userInfo").document(user).collection("Messages").document(from).collection("chat").getDocuments { docs, error in
        if let error = error{
            print(error.localizedDescription)
            completion([])
        }else{
            var output: [Message] = []//completion output
           
            if let docs = docs{
                for document in docs.documents {
                    
                    let data = document.data()
                    
                    let fID = data["fromID"] as! String
                    let tID = data["toID"] as! String
                    let msg = data["message"] as! String
                    let timeStamp = data["time"] as! Timestamp
                    let currMessage = Message(fromID: fID, time: timeStamp.dateValue(), toID: tID, message: msg)
                    output.append(currMessage)
                    
                }
                completion(output)
            }else{
                completion([])
            }
        }
        
    }
    completion([])
}

func getChatsOf(user: String, completion: @escaping ([String])-> Void){
    db.collection("userInfo").document(user).collection("Messages").getDocuments { docs, error in
        if let error = error{
            print(error.localizedDescription)
            completion([])
        }else{
            var output: [String] = [] //completion output
            
            if let docs = docs{
                
                //0
                //jonathan.cs@gmail.com
                for document in docs.documents { //doesnt go inside
                    
                    
                    output.append(document.documentID)
                    
                }
                completion(output)
            }else{
                completion([])
            }
        }
        
    }
}
