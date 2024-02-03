//
//  UserManager.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/19/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserData: ObservableObject{
    @Published var currentUser: User
    
    init(user: User) {
        self.currentUser = user
    }
}

struct User: Codable {
    
    let uid: String
    let email: String
    var displayName: String? = "New Student"
    var classes: [String]? = ["6a9A01"]
    var hours: Float? = 0
    var codes: [String]? = [""]
    
    init(uid: String, email: String, displayName: String? = nil, classes: [String]? = ["6a9A01"], hours: Float? = 0, codes: [String]? = [""]) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.classes = classes
        self.hours = hours
        self.codes = codes
    }
    
    init() {
        self.uid = ""
        self.email = "notloggedin@gmail.com"
    }
    
    func getGuts()->String{
        return  "email : \(email) \n uid: \(uid) \n displayName : \(String(describing: displayName)) \n classes : \(String(describing: classes)) \n hours : \(String(describing: hours)) \n"
    }
}



//let db = Firestore.firestore()
func storeUserCodeInFirestore(uid: String, codes: [String]) {
    

   
    print("before")
    getData(uid: uid) { user in
        db.collection("userInfo").document(uid).updateData(["classes": codes])
    }
   
    print("after")
//        db.collection("userInfo").document(uid).setValue(codes, forKey: "classes")
        
    
}

func getClasses(uid: String, completion: @escaping ([String]?) -> Void) {
//    let db = Firestore.firestore()
    print("in")
    db.collection("userInfo").document(uid).getDocument { doc, error in
        do{
            if let error = error {
                print("Error getting user data: \(error)")
                completion(nil)
                return
            }
            
            if let document = doc, document.exists {
                print(document.data())
                if let output = document["classes"] as? [String] {
                    completion(output)
                } else {
                    print("Classes key not found or is not of type [String]")
                    completion(nil)
                }
            } else {
                print("User data document does not exist")
                completion(nil)
            }

        }catch let error as NSError {
            print("Error getting class: \(error.localizedDescription)")
        }
    }
}

//func getCodes(uid: String, completion: @escaping ([String]?) -> Void) {
////    let db = Firestore.firestore()
//    print("fetching codes")
//    print(uid)
//    db.collection("userInfo").document(uid).getDocument { doc, error in
//        do{
//            print("in")
//            print(doc?.description)
//            if let error = error {
//                print("Error getting user codes: \(error)")
//                completion(nil)
//                return
//            }
//            
//            if let document = doc, document.exists {
//                print(document.data())
//                if let output = document["codes"] as? [String] {
//                    completion(output)
//                } else {
//                    print("Classes key not found or is not of type [String]")
//                    completion(nil)
//                }
//            } else {
//                print("User data document does not exist")
//                completion(nil)
//            }
//
//        }catch let error as NSError {
//            print("Error getting class: \(error.localizedDescription)")
//        }
//    }
//}

func storeUserInfoInFirestore(user: User) {
//    let db = Firestore.firestore()
    do {
        try db.collection("userInfo").document(user.uid).setData(from: user)
        
        
    } catch {
        print("error storing user info")
    }
}

func getCodes(uid: String, completion: @escaping ([String]?) -> Void) {
    
    let docRef = db.collection("userInfo").document(uid)

      docRef.getDocument { document, error in
        if let error = error as NSError? {
          print("Error getting document: \(error.localizedDescription)")
        }
        else {
          if let document = document {
              let map = document.data()
              let codes = map?["codes"] as? [String] ?? [""]
              completion(codes)
          }
        }
      }
    
    
    
}



func getData(uid: String, completion: @escaping (User?) -> Void) {
//    let db = Firestore.firestore()
    db.collection("userInfo").document(uid).getDocument { doc, error in
        if let error = error {
            print("Error getting user data: \(error)")
            completion(nil)
            return
        }

        if let document = doc, document.exists {
            do {
                let output = try document.data(as: User.self)
                completion(output)
            } catch {
                print("Error decoding user data: \(error)")
                completion(nil)
            }
        } else {
            print("User data document does not exist")
            completion(nil)
        }
    }
}

func updateDisplayName(uid: String, newDisplayName: String) {
//    let db = Firestore.firestore()

    
    let userRef = db.collection("userInfo").document(uid)

    userRef.updateData(["displayName": newDisplayName]) { error in
        if let error = error{
            print("error manipulating document variable \(error)")
        }
    }
}

func updateHours(uid: String, newHourCount: Float) {

    getData(uid: uid) { currUser in
        let userRef = db.collection("userInfo").document(uid)
//["hours": (currUser?.hours ?? 0) + newHourCount] to add the hours
        userRef.updateData(["hours": newHourCount]) { error in
                if let error = error{
                    print("error manipulating document variable \(error)")
                }
            }
        }

    
}

func updateCodes(uid: String, newCode: String) {

    getData(uid: uid) { currUser in
        let userRef = db.collection("userInfo").document(uid)
        //["hours": (currUser?.hours ?? 0) + newHourCount] to add the hours
        if var userCodes = currUser?.codes{
            if !(userCodes.contains(newCode)){
                userCodes.append(newCode)
                userRef.updateData(["codes": userCodes]) { error in
                if let error = error{
                    print("error manipulating document variable \(error)")
                }
            }
        }
            
        }
        
        }

    
}

func sendPasswordResetEmail(email: String) -> String {
    var alertMessage = ""
    Auth.auth().sendPasswordReset(withEmail: email) { error in
        if let error = error {
            
           alertMessage =  "Error: \(error.localizedDescription)"
        } else {
            
           alertMessage =  "Password reset email sent. Check your email inbox."
        }
    }
    return alertMessage
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
