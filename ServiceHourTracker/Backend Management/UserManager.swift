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

class UserData: ObservableObject {
    @Published var currentUser: User
    
    init(user: User) {
        self.currentUser = user
    }
}

struct User: Codable {
    
    let uid: String
    let email: String
    var displayName: String? = "New Student"
    var classes: [String]? = [] //a list of user owned/created classes
    var hours: Float? = 0
    var codes: [String]? = [] // a list of classes participating in
    var classHours: [String:Int]? = [:]
    var userColors: [String]? = ["74C69D", "2D6A4F"]
    var latestRequestsCount: Int? = 0
    init(uid: String, email: String, displayName: String? = nil, classes: [String]? = [], hours: Float? = 0, codes: [String]? = [""], classHours: [String:Int]? = [:], userColors: [String] = [], latestRequestsCount: Int? = 0) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.classes = classes
        self.hours = hours
        self.codes = codes
        self.classHours = classHours
        self.userColors = userColors
        self.latestRequestsCount = latestRequestsCount
    }
    
    init() {
        self.uid = ""
        self.email = "notloggedin@gmail.com"
    }
    
    func getGuts() -> String {
        return  "email : \(email) \n uid: \(uid) \n displayName : \(String(describing: displayName)) \n classes : \(String(describing: classes)) \n hours : \(String(describing: hours)) \n"
    }
}





func storeUserCodeInFirestore(uid: String, codes: [String]) {
    

   
    
    getData(uid: uid) { user in
        db.collection("userInfo").document(uid).updateData(["classes": codes])
    }
   
    

        
    
}

func getClasses(uid: String, completion: @escaping ([String]?) -> Void) {

    
    db.collection("userInfo").document(uid).getDocument { doc, error in
        
        if let error = error {
            print("Error getting user data: \(error)")
                completion(nil)
            return
        }else{
            
            if let document = doc, document.exists {
//                print(document.data())
                if let output = document["classes"] as? [String] {
                    completion(output)
                } else {
                    
                    completion(nil)
                }
            } else {
                print("User data document does not exist")
                completion(nil)
            }
            
        }
    }
}


