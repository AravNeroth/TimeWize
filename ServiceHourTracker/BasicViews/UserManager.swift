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

func storeUserInfoInFirestore(user: User) {
//    let db = Firestore.firestore()
    do {
        try db.collection("userInfo").document(user.uid).setData(from: user)
        
        
    } catch {
        print("error storing user info")
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

