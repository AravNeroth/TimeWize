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
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @AppStorage("uid") var userID: String = ""
    @State var refreshed = false
    @AppStorage("authuid") private var authID = ""
    
    var body: some View {
        if refreshed == false{
            LoadingScreen()
                .animation(.easeInOut)
                .onAppear(){
                    
                  
                        
                        
                        getClasses(uid: userID) { list in
                            settingsMan.classes = list ?? [] //list of codes
                        }
                        for _ in 0..<1 {
                            for code in settingsMan.classes{
                                
                                getClassInfo(classCloudCode: code) { classroom in
                                    if let classroom = classroom{
                                        if !settingsMan.managerClassObjects.contains(classroom){
                                            
                                            settingsMan.managerClassObjects.append(classroom)
                                            
                                            downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg", completion: { image in
                                                classInfoManager.managerClassImages[classroom.title] = image
                                            })
                                            
                                            downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") {
                                                
                                                image in
                                                if let image = image{
                                                    print("found \(code)")
                                                    classInfoManager.managerClassPfp[classroom.title] = image
                                                }else{
                                                    print("no pfp for class with code \(code) and name \(classroom.title)")
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                           
                                                            
                        }
                    settingsMan.managerClassObjects.sort { $0.title < $1.title }
                    refreshed = true

                    }
                //update the settingsManager classes list
                    
            
        }else{
            VStack{
                ScrollView{
                    
                    ForEach(settingsMan.managerClassObjects, id: \.self) { classroom in
                        
                        ManagerTabVIew(name: classroom.title,
                                       classCode: classroom.code,
                                       loaded: $refreshed,
                                       banner: classInfoManager.managerClassImages[classroom.title],
                                       pfp: classInfoManager.managerClassPfp[classroom.title]
                            
                                       
                        ).padding(.bottom, 10).animation(.spring(duration: 1))
                        
                    }
                    
                }.padding(.top, 100)
                
                // button creates classes
//                Button{
//                    withAnimation{
//                        classCreationAlert = true
//                        
//                    }
//                    
//                    
//                }label: {
//                    Image(systemName: "plus")
//                }.padding()
                
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
                
                
            }.toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        withAnimation{
                            classCreationAlert = true
                            
                        }
                        
                        
                    }label: {
                        Image(systemName: "plus")
                    }.padding()
                }
            }
        }
    }
}


#Preview {
    ManagerMode()
}
