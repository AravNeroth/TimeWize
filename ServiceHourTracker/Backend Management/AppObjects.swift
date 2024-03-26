//
//  AppObjects.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/10/24.
//

import Foundation
import SwiftUI



// Settings, classInfo, and message managers are app objects to access current local variables throughout all files and views

class SettingsManager: ObservableObject {
    static var shared =  SettingsManager()
    @Published var fresh = false
    @Published var studentFresh = false
    @AppStorage("managerMode") var isManagerMode: Bool = false
    @Published var pfp: UIImage = UIImage()
    @Published var perfHourRange = 20
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    @Published var title: String = "Classes"
    @Published var classes: [String] = UserDefaults.standard.stringArray(forKey: "classes") ?? [] {
        didSet{
            updateUserDefaults()
        }
    }

    @Published var managerClassObjects: [Classroom] = []
    @Published var inClass = false
    @Published var tab: Int = 2
    @Published var manTab: Int = 1
    @Published var userColors: [Color] = []
    
     func updateUserDefaults() {
           UserDefaults.standard.set(classes, forKey: "classes")
       }
     func zeroUserDefaults(){
        UserDefaults.standard.set([], forKey: "classes")
    }
}
//End of settingsManager




class ClassInfoManager: ObservableObject {
    @Published var classInfo: [Classroom] = []
    @Published var classImages: [String: UIImage] = [:]
    @Published var classPfp: [String: UIImage] = [:]
    @Published var managerClassImages: [String: UIImage] = [:]
    @Published var managerClassPfp: [String: UIImage] = [:]
}

//End of classInfoManager




class MessageManager: ObservableObject{
    
    @Published var messages: [Message] = [] //a list of the current Messages (based on the chat youre in)
    @Published var loading = true
    @Published var userChats: [String] = [] // a list of people's emails youre chatting with
    @Published var chatNames: [String:String] = [:] // a dictionary of email:name
    @Published var chatImages: [String:Image] = [:] // a dictionary of email:profile picture image
    @Published var lastMessages: [String:Message] = [:] // a dictionary of email:latest Message in the log
    
    //takes in a list of emails a user is chatting with
    //returns a name as a value for each email key
    func getNames(emails: [String], completion: @escaping ([String:String])-> Void ){
        var names: [String:String] = [:]
        for email in emails{
            getName(email: email) { name in
                names[email] = name
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            completion(names)
        }
    }
    //passes in a list of emails the user is chatting with
    //passes in the email of the current user
    //returns in a completion a dictionary of emails as keys and Messages (custom struct) as the values
    func getLatestMessage(chats: [String], user: String, completion: @escaping ([String: Message]) -> Void ){
        var message: [String:Message] = [:]
   
            for chat in chats{
                getMessages(user: user, from: chat) { messages in
                    let newmessages = messages.sorted(by: {$0.time < $1.time})
                    if let last = newmessages.last{
                        message[chat] = last
                        
                    }
                }
                
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion(message)
        }
            
        
    }
    
    
    //chats: an array of emails for each email a user is chatting with
    //Function that returns in a completion a dictionary of emails to their associated profile picture
    func getImagesForChats(chats:[String], completion: @escaping ([String:Image]) -> Void ){
        var images: [String:Image] = [:]
        for chat in chats {
            getAuthIDForEmail(email: chat){ id in
                print("Pfp\(id).jpg")
                downloadImageFromUserStorage(id: id, file: "Pfp\(id).jpg") { image in
                    if let image = image{
                        images[chat] = Image(uiImage: image)
                        completion(images)
                    }
                }
                
            }
        }
        
    }

    //passes in the user email of who it is sending it too
    //passes in the person who its coming from: usually current user's email (whoever sends the message through the app)
    //updates the messages list of MessageManager
    func getMessagesList(user: String, from: String){
        loading = true
        getMessages(user: user, from: from) { messages in
            let chat = db.collection("userInfo").document(user).collection("Messages").document(from).collection("chat")
            
            chat.addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
                    
                }
                self.messages = documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                }.sorted(by: { $0.time < $1.time })
                self.loading = false
                
                
            }
            
        }
    }
    
}



//End of MessageManager
