//
//  ClassManager.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/22/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


//An app object you can call anywhere and stores a class code locally
//you are able to get the code of the class that is currently in selection

///in short: used to keep track of what class user is in
class ClassData: ObservableObject {
    @Published var code: String
    init(code: String) {
        self.code = code
    }
    
}
//used to keep track of what class user is in

// the structure for a classroom object that is saved in the firebase databasde
struct Classroom: Codable, Hashable, Identifiable {
//    var requestInfo: [String] = []
//    var requests: [String:[String]] = [:]
    let code: String
    let managerCode: String
    let title: String
    let owner: String
    let peopleList: [String]
    let managerList: [String]
    let minServiceHours: Int
    let minSpecificHours: Int
    let colors: [String]
    var id: String {
        return code
    }
}

let db = Firestore.firestore()// creating the db variable which is a reference to the current Firestore database

//passes in a classroom object
//in the database store a class object inside the classes collection as a document named after its code
func storeClassInfoInFirestore(org: Classroom) {
    do {
        try db.collection("classes").document(org.code).setData(from: org)
    } catch {
        print("error storing new class")
    }
}

//passes in the code of a class as a string
//returns in a completion the classroom object associated with that code
func getClassInfo(classCloudCode: String, completion: @escaping (Classroom?) -> Void) {
    
    
    guard !classCloudCode.isEmpty else {
        print("Error: classCloudCode is empty")
        completion(nil)
        return
    }
    let classRef = db.collection("classes").document(classCloudCode)
    
    classRef.getDocument { document, error in
        
        
        
        if let error = error {
            print("Error getting classroom data: \(error)")
            completion(nil)
            return
        }
        
        if let doc = document, doc.exists {
            
            
            do {
                let output = try doc.data(as: Classroom.self)
                completion(output)
            } catch {
                print("Error decoding class data: \(error)")
                completion(nil)
            }
        } else {
            print("classroom data document does not exist")
            completion(nil)
        }
    }
}


//passes in a class code as a String
//returns in a compeltion a true or false value if a document already exists
//used to make sure the code you are creating for a class is not already used
func checkIfDocumentExists(documentID: String, completion: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    let documentReference = db.collection("classes").document(documentID)

    documentReference.getDocument { documentSnapshot, error in
        if let error = error {
            print("Error getting document: \(error.localizedDescription)")
            completion(false)
        } else if let documentSnapshot = documentSnapshot {
            completion(documentSnapshot.exists)
        }
    }
}

//returns a String of a newly generated class code
func createClassCode() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
       let numbers = "0123456789"
       
       var randomString = ""
       
       for _ in 0..<2 {
           // Add two random letters
           let randomIndex = Int.random(in: 0..<letters.count)
           let randomLetter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
           randomString.append(randomLetter)
       }
       
       for _ in 0..<4 {
           // Add four random numbers
           let randomIndex = Int.random(in: 0..<numbers.count)
           let randomNumber = numbers[numbers.index(numbers.startIndex, offsetBy: randomIndex)]
           randomString.append(randomNumber)
       }
       
    
       // Shuffle the string to randomize the order
       randomString = String(randomString.shuffled())
       
    isCodeUsedInCollection(code: randomString, collectionName: "classes", completion: { isUsed in
        if isUsed{
            randomString = createClassCode()
        }
    })
       return randomString
}

//creates a classroomCode for managers to use when joining a class's manager list
//returns a String of the code
func createManagerCode() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
       
    var randomString = ""
       
    for _ in 0..<3 {
        // Add two random letters
        let randomIndex = Int.random(in: 0..<letters.count)
        let randomLetter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
        randomString.append(randomLetter)
    }
       
    for _ in 0..<5 {
        // Add four random numbers
        let randomIndex = Int.random(in: 0..<numbers.count)
        let randomNumber = numbers[numbers.index(numbers.startIndex, offsetBy: randomIndex)]
        randomString.append(randomNumber)
    }
       
    
    // Shuffle the string to randomize the order
    randomString = String(randomString.shuffled())
       
    isCodeUsedInCollection(code: randomString, collectionName: "classes", completion: { isUsed in
        if isUsed {
            randomString = createManagerCode()
        }
    })
    
    return randomString
}


