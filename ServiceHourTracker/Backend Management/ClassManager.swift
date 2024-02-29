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


class ClassData: ObservableObject {
    @Published var code: String
    init(code: String) {
        self.code = code
    }
    
}
//used to keep track of what class user is in


struct Classroom: Codable, Hashable, Identifiable {
//    var requestInfo: [String] = []
//    var requests: [String:[String]] = [:]
    let code: String
    let managerCode: String
    let title: String
    let owner: String
    let ownerName: String
    let peopleList: [String]
    let managerList: [String]
    let minServiceHours: Int
    let minSpecificHours: Int
    var id: String {
        return code
    }
}

let db = Firestore.firestore()

func storeClassInfoInFirestore(org: Classroom) {
    do {
        try db.collection("classes").document(org.code).setData(from: org)
    } catch {
        print("error storing new class")
    }
}


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

//use class to get into class, goes to the requests collection or creates a requests collection and adds a document with our data
func addRequest(classCode: String, email: String, hours: Int, type: String, description: String) {
   
   
    db.collection("classes").document(classCode).collection("requests").addDocument(data: ["email": email, "hours":hours,"type":type,"description":description])
    
    
}

//didnt finish thinking through
func getRequests(classCode: String, completion: @escaping ([[String:String]]) -> Void){
    
    db.collection("classes").document(classCode).collection("requests").getDocuments { docs, error in
        if let error = error{
            print(error.localizedDescription)
            completion([])
        }else{
            var com:[[String:String]] = []//completion output
            var output: [String:String] = [:]//temp for each document
            if let docs = docs{
                for document in docs.documents {
                    
                    let data = document.data()
                    output["email"] = data["email"] as? String ?? ""
                    output["hours"] = "\(data["hours"] ?? 0)"
                    output["type"] = data["type"] as? String ?? ""
                    output["description"] = data["description"] as? String ?? ""
                    output["ID"] = document.documentID
                    output["classCode"] = classCode
                    com.append(output)
                    output = [:]
                }
                completion(com)
            }else{
                completion([])
            }
        }
        
    }
    
    
}


func addTask(classCode: String, title: String, date: Date, maxSize: Int, numHours: Int, listOfPeople: [String]? = []) {
   
    let dateFormated = date.formatted(date: .numeric, time: .omitted) //the date is numeric but it omits the time stamp ex: 2/15/2024
    db.collection("classes").document(classCode).collection("tasks").document(classCode + title)
        .setData(
            ["title" : title, "date" : dateFormated, "size" : maxSize, "hours": numHours, "people": listOfPeople ?? []]
        )
    print("Hours: \(numHours) in addTask")
}

func getTasks(classCode: String, completion: @escaping ([[String:String]]) -> Void) {
    
    db.collection("classes").document(classCode).collection("tasks").getDocuments { docs, error in
        if let error = error {
            print(error.localizedDescription)
            completion([])
        } else {
            var com:[[String:String]] = [] //completion output
            var output: [String:String] = [:] //temp for each document
            if let docs = docs{
                for document in docs.documents {
                    
                    let data = document.data()
                    output["title"] = data["title"] as? String ?? ""
                    output["date"] = data["date"] as? String ?? ""
                    
                    if let peopleList = data["people"] as? [String]{
                        output["people"] = "\(peopleList.count)"
                    }
                    output["size"] = "\(data["size"] ?? 0)"
                    output["hours"] = "\(data["hours"] ?? 0)"
                    output["ID"] = document.documentID
                   
                
                    com.append(output)
                    output = [:]
                }
                completion(com)
            } else {
                completion([])
            }
        }
        
    }
    
    
}

//to cancel signup/unregister from task:
//simply get the people from getTaskParticipants
//and find the index of your email,
//update using this function and listOfPeople is the new list with you removed
func updateTaskParticipants(classCode:String, title: String, listOfPeople: [String]){
    db.collection("classes").document(classCode).collection("tasks").document(classCode + title).getDocument { doc, error in
        if let error = error{
            print(error.localizedDescription)
        }else{
            if let doc = doc{
                if listOfPeople.count <= (doc["size"] as? Int) ?? 0 {
                    db.collection("classes").document(classCode).collection("tasks").document(classCode + title).updateData(["people" : listOfPeople])
                    
                } else {
                    print("too many people added")
                }
            }
        }
    }
    
}

func getTaskParticipants(classCode:String, title:String, completion: @escaping([String]) -> Void) {
    db.collection("classes").document(classCode).collection("tasks").document(classCode + title).getDocument { doc, error in
        if let error = error{
            print(error.localizedDescription)
        }else{
            if let doc = doc{
                completion(doc["people"] as? [String] ?? [])
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

func fetchOwnerName(classCode: String, completion: @escaping(String) -> Void) {
    let classesDocRef = db.collection("classes").document(classCode)
    //let peopleDocRef = db.collection("userInfo")
    
    classesDocRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
        } else {
            if let document = document {
                let map = document.data()
                var email = map?["ownerName"] as? String ?? ""
                
                let peopleDocRef = db.collection("userInfo").document(email)
                
                peopleDocRef.getDocument { document, error in
                    if let error = error as NSError? {
                        print("Error getting document: \(error.localizedDescription)")
                    } else {
                        if let document = document {
                            let peopleMap = document.data()
                            completion(peopleMap?["displayName"] as? String ?? "")
                        }
                    }
                }
            }
        }
    }
}
