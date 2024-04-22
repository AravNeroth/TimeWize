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
    @Published var displayName = ""
    @Published var fresh = false
    @Published var studentFresh = false
    @AppStorage("managerMode") var isManagerMode: Bool = false
    @Published var pfp: UIImage = UIImage()
    @Published var perfHourRange = 20
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    @Published var title: String = "Classes"
//    @Published var classes: [String] = UserDefaults.standard.stringArray(forKey: "classes") ?? [] {
//        didSet{
//            updateUserDefaults()
//        }
//    }

//    @Published var managerClassObjects: [Classroom] = []
    @Published var inClass = false
    @Published var tab: Int = 2
    @Published var manTab: Int = 1
    @Published var userColors: [Color] = []
    @Published var dm: String = ""
//     func updateUserDefaults() {
//           UserDefaults.standard.set(classes, forKey: "classes")
//       }
//     func zeroUserDefaults(){
//        UserDefaults.standard.set([], forKey: "classes")
//    }
}
//End of settingsManager




class ClassInfoManager: ObservableObject {
    @Published var classInfo: [Classroom] = []
    @Published var classImages: [String: UIImage] = [:]
    @Published var classPfp: [String: UIImage] = [:]
    @Published var managerClassImages: [String: UIImage] = [:]
    @Published var managerClassPfp: [String: UIImage] = [:]
    
    @Published var allClasses: [Classroom] = []
    @Published var allRequests: [Request] = []
    @Published var classColors: [Classroom:[Color]] = [:]
    @Published var classOwners: [Classroom:String] = [:]
    var classCodes: [String] = []
    ///-----------------------------------------------------
    ///manager class info variables
    @Published var classes: [String] = [] //list of managing classes codes
    @Published var allManagerClasses: [Classroom] = []
    @Published var ownerPfps: [Classroom:UIImage] = [:]
    
    
    ///methods
    ///----------------------------------------------------
    ///
    func updateManagerData(userID: String, completion: ((Bool) -> Void)? = nil){
        let DG = DispatchGroup()
        DG.enter() //getClasses
        DG.enter() //for loop
        getClasses(uid: userID) { list in
            defer{DG.leave()}
            if let list = list {
                self.classes = list // list of codes

            }
        }
       //add a semaphore between?
        for code in classes {
            DG.enter() //getting class info
            getClassInfo(classCloudCode: code) { classroom in
                DG.enter() //downloadImage task
                DG.enter() //getColorScheme task
                
                if let classroom = classroom {
                    if !self.allManagerClasses.contains(classroom){
                        self.allManagerClasses.append(classroom)
                    }
                    downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                        if let image = image {
                            self.ownerPfps[classroom] = image
                        }
                        DG.leave()
                    }
                    
                    getColorScheme(classCode: classroom.code) { colors in
                        if !colors.isEmpty {
                            self.classColors[classroom] = colors
                        }
                        DG.leave()
                    }
                }
                
                
                DG.leave()
            }
            if code == classes.last{
                DG.leave()
            }
        }
        