//passes in a class code as a String
//passes in the name of the collection in the database
//returns a true or false if the code is used or not respectively
func isCodeUsedInCollection(code: String, collectionName: String, completion: @escaping (Bool) -> Void) {
    
//    let db = Firestore.firestore()
    
    let collectionRef = db.collection(collectionName)
    
    collectionRef.whereField("code", isEqualTo: code).getDocuments { (snapshot, error) in
        guard error == nil, let snapshot = snapshot else {
            // Handle the error
            completion(false)
            return
        }
        
        // If any document has the same code, it's used
        completion(!snapshot.documents.isEmpty)
    }
}



/// Request struct
/// 1 email of User who made Request
/// 2 classCode associated with Request
/// 3 description of Request
/// 4 used for sorting by time
/// 5 type of hour: either service, attendance, or club-specific
/// 6 number of hours of hourType
/// 7 false means the Request is pending, true means the request has gone through
struct Request: Codable, Hashable, Identifiable {
    var id: String {
        return "\(UUID())"
    }
    /// 1
    var creator: String
    /// 2
    var classCode: String
    /// 3
    var description: String
    /// 4
    var timeCreated: Date
    /// 5
    var hourType: String
    /// 6
    var numHours: Int
    /// 7
    var accepted: Bool
    
    init(creator: String = "", classCode: String = "", description: String = "", timeCreated: Date = Date(), hourType: String = "", numHours: Int = 0, accepted: Bool = false) {
        self.creator = creator
        self.classCode = classCode
        self.description = description
        self.timeCreated = timeCreated
        self.hourType = hourType
        self.numHours = numHours
        self.accepted = accepted
    }
}

/// Adds a request to both the Classroom and User it belongs to with the request information
/// 1 creates a Request from the given info
/// 2 adds the Request to the request list in the classes collection
/// 3 adds the Request to the request list in the userInfo collection
/// 
func addRequest(classCode: String, email: String, hours: Int, type: String, description: String) {
    /// 1
    let req = Request(creator: email, classCode: classCode, description: description, hourType: type, numHours: hours)
    /// 2
    do {
        try db.collection("classes").document(classCode).collection("requests").addDocument(from: req)
    } catch {
        print(error.localizedDescription)
    }
    /// 3
    do {
        try db.collection("userInfo").document(email).collection("requests").addDocument(from: req)
    } catch {
        print(error.localizedDescription)
    }
}

