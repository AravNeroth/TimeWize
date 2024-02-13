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


class ClassData: ObservableObject{
    @Published var code:String
    
    init(code: String) {
        self.code = code
    }
    
}
//used to keep track of what class user is in


struct Classroom: Codable, Hashable, Identifiable{

    let code: String
    let title: String
    let owner: String
    var id: String{
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


func createClassCode() -> String{
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

func isCodeUsedInCollection(code: String, collectionName: String, completion: @escaping (Bool) -> Void) {
    
    let db = Firestore.firestore()
    
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

