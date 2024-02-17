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
    @State var refreshed = true
    @AppStorage("authuid") private var authID = ""
    var body: some View {
        VStack{
            ScrollView{
                Text("managerMode")
                ForEach(settingsMan.classes, id: \.self) { value in
                    ClassTabView(name: "testClass ", classCode: "\(value)", refreshed: $refreshed)
                    
                }
                
            }.padding(.top, 100)
            
            // button creates classes
            Button{
                withAnimation{
                    classCreationAlert = true
                    
                }
                
                
            }label: {
                Image(systemName: "plus")
            }.padding()
            
            ///
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
                    
                    let newClass = Classroom(code: "\(createClassCode())", title: "\(className)", owner: authID)
                    
                    storeClassInfoInFirestore(org: newClass)
                    
                    uploadImageToClassroomStorage(code: "\(newClass.code)",
                                                  image: settingsMan.pfp,
                                                  file: "Pfp\(newClass.code)"
                    )
                    
                    settingsMan.classes.append(newClass.code)
                    
                    storeUserCodeInFirestore(uid: userID,
                                             codes: settingsMan.classes
                    )
                    
                    
                    
                }
            
            
            
        }
    }
}


#Preview {
    ManagerMode()
}