/// Fetches all Requests from a Classroom using a classCode
/// 1 gets all documents in requests collection
/// 2 handles error
/// 3 creates a completion array
/// 4 appends each request to the completion array
/// 5 returns the completion array
func getClassRequests(classCode: String, completion: @escaping ([Request]) -> Void) {
    /// 1
    db.collection("classes").document(classCode).collection("requests").getDocuments { querySnapshot, error in
        /// 2
        if let error = error {
            print(error.localizedDescription)
            completion([])
        } else {
            /// 3
            var com: [Request] = []
            /// 4
            for document in querySnapshot!.documents {
                let data = document.data()
                
                let creator = data["creator"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                let timeTimestamp = data["timeCreated"] as? Timestamp
                let timeCreated = timeTimestamp?.dateValue() ?? Date()
                
                let hourType = data["hourType"] as? String ?? ""
                let numHours = data["numHours"] as? Int ?? 0
                
                let currReq = Request(creator: creator, classCode: classCode, description: description, timeCreated: timeCreated, hourType: hourType, numHours: numHours)
                
                com.append(currReq)
            }
            
            /// 5
            completion(com)
        }
    }
}

/// Fetches all Requests from a User using an email
/// 1 gets all documents in Requests collection
/// 2 handles error
/// 3 creates a completion array
/// 4 appends each request to the completion array
/// 5 returns the completion array
func getUserRequests(email: String, completion: @escaping ([Request]) -> Void) {
    /// 1
    db.collection("userInfo").document(email).collection("requests").getDocuments { querySnapshot, error in
        /// 2
        if let error = error {
            print(error.localizedDescription)
            completion([])
        } else {
            /// 3
            var com: [Request] = []
            /// 4
            for document in querySnapshot!.documents {
                let data = document.data()
                
                let classCode = data["classCode"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                let timeTimestamp = data["timeCreated"] as? Timestamp
                let timeCreated = timeTimestamp?.dateValue() ?? Date()
                
                let hourType = data["hourType"] as? String ?? ""
                let numHours = data["numHours"] as? Int ?? 0
                
                let accepted = data["accepted"] as? Bool ?? false
                
                let currReq = Request(creator: email, classCode: classCode, description: description, timeCreated: timeCreated, hourType: hourType, numHours: numHours, accepted: accepted)
                
                com.append(currReq)
            }
            
            /// 5
            completion(com)
        }
    }
}

/// Fetches pending Requests from a User using an email
/// 1 gets documents in Requests collection that are pending acceptance
/// 2 handles error
/// 3 creates a completion array
/// 4 appends each request to the completion array
/// 5 returns the completion array
func getPendingRequests(email: String, completion: @escaping ([Request]) -> Void) {
    /// 1
    db.collection("userInfo").document(email).collection("requests").whereField("accepted", isEqualTo: false).getDocuments() { query, error in
        /// 2
        if let error = error {
            print(error.localizedDescription)
            completion([])
        } else {
            /// 3
            var com: [Request] = []
            /// 4
            for document in query!.documents {
                let data = document.data()
                
                let classCode = data["classCode"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                let timeTimestamp = data["timeCreated"] as? Timestamp
                let timeCreated = timeTimestamp?.dateValue() ?? Date()
                
                let hourType = data["hourType"] as? String ?? ""
                let numHours = data["numHours"] as? Int ?? 0
                
                let currReq = Request(creator: email, classCode: classCode, description: description, timeCreated: timeCreated, hourType: hourType, numHours: numHours)
                
                com.append(currReq)
            }
            
            /// 5
            completion(com)
        }
    }
}

/// Accepts the Request
/// 1 finds Requests with correct creator and description
/// 2 handles error if no Request is found
/// 3 iterates through Requests with correct criteria looking for correct document
/// 4 deletes correct Request
/// 5 finds Requests with correct classCode and description
/// 6 handles error if no Request is found
/// 7 iterates through Requests with correct criteria looking for correct document
/// 8 sets accepted value to true for correct Request
func acceptRequest(request: Request, classCode: String) {
    /// 1
    db.collection("classes").document(classCode).collection("requests").whereField("creator", isEqualTo: request.creator).whereField("description", isEqualTo: request.description).getDocuments() { query, error in
        if let error = error {
            /// 2
            print(error.localizedDescription)
        } else {
            /// 3
            var wantedDocRef = query!.documents.first
            for docRef in query!.documents {
                db.collection("classes").document(classCode).collection("requests").document(docRef.documentID).getDocument() { doc, error in
                    let timeTimestamp = doc!["timeCreated"] as? Timestamp
                    let timeCreated = timeTimestamp?.dateValue() ?? Date()
                    
                    if timeCreated == request.timeCreated {
                        wantedDocRef = docRef
                    }
                }
            }
            /// 4
            db.collection("classes").document(classCode).collection("requests").document(wantedDocRef!.documentID).delete()
        }
    }
    /// 5
    db.collection("userInfo").document(request.creator).collection("requests").whereField("classCode", isEqualTo: request.classCode).whereField("description", isEqualTo: request.description).getDocuments() { query, error in
        /// 6
        if let error = error {
            print(error.localizedDescription)
        } else {
            /// 7
            var wantedDocRef = query!.documents.first
            for docRef in query!.documents {
                db.collection("userInfo").document(request.creator).collection("requests").document(docRef.documentID).getDocument() { doc, error in
                    let timeTimestamp = doc!["timeCreated"] as? Timestamp
                    let timeCreated = timeTimestamp?.dateValue() ?? Date()
                    
                    if timeCreated == request.timeCreated {
                        wantedDocRef = docRef
                    }
                }
            }
            /// 8
            db.collection("userInfo").document(request.creator).collection("requests").document(wantedDocRef!.documentID).updateData(["accepted" : !request.accepted])
        }
    }
}

/// Declines the Request
/// 1 deletes the Request from Classroom
/// 2 deletes the Request from User
func declineRequest(request: Request, classCode: String) {
    /// 1
    db.collection("classes").document(classCode).collection("requests").whereField("creator", isEqualTo: request.creator).whereField("description", isEqualTo: request.description).getDocuments() { query, error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            var wantedDocRef = query!.documents.first
            for docRef in query!.documents {
                db.collection("classes").document(classCode).collection("requests").document(docRef.documentID).getDocument() { doc, error in
                    let timeTimestamp = doc!["timeCreated"] as? Timestamp
                    let timeCreated = timeTimestamp?.dateValue() ?? Date()
                    
                    if timeCreated == request.timeCreated {
                        wantedDocRef = docRef
                    }
                }
            }
            db.collection("classes").document(classCode).collection("requests").document(wantedDocRef!.documentID).delete()
        }
    }
    /// 2
    db.collection("userInfo").document(request.creator).collection("requests").whereField("classCode", isEqualTo: request.classCode).whereField("description", isEqualTo: request.description).getDocuments() { query, error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            var wantedDocRef = query!.documents.first
            for docRef in query!.documents {
                db.collection("userInfo").document(request.creator).collection("requests").document(docRef.documentID).getDocument() { doc, error in
                    let timeTimestamp = doc!["timeCreated"] as? Timestamp
                    let timeCreated = timeTimestamp?.dateValue() ?? Date()
                    
                    if timeCreated == request.timeCreated {
                        wantedDocRef = docRef
                    }
                }
            }
            db.collection("userInfo").document(request.creator).collection("requests").document(wantedDocRef!.documentID).delete()
        }
    }
}

/// ClassTask struct
/// 1 email of User who made ClassTask
/// 2 title
/// 3 due date
/// 4 used for sorting by time
/// 5 limit of people allowed to sign up
/// 6 number of hours the task is worth
/// 7 list of people signed up
struct ClassTask: Codable, Hashable, Identifiable {
    var id: String {
        return "\(UUID())"
    }
    /// 1
    var creator: String
    /// 2
    var title: String
    /// 3
    var date: Date
    /// 4
    var timeCreated: Date
    /// 5
    var maxSize: Int
    /// 6
    var numHours: Int
    /// 7
    var listOfPeople: [String]?
    
    init(creator: String = "", title: String = "", date: Date = Date(), timeCreated: Date = Date(), maxSize: Int = 0, numHours: Int = 0, listOfPeople: [String]? = []) {
        self.creator = creator
        self.title = title
        self.date = date
        self.timeCreated = timeCreated
        self.maxSize = maxSize
        self.numHours = numHours
        self.listOfPeople = listOfPeople
    }
}

func addTask(classCode: String, creator: String, title: String, date: Date, timeCreated: Date, maxSize: Int, numHours: Int, listOfPeople: [String]? = []) {
    
    let task = ClassTask(creator: creator, title: title, date: date, timeCreated: timeCreated, maxSize: maxSize, numHours: numHours, listOfPeople: listOfPeople)
    
    do {
        try db.collection("classes").document(classCode).collection("tasks").addDocument(from: task)
    } catch {
        print(error.localizedDescription)
    }
}

func getTasks(classCode: String, completion: @escaping ([ClassTask]) -> Void) {
    db.collection("classes").document(classCode).collection("tasks").getDocuments { querySnapshot, error in
        if let error = error {
            print("Error fetching tasks: \(error.localizedDescription)")
            completion([])
            return
        }
        
        var classTasks: [ClassTask] = []
        for document in querySnapshot!.documents {
            let taskData = document.data()
            
            let dateTimestamp = taskData["date"] as? Timestamp
            let date = dateTimestamp?.dateValue() ?? Date()
            
            let timeTimestamp = taskData["timeCreated"] as? Timestamp
            let timeCreated = timeTimestamp?.dateValue() ?? Date()
            
            let newClassTask = ClassTask(
                creator: taskData["creator"] as? String ?? "",
                title: taskData["title"] as? String ?? "",
                date: date,
                timeCreated: timeCreated,
                maxSize: taskData["maxSize"] as? Int ?? 0,
                numHours: taskData["numHours"] as? Int ?? 0,
                listOfPeople: taskData["listOfPeople"] as? [String] ?? [])
            classTasks.append(newClassTask)
        }
        
        completion(classTasks)
    }
}

//to cancel signup/unregister from task:
//simply get the people from getTaskParticipants
//and find the index of your email,
//update using this function and listOfPeople is the new list with you removed
func updateTaskParticipants(classCode: String, title: String, listOfPeople: [String]) {
    db.collection("classes").document(classCode).collection("tasks").whereField("title", isEqualTo: title).getDocuments { query, error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            let docRef = query!.documents.first
            db.collection("classes").document(classCode).collection("tasks").document(docRef!.documentID).updateData(["listOfPeople":listOfPeople])
        }
    }
}

