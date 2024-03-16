//
//  AppObjects.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/10/24.
//

import Foundation
import SwiftUI

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
    //is UserDefaults creating the bug?
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


class ClassInfoManager: ObservableObject {
    @Published var classInfo: [Classroom] = []
    @Published var classImages: [String: UIImage] = [:]
    @Published var classPfp: [String: UIImage] = [:]
    @Published var managerClassImages: [String: UIImage] = [:]
    @Published var managerClassPfp: [String: UIImage] = [:]
}

class MessageManager: ObservableObject{
    
    @Published var messages: [Message] = []
    @Published var loading = true
    
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
