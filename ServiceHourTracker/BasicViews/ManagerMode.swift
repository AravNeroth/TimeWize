//
//  ManagerMode.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/22/24.
//

import SwiftUI
import FirebaseFirestore
struct ManagerMode: View {
    
    @State var className: String = ""
    @State var classCreationAlert = false
    @State var alertField: String = ""
    @ObservedObject private var settingsMan = SettingsManager.shared
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
  
        ScrollView{
            ForEach(0..<settingsMan.classes.count, id: \.self) { index in
                ClassTabView(name: "testClass ", mainManager: "\(settingsMan.classes[index])")
                
            }
            
        }.padding(.top, 100)
            
        Button{
            withAnimation{
                classCreationAlert = true
                
            }
            
            
        }label: {
            Image(systemName: "plus")
        }.padding()
        
        
        .alert("Create a class name", isPresented: $classCreationAlert) {
            TextField("Enter Name", text: $alertField).foregroundColor(.black)
            Button("OK") {
               className = alertField
            }
            Button("Cancel"){
                
            }
        } message: {
            Text("create a name")
        }
        .onAppear(){
            print("hello")
            getClasses(uid: userID) { list in
                settingsMan.classes = list ?? [""]
            }
            
            //update the settingsManager classes list
        }
        .onChange(of: className) { oldValue, newValue in
          
            let newClass = Classroom(code: "\(createClassCode())", title: "\(className)")
            
            storeClassInfoInFirestore(org: newClass)
            
         
            settingsMan.classes.append(newClass.code)
            storeUserCodeInFirestore(uid: userID, codes: settingsMan.classes)
        
            
            
            
           
           
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

#Preview {
    ManagerMode()
}