func getTaskParticipants(classCode: String, title: String, completion: @escaping([String]) -> Void) {
    db.collection("classes").document(classCode).collection("tasks").whereField("title", isEqualTo: title).getDocuments { query, error1 in
        if let error1 = error1 {
            print(error1.localizedDescription)
            completion([])
        } else {
            let docRef = query!.documents.first
            db.collection("classes").document(classCode).collection("tasks").document(docRef!.documentID).getDocument { doc, error2 in
                if let error2 = error2 {
                    print(error2.localizedDescription)
                    completion([])
                } else {
                    if let doc = doc {
                        completion(doc["listOfPeople"] as? [String] ?? [])
                    }
                }
            }
        }
    }
}

func acceptRequest(request: [String:String], classCode: String) {
    
    let email = request["email"]!
    let hours = Int(request["hours"] ?? "0")!
    let type = request["type"]!
    let id = request["ID"] ?? ""
    getClassHours(email: email, type: type) { classHours in
        if var classHours = classHours{
            let currHours: Int = classHours[type] ?? 0
            
            classHours[type] = currHours + hours
            db.collection("userInfo").document(email).updateData(["classHours":classHours])
            
        
            
            
        }
    }
    
    getData(uid: email) { user in
        if let user = user {
            updateHours(uid: email, newHourCount: (user.hours ?? 0) + Float(hours))
        }
    }
    
    if id != "" {
        db.collection("classes").document(classCode).collection("requests").document(id).delete()
    }
    
}