        DG.notify(queue: .main) {
            completion?(true)
        }
    }
    
    
    func updateData(userID: String, completion: ((Bool) -> Void)? = nil){
        
        getCodes(uid: userID) { codes in
            if var codes = codes {
                while codes.contains("") {
                    let remove = codes.firstIndex(of: "")
                    if let index = remove {
                        codes.remove(at: index)
                    }
                }
                
                self.classCodes = codes
                
                for classCode in codes {
                    if classCode == "" {
                        continue
                    }
                    
                    getClassInfo(classCloudCode: classCode) { newClass in
                        let list = newClass?.managerList
                        
                        if let list = list {
                            getData(uid: list.first!) { newUser in
                                self.classOwners[newClass!] = (newUser?.displayName)!
                            }
                        }
                        
                        getColorScheme(classCode: classCode) { scheme in
                            self.classColors[newClass!] = scheme
                        }
                        
                        getUserRequests(email: userID) { requests in
                            self.allRequests = requests
                        }
                    }
                }
            }
            
            self.loadClassInfo() { _ in
                if let completion{
                    completion(true)
                }
            }
        }
        
        
        
    }
    
    private func loadClassInfo(completion: ((Bool)->Void)? = nil) {
        for code in classCodes {
            getClassInfo(classCloudCode: code) { classroom in
                if let classroom = classroom {
                    if !self.classInfo.contains(classroom) {
                        self.classInfo.append(classroom)
                        
                        downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg") { image in
                            self.classImages[classroom.title] = image
                        }
                    
                        downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                            if let image = image {
                                self.classPfp[classroom.title] = image
                            }
                        }
                    }
                    if !self.allClasses.contains(classroom) {
                        self.allClasses.append(classroom)
                    }
                }
                
                self.classInfo.sort { $0.title < $1.title }
                self.allClasses.sort { $0.title < $1.title }
                
                if code == self.classCodes.last {
                    if let completion{
                        completion(true)
                    }
                }
            }
        }
        
        
        
    }

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
        //if dispatch works correctly we can remove the completion
        let dispatchG = DispatchGroup()
        var names: [String:String] = [:]
        for email in emails{
            dispatchG.enter()
            getName(email: email) { name in
                defer{dispatchG.leave()}
                names[email] = name
            }
        }
        
        
        dispatchG.notify(queue: .main){
            completion(names)
        }
    }
    //passes in a list of emails the user is chatting with
    //passes in the email of the current user
    //returns in a completion a dictionary of emails as keys and Messages (custom struct) as the values
    func getLatestMessage(chats: [String], user: String, completion: @escaping ([String: Message]) -> Void ){
        var message: [String:Message] = [:]
        let dispatchG = DispatchGroup()
            for chat in chats{
                
                print("enter")
                print(chat)
                dispatchG.enter()
                getMessages(user: user, from: chat) { messages in
                    
                    let newmessages = messages.sorted(by: {$0.time < $1.time})
                    if let last = newmessages.last{
                        message[chat] = last
                        
                    }
                    print("leave")
                    dispatchG.leave()
                }
                
            }
        
        
        dispatchG.notify(queue: .main) {
            completion(message)
        }
            
        
    }
    
    
    //chats: an array of emails for each email a user is chatting with
    //Function that updates the environment variable MessageManager's chatImages property based on newly found values for keys
    func updateImagesForChats(chats:[String], completion: (() -> (Void))? = nil ){
        var count = chats.count
        for chat in chats {
            defer {
                count -= 1
                if count == 0{
                    completion?()
                }
            }
            
            getAuthIDForEmail(email: chat){ id in
                
                downloadImageFromUserStorage(id: id, file: "Pfp\(id).jpg") { image in
                    
                    if let image = image{
                        if self.chatImages[chat] != Image(uiImage: image){
                            self.chatImages[chat] = Image(uiImage: image)
                        }

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
    
    ///function that will keep being called
    ///as the funciton is called it updates all the message related variables that
    ///are stored locally in MessageManager
    ///Dispatch Group to make sure everything is being called before compeltion
    func updateData(userID: String, completion: ((Bool)->Void)? = nil){
        let DG = DispatchGroup()
        
        DG.enter() //getChatsOf
        DG.enter() //getNames
        DG.enter() //update images
        DG.enter() //getLatestMessage
       
        getChatsOf(user: userID) { [self] chats in
            defer{ DG.leave()} //getChatsOf done
            if !chats.isEmpty{
                self.userChats = chats
                
            }
                
            getNames(emails: chats) { names in
                defer { DG.leave()}
                
                if !names.isEmpty{
                    for(key, value) in names {
                        DG.enter()
                        defer { DG.leave()}
                        self.chatNames[key] = value
                    }

                }
                
            }
            
            updateImagesForChats(chats: chats){
                DG.leave()
            }
            
            getLatestMessage(chats: chats, user: userID){ lastChats in
                defer{ DG.leave()}
                
                if !lastChats.isEmpty{
                    for(key, value) in lastChats {
                        DG.enter()
                        print("e")
                        defer{ DG.leave()}
                        self.lastMessages[key] = value
                    }
                }
                
            }
            

            
        }
        
        DG.notify(queue: .main) {
            completion?(true)
        }
    }
    
}



//End of MessageManager
