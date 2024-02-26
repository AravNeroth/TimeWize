//
//  ManagerMode.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/22/24.
//

import SwiftUI
import FirebaseFirestore
struct ManagerClassesView: View {
    
    @State var className: String = ""
    @State var managerCodeAlert = false
    @State var managerCodeField: String = ""
    @State var managerCode: String = ""
    @State var joinCode = ""
    @State var alertMessage = ""
    @State var minServiceHours: Int = 0
    @State var minClassSpecificHours: Int = 0
    @State var classCreationAlert = false
    @State var classNameField: String = ""
    @State var classServiceField: String = ""
    @State var classSpecificField: String = ""
    @ObservedObject private var settingsMan = SettingsManager.shared
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @AppStorage("uid") var userID: String = ""
    @State var refreshed = false
    @AppStorage("authuid") private var authID = ""
    
    var body: some View {
        if refreshed == false {
            LoadingScreen()
                .animation(.easeInOut, value: refreshed)
                .onAppear() {
                    getClasses(uid: userID) { list in
                        settingsMan.classes = list ?? [] // list of codes
                    }
                    
                    for code in settingsMan.classes {
                        getClassInfo(classCloudCode: code) { classroom in
                            if let classroom = classroom {
                                if !settingsMan.managerClassObjects.contains(classroom) {
                                    
                                    settingsMan.managerClassObjects.append(classroom)
                                    
                                    downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg") { image in
                                        classInfoManager.managerClassImages[classroom.title] = image
                                    }
                                    
                                    downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                                        if let image = image {
                                            print("found \(code)")
                                            classInfoManager.managerClassPfp[classroom.title] = image
                                        } else {
                                            print("no pfp for class with code \(code) and name \(classroom.title)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    settingsMan.managerClassObjects.sort{ $0.title < $1.title }
                    refreshed = true
                }
        } else {
            VStack {
                ScrollView {
                    ForEach(settingsMan.managerClassObjects, id: \.self) { classroom in
                        ManagerTabView(name: classroom.title, classCode: classroom.code, banner: classInfoManager.managerClassImages[classroom.title], pfp: classInfoManager.managerClassPfp[classroom.title])
                            .padding(.bottom, 10)
                            .animation(.spring(duration: 1), value: refreshed)
                    }
                }
                .alert("Create A Class", isPresented: $classCreationAlert) {
                    TextField("Enter Name", text: $classNameField)
                    TextField("Minimum Service Hours", text: $classServiceField)
                    TextField("Minimum Specific Hours", text: $classSpecificField)
                    Button("OK") {
                        className = classNameField
                        minServiceHours = Int(classServiceField) ?? 0
                        minClassSpecificHours = Int(classSpecificField) ?? 0
                        classNameField = ""
                        classServiceField = ""
                        classSpecificField = ""
                    }
                    Button("Cancel") {}
                }
                .alert("Enter Manager Code", isPresented: $managerCodeAlert) {
                    TextField("Enter Code", text: $managerCodeField)
                    Button("OK") {
                        managerCode = managerCodeField
                    }
                    Button("Cancel") {}
                }
                .onChange(of: className) { oldValue, newValue in
                    
                    let newClass = Classroom(code: "\(createClassCode())", managerCode: "\(createManagerCode())", title: "\(className)", owner: authID, peopleList: [], managerList: [userID], minServiceHours: minServiceHours, minSpecificHours: minClassSpecificHours)
                    
                    storeClassInfoInFirestore(org: newClass)
                    uploadImageToClassroomStorage(code: "\(newClass.code)", image: settingsMan.pfp, file: "Pfp\(newClass.code)")
                    
                    settingsMan.classes.append(newClass.code)
                    storeUserCodeInFirestore(uid: userID, codes: settingsMan.classes)
                    
                    refreshed = false
                }
                .alert("Join Class", isPresented: $managerCodeAlert) {
                    TextField("Enter Manager Code", text: $joinCode)
                    Button("Ok") {
                        checkIfManagerCodeExists(manCode: joinCode) { exists in
                            if exists {
                                fetchClassDetailsForManagerCode(manCode: joinCode)
                                joinCode = ""
                            } else {
                                alertMessage = "Code does not exist"
                                joinCode = ""
                                managerCodeAlert = false
                                managerCodeAlert = true
                            }
                        }
                    }
                    Button("Cancel") {}
                } message: {
                    Text(alertMessage)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            alertMessage = "Manager Code"
                            managerCodeAlert = true
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                        }
                        .padding(2)
                        Button {
                            withAnimation{
                                classCreationAlert = true
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private func fetchClassDetailsForManagerCode(manCode: String) {
           let db = Firestore.firestore()
           db.collection("classes").whereField("managerCode", isEqualTo: manCode).getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching class details: \(error)")
               } else {
                   for document in snapshot!.documents {
                       let classData = document.data()
                       if let className = classData["title"] as? String,
                          let classCode = classData["code"] as? String,
                          var managerList = classData["managerList"] as? [String],
                          let minSpecificHours = classData["minSpecificHours"] as? Int,
                          let minServiceHours = classData["minServiceHours"] as? Int,
                          let peopleList = classData["peopleList"] as? [String],
                          let owner = classData["owner"] as? String {
                           managerList.append(userID)
                           let classroom = Classroom(code: classCode, managerCode: manCode, title: className, owner: owner, peopleList: peopleList, managerList: managerList, minServiceHours: minServiceHours, minSpecificHours: minSpecificHours)
                           settingsMan.classes.append(classroom.code)
                           storeUserCodeInFirestore(uid: userID, codes: settingsMan.classes)
                          }
                   }
               }
           }
       }

       
       private func checkIfManagerCodeExists(manCode: String, completion: @escaping (Bool) -> Void) {
           let db = Firestore.firestore()
           db.collection("classes").whereField("managerCode", isEqualTo: manCode).getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching documents: \(error)")
                   completion(false)
               } else {
                   if let documents = snapshot?.documents, !documents.isEmpty {
                       // Manager code exists
                       completion(true)
                   } else {
                       // Manager code does not exist
                       completion(false)
                   }
               }
           }
       }

       
       private func loadManagerClassInfo(managerCodes: [String], completion: @escaping (Bool) -> Void) {
           for managerCode in managerCodes {
               getClassInfo(classCloudCode: managerCode) { classroom in
                   if let classroom = classroom {
                       if !settingsMan.managerClassObjects.contains(classroom) {
                           settingsMan.managerClassObjects.append(classroom)
                           downloadImageFromClassroomStorage(code: classroom.code, file: "\(classroom.title).jpg") { image in
                               classInfoManager.managerClassImages[classroom.title] = image
                           }
                           downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                               if let image = image {
                                   classInfoManager.managerClassPfp[classroom.title] = image
                               }
                           }
                       }
                   }
                   settingsMan.managerClassObjects.sort { $0.title < $1.title }
               }
           }
           completion(true)
       }

}


#Preview {
    ManagerClassesView()
}