func declineRequest(request: [String:String], classCode: String) {
    if let requestID = request["ID"] {
        db.collection("classes").document(classCode).collection("requests").document(requestID).delete()
    }
}


func addPersonToClass(person: String, classCode: String) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var people = map?["peopleList"] as? [String] ?? [""]
                
                people.append(person)
                db.collection("classes").document(classCode).updateData(["peopleList":people])
            }
        }
    }
}

func removePersonFromClass(person: String, classCode: String) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var people = map?["peopleList"] as? [String] ?? [""]
                let personIndex = people.firstIndex(of: person)
                
                if personIndex != nil {
                    people.remove(at: personIndex!)
                }
                
                db.collection("classes").document(classCode).updateData(["peopleList":people])
            }
        }
    }
}

func getPeopleList(classCode: String, completion: @escaping([String]) -> Void) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document \(error.localizedDescription)")
            completion([])
        } else {
            if let document = document {
                completion(document["peopleList"] as? [String] ?? [])
            }
        }
    }
}

func addManagerToClass(person: String, classCode: String) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var managers = map?["managerList"] as? [String] ?? [""]
                
                managers.append(person)
                db.collection("classes").document(classCode).updateData(["managerList":managers])
            }
        }
    }
}

func removeManagerFromClass(person: String, classCode: String) {

    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var managers = map?["managerList"] as? [String] ?? [""]
                let personIndex = managers.firstIndex(of: person)
                
                if personIndex != nil {
                    managers.remove(at: personIndex!)
                }
                
                db.collection("classes").document(classCode).updateData(["managerList":managers])
            }
        }
    }
}

