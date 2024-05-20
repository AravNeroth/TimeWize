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
    //HourBoard
    @Published var points: [CGFloat] = [0]
    @Published var classPoints: [Classroom:[CGFloat]] = [:]
    @Published var totalHoursEarned: [Classroom:Int] = [:]
    @Published var minHours: [Classroom: Int] = [:]
    @Published var totalHours = 0
    @Published var totalGoal = 0
    //-------------------------------------------
    @Published var classInfo: [Classroom] = []
    @Published var classImages: [String: UIImage] = [:]
    @Published var classPfp: [String: UIImage] = [:]
    @Published var managerClassImages: [String: UIImage] = [:] //doesnt get updated in function calls
    @Published var managerClassPfp: [String: UIImage] = [:] //doesnt get updated in function calls
    
    @Published var allClasses: [Classroom] = []
    @Published var allRequests: [Request] = []
    @Published var requestsPerPerson: [String:[Request]] = [:]
    @Published var classColors: [Classroom:[Color]] = [:]
    @Published var classOwners: [Classroom:String] = [:]
    var classCodes: [String] = []
    ///-----------------------------------------------------
    ///manager class info variables
    @Published var classes: [String] = [] // list of managing classes codes
    @Published var allManagerClasses: [Classroom] = []
    @Published var ownerPfps: [Classroom:UIImage] = [:]
    
    
    ///methods
    ///----------------------------------------------------
    ///
    func updateManagerData(userID: String, completion: ((Bool) -> Void)? = nil){
       
        let DG = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        DG.enter() //getClasses
        DG.enter() //for loop
        
        semaphore.wait()
        getClasses(uid: userID) { list in
            defer{DG.leave()}
            if let list = list {
                self.classes = list // list of codes

            }
        }
        semaphore.signal()
      
        for code in classes {
            DG.enter() //getting class info
            getClassInfo(classCloudCode: code) { classroom in
                DG.enter() //downloadImage task
                DG.enter() //getColorScheme task
                
                if let classroom = classroom {
                    if !self.allManagerClasses.contains(classroom) {
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
        
        let DG = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
       
        
        
        DG.enter() //user Requests
        
        getCodes(uid: userID) { codes in
            semaphore.wait()
            if var codes = codes {
               
                while codes.contains("") {
                    let remove = codes.firstIndex(of: "")
                    if let index = remove {
                        codes.remove(at: index)
                    }
                }// remove empty codes
                
                semaphore.signal()
                
                self.classCodes = Array(Set(codes))
                
                for classCode in codes {
                    DG.enter()//get classes info
                    DG.enter() //getData
                    DG.enter()//color scheme
                    
                    
                    if classCode == "" {
                        continue
                    }
                    
                    getClassInfo(classCloudCode: classCode) { newClass in
                        defer{ DG.leave() }  //classInfo
                        
                        let list = newClass?.managerList
                        
                        if let list = list {
                            
                            defer{DG.leave()} //getData
                            
                            getData(uid: list.first!) { newUser in
                                
                                self.classOwners[newClass!] = (newUser?.displayName)!
                                
                               
                            }
                            
                        } else {
                            DG.leave() //getData
                        }
                        
                        getColorScheme(classCode: classCode) { scheme in
                            self.classColors[newClass!] = scheme
                            DG.leave() //color shceme
                        }
                        
                        
                    }
                }
            }else{
                semaphore.signal()
            }
            
            getUserRequests(email: userID) { requests in
                self.allRequests = requests
                DG.leave() // requests
            }
            
           
                
            
        }
        
        DG.notify(queue: .main) {
            self.loadClassInfo() { _ in
                
                completion?(true)
                
            }
        }
        
    }
    
    private func loadClassInfo(completion: ((Bool)->Void)? = nil) {
        let DG = DispatchGroup()
        for _ in 0..<classCodes.count{
            DG.enter()
        }
        for code in classCodes {
            getClassInfo(classCloudCode: code) { classroom in
                if let classroom = classroom {
                    
                    if !self.classInfo.contains(where: { $0.code == classroom.code }) {
                        self.classInfo.append(classroom)
                        
                        downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg") { image in
                            self.classImages[classroom.title] = image
                        }
                    
                        downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                            if let image = image {
                                self.classPfp[classroom.title] = image
                            }
                        }
                        self.allClasses.append(classroom)
                    } else {
                        self.classInfo[self.classInfo.firstIndex(where: { $0.code == classroom.code })!] = classroom
                        
                        downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg") { image in
                            self.classImages[classroom.title] = image
                        }
                    
                        downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                            if let image = image {
                                self.classPfp[classroom.title] = image
                            }
                        }
                        
                        self.allClasses[self.allClasses.firstIndex(where: { $0.code == classroom.code })!] = classroom
                    }
                }
                
                self.classInfo.sort { $0.title < $1.title }
                self.allClasses.sort { $0.title < $1.title }
                
                
            }
            DG.leave()
        }
        
        DG.notify(queue: .main) {
            completion?(true)
        }
        
    }

    
    func loadHourBoard(completion: ((Bool)->Void)? = nil){
        let DG = DispatchGroup()
        DG.enter()//allClasses
        DG.enter()//allrequests
    var newMinHours: [Classroom: Int] = [:]
        var newTotalHours = 0
        var newTotalGoal = 0
        var newTotalHoursEarned: [Classroom:Int] = [:]
        for classroom in self.allClasses {
            newTotalGoal += classroom.minSpecificHours + classroom.minServiceHours
            newMinHours[classroom] = classroom.minServiceHours+classroom.minSpecificHours
            if classroom == self.allClasses.last{
                DG.leave()//allClasses
            }
        }
        for request in self.allRequests {
            DG.enter()//getClassInfo
            getClassInfo(classCloudCode: request.classCode) { classroom in
                
                if request.accepted && (classroom != nil ? request.timeCreated > classroom!.lastCollectionDate : true) {
                    //&& request.classCode == classroom.code this causes no hours to be listed
                    newTotalHours += request.numHours
                    
                    if let classroom = classroom{
                        if newTotalHoursEarned[classroom] != nil {
                            newTotalHoursEarned[classroom]! += request.numHours
                            DG.leave()//getClassInfo
                        } else {
                            newTotalHoursEarned[classroom] = request.numHours
                            DG.leave()//getClassInfo
                        }
                    }
                }else{
                    DG.leave()//getClassInfo
                }
            }
            if request == self.allRequests.last {
                DG.leave()//allRequests
            }
        }
        
//                        let LimitedTotalHoursEarned = totalHoursEarned.values.map({ min($0, minHours[$0]) })
        //change the min to the classroom min
        //gets here with totalHoursEarned having 0 values
        DG.notify(queue: .main) {
            var newPoints: [CGFloat] = [0]
            for (classroom) in newTotalHoursEarned.keys.sorted(by: {$0.title > $1.title}) {
                if let hours = newTotalHoursEarned[classroom] {
                    if hours > newMinHours[classroom] ?? 0{
                        newPoints.append(newPoints.last! + CGFloat((newMinHours[classroom] ?? 0)*360/(newTotalGoal)))
                        
                    }else{
                        newPoints.append(newPoints.last! + CGFloat(hours*360/(newTotalGoal)))
                    }
                }
                
                if classroom == Array(newTotalHoursEarned.keys).last{
                    print(self.allClasses)
                    print(newTotalHoursEarned.keys)
                    if self.totalHours != newTotalHours{
                        self.points = newPoints
                        self.totalHoursEarned = newTotalHoursEarned
                        self.totalHours = newTotalHours
                        self.totalGoal = newTotalGoal
                        self.minHours = newMinHours
                    }
                    completion?(true)
                }
            }
        }
        
        //                    getUserRequests(email: userID) { requestList in
        //                        for request in requestList {
        //
        //
        //                            getClassInfo(classCloudCode: request.classCode) { classroom in
        //                                if let classroom = classroom{
        //                                    classes.append(classroom)
        //                                    points.append(CGFloat(points.last + request.numHours*360/100/totalGoal))
        //                                }
        //                            }
        //
        //                        }
        //                    }
        
        
        
        
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
            print("gotChats")
            if !chats.isEmpty{
                self.userChats = chats
                
            }
                
            getNames(emails: chats) { names in
                print("gotNames")
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
                print("updatedImages")
                DG.leave()
            }
            
            getLatestMessage(chats: chats, user: userID){ lastChats in
                print("gotLatestMessages")
                defer{ DG.leave()}
                
                if !lastChats.isEmpty{
                    for(key, value) in lastChats {
                        DG.enter()
                        
                        defer{ DG.leave()}
                        self.lastMessages[key] = value
                    }
                }
                
            }
            

            
        }
        
        DG.notify(queue: .main) {
            print("completion")
            completion?(true)
        }
    }
    
}



//End of MessageManager
