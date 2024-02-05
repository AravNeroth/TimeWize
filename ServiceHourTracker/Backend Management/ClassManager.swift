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


struct Classroom: Codable, Hashable{
    
    let code: String
    let title: String
    
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

