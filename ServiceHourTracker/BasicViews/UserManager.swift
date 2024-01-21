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
    
}


//
//func isDark(uid: String) -> Bool {
//    
//    //a semaphore is used to wait for the asynchronous Firestore query to complete before returning the isDarkValue. This makes the function synchronous, but as mentioned earlier, using synchronous calls for network operations may lead to freezing the UI and should be used cautiously.
//    let db = Firestore.firestore()
//    var isDarkValue: Bool = false
//
//    let semaphore = DispatchSemaphore(value: 0)
//
//    db.collection("userInfo").document(uid).getDocument { document, error in
//        defer {
//            semaphore.signal()
//        }
//
//        if let error = error {
//            print("Error getting user data: \(error)")
//            return
//        }
//
//        if let document = document, document.exists {
//            do {
//                let user = try document.data(as: User.self)
//                isDarkValue = user.dark
//            } catch {
//                print("Error decoding user data: \(error)")
//            }
//        } else {
//            print("User data document does not exist")
//        }
//    }
//
//    _ = semaphore.wait(timeout: .distantFuture)
//    return isDarkValue
//}


func storeUserInfoInFirestore(user: User) {
    let db = Firestore.firestore()
    do {
        try db.collection("userInfo").document(user.uid).setData(from: user)
    } catch {
        print("error storing user info")
    }
}

func getData(uid: String, completion: @escaping (User?) -> Void) {
    let db = Firestore.firestore()
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
    let db = Firestore.firestore()

    
    let userRef = db.collection("userInfo").document(uid)

    userRef.updateData(["displayName": newDisplayName]) { error in
        if let error = error{
            print("error manipulating document variable \(error)")
        }
    }
}