func isClassOwner(classCode: String, uid: String, completion: @escaping (Bool) -> Void) {
    
    // call tshis func that will return if the user is the owner of class or not
    
    let classRef = db.collection("classes").document(classCode)
    
    classRef.getDocument { (classDocument, classError) in
        if let classError = classError {
            print("Error getting class document: \(classError.localizedDescription)")
            completion(false)
            
        } else {
            // store the auth id winto var ownerID

            if let classDocument = classDocument, let ownerId = classDocument.data()?["owner"] as? String {

                let userInfoRef = db.collection("userInfo").document(uid)
                userInfoRef.getDocument { (userDocument, userError) in
                    
                    if let userError = userError {
                        print("Error getting user document: \(userError.localizedDescription)")
                        completion(false)
                        
                    } else {
                        
                        // store the uid into var userID thingy
                        if let userDocument = userDocument, let userId = userDocument.data()?["uid"] as? String {

                            completion(userId == ownerId)
                            
                        } else {
                            print("User document does not exist or does not contain uid field")
                            completion(false)
                        }
                    }
                }
            } else {
                print("Class document does not exist or does not contain owner field")
                completion(false)
            }
        }
    }
}


func demoteManager(person: String, classCode: String) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var peopleList = map?["peopleList"] as? [String] ?? []
                
                if peopleList.contains(person) {
                    removeManagerFromClass(person: person, classCode: classCode)
                } else {
                    removeManagerFromClass(person: person, classCode: classCode)
                    addPersonToClass(person: person, classCode: classCode)
                }
            }
        }
    }
}

func getManagerList(classCode: String, completion: @escaping([String]) -> Void) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document \(error.localizedDescription)")
            completion([])
        } else {
            if let document = document {
                completion(document["managerList"] as? [String] ?? [])
            }
        }
    }
}

func getColorScheme(classCode: String, completion: @escaping([Color]) -> Void) {
    let docRef = db.collection("classes").document(classCode)
    
    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let colorsStringList = document.data()?["colors"] as? [String] ?? [""]
                var colors: [Color] = []
                for colorStr in colorsStringList {
                    colors.append(hexToColor(hex: colorStr))
                }
                completion(colors)
            }
        }
    }
}



func setColorScheme(classCode: String, colors: [Color]) {
    var colorStrings: [String] = []
    for color in colors {
       
        colorStrings.append(colorToHex(color: color))
    }
    db.collection("classes").document(classCode).updateData(["colors":colorStrings])
}

struct Announcement: Codable, Hashable, Identifiable {
    var id: String {
        return "\(UUID())"
    }
    
    var creator: String
    var date: Date
    var message: String
    
    init(creator: String = "", date: Date = Date(), message: String = "") {
        
        self.creator = creator
        self.date = date
        self.message = message
        
    }
    
    init() {
        
        self.creator = ""
        self.date = Date()
        self.message = ""
        
    }
}

func postAnnouncement(maker: String, message: String, time: Date = Date(), classCode: String, completion: @escaping () -> Void){
    
    let collection = db.collection("classes").document(classCode).collection("announcements")
    let message = Announcement(creator: maker, date: time, message: message)
    
    do {
        try collection.addDocument(from: message)
    } catch {
        print(error.localizedDescription)
    }
    
}

func getAnnouncements(classCode: String, completion: @escaping ([Announcement]) -> Void) {
    db.collection("classes").document(classCode).collection("announcements").getDocuments { query, error in
        
        if let error = error{
            print(error.localizedDescription)
        } else {
            
            var announcements: [Announcement] = []
            let dispatchGroup = DispatchGroup()
            if let docs = query {
                for doc in docs.documents {
                    dispatchGroup.enter()
                    do {
                        let announcement = try doc.data(as: Announcement.self)
                        if !announcements.contains(announcement) {
                            announcements.append(announcement)
                        }
                    } catch {
                        print(error.localizedDescription)

                    }
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) {
                    completion(announcements)
                }
            }
            
        }
    }
}

func deleteAnnouncement(classCode: String, time: Date, message: String){
    
    
    db.collection("classes").document(classCode).collection("announcements").whereField("time", isEqualTo: time).getDocuments { query, error in
        if let error = error{
            print(error.localizedDescription)
        }else{
            
            
            if let docs = query?.documents {
                
                for doc in docs {
                    if let docMessage = doc["message"] as? String, docMessage == message {
                        
                        db.collection("classes").document(classCode).collection("announcements").document(doc.documentID).delete()
                        
                    }
                }
                
                
                
            }
        }
    }
    
}