func storeUserInfoInFirestore(user: User) {

    do {
        try db.collection("userInfo").document(user.email).setData(from: user)
        
        
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
        }else{
            
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
func unenrollClass(uid: String, code: String) {
    
    getData(uid: uid) { currUser in
        let userRef = db.collection("userInfo").document(uid)
        
        if let currUser = currUser{
            
            if var userCodes = currUser.codes{
                let index = userCodes.firstIndex(of: code)
                if let index = index{
                    userCodes.remove(at: index)
                    userRef.updateData(["codes": userCodes]){ error in
                        if let error = error{
                            print(error.localizedDescription)
                        }else{
                            
                        }
                        
                    }
                }else{
                    print("code does not exist")
                }
                
            }else{
                print("no codes found")
            }
            
        }else{
            print("no user found")
        }
        
    }
    
}

func leaveAsManager(uid: String, code: String) {
    getData(uid: uid) { currUser in
        let userRef = db.collection("userInfo").document(uid)
        
        if let currUser = currUser {
            
            if var userClasses = currUser.classes {
                let index = userClasses.firstIndex(of: code)
                if let index = index {
                    userClasses.remove(at: index)
                    userRef.updateData(["classes": userClasses]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            
                        }
                    }
                } else {
                    print("code does not exist")
                }
            } else {
                print("no codes found")
            }
        } else {
            print("no user found")
        }
    }
}

//append a class Code
func updateCodes(uid: String, newCode: String) {
    getData(uid: uid) { currUser in
        let userRef = db.collection("userInfo").document(uid)
        if var userCodes = currUser?.codes {
            if !(userCodes.contains(newCode)) {
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



func getAuthIDForEmail(email: String, completion: @escaping (String) -> Void) {
    
    var output = ""
    db.collection("userInfo").document(email).getDocument { docSnap, error in
        if let error = error {
            print(error.localizedDescription)
            completion("")
        } else if let doc = docSnap, let dat = doc.data() {
            output = dat["uid"] as? String ?? ""
            completion(output)
        }
    }
    
}


//returns the dictionary of classType:Hour pair
func getClassHours(email: String, type: String, completion: @escaping ([String:Int]?) -> Void) {
    
    let docRef = db.collection("userInfo").document(email)
    
    docRef.getDocument { doc, error in
        if let error = error{
            print("error fetching class hours")
        }else{
            if let document = doc {
                let map = document.data()
                let hours = map?["classHours"] as? [String:Int] ?? [:]
                completion(hours)
            }
            
        }
    }
    
}

func getClassHoursField(email: String, completion: @escaping ([[String:String]]?) -> Void) {
    let docRef = db.collection("userInfo").document(email)
    
    docRef.getDocument { document, error in
        if let error = error {
            print("Error fetching class hours: \(error)")
//            completion(nil)
        } else {
            if let document = document, document.exists {
                if let classHoursData = document.data()?["classHours"] as? [String: Int] {
                    let classHours = classHoursData.map { (className, hours) in
                        return ["className": className, "hours": "\(hours)"]
                    }
                    completion(classHours)
                } else {
                    print("No class hours data found.")
//                    completion(nil)
                }
            } else {
                
//                completion(nil)
            }
        }
    }
}




//sets/updates the dict of classType:hour pair by changing value of hour for the type field
func setClassHours(email:String, type: String, hours: Int){
    let docRef = db.collection("userInfo").document(email)
    
    docRef.updateData(["classHours" : [type:hours]])
}


func setUserColors(email: String, colors: [Color]) {
    var colorStrings: [String] = []
    for color in colors {
        colorStrings.append(colorToHex(color: color))
    }
    db.collection("userInfo").document(email).updateData(["userColors":colorStrings])
}

func getUserColors(email: String, completion: @escaping ([Color]) -> Void) {
    let docRef = db.collection("userInfo").document(email)

    docRef.getDocument { document, error in
        if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
            completion([])
        } else {
            if let document = document {
                let colorsStringList = document.data()?["userColors"] as? [String] ?? [""]
                var colors: [Color] = []
                for colorStr in colorsStringList {
                    colors.append(hexToColor(hex: colorStr))
                }
                completion(colors)
            }else{
                completion([])
            }
        }
    }
}
func getName(email: String, completion: @escaping (String)-> Void ){
var output = ""
db.collection("userInfo").document(email).getDocument { docSnap, error in
    if let error = error{
        print(error.localizedDescription)
        completion("")
    }else if let doc = docSnap, let dat = doc.data() {
        let output = dat["displayName"] as? String ?? ""
        completion(output)
    }else{
        completion("")
    }
}

}

//input an email String
// if the email exists in our database it will return true, otherwise false
func doesEmailExistInDB(email: String, completion: @escaping (Bool)-> Void){
    
    db.collection("userInfo").whereField("email", isEqualTo: email).getDocuments { query, error in
        if let error = error{
            print(error.localizedDescription)
            completion(false)
        }else{
            if let query = query {
                print(email)
                completion(!query.documents.isEmpty)
            }
        }
    }
    
}


func updateLatestRequestsCount(userID: String){
    
    getUserRequests(email: userID) { requests in
        
        let dbRef = db.collection("userInfo").document(userID)
        
        dbRef.updateData(["latestRequestsCount": requests.count]) { error in
        if let error = error{
            print("error manipulating latestRequestsCount in db \(error)")
            }
        }

    }
}

func getLatestRequestsCount(uid: String, completion: @escaping (Int)-> Void){
    
    
    

        
    db.collection("userInfo").document(uid).getDocument { doc, error in
        
        if let error = error {
            print("Error getting user data: \(error)")
                
            return
        }else{
            
            if let document = doc, document.exists {
//                print(document.data())
                if let output = document["latestRequestsCount"] as? Int {
                    completion(output)
                } else {
                    return
                    
                }
            } else {
                print("User data document does not exist")
                return
            }
            
        }
    }
    
    
    
}
