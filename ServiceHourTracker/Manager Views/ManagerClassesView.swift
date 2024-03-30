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
    @State var allClasses: [Classroom] = []
    @State var ownerPfps: [Classroom:UIImage] = [:]
    @State var classColors: [Classroom:[Color]] = [:]
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @AppStorage("uid") var userID: String = ""
    @State var refresh = false
    @AppStorage("authuid") private var authID = ""
    
    var body: some View {
        if classInfoManager.allManagerClasses.isEmpty || classInfoManager.classColors.count < classInfoManager.allManagerClasses.count || refresh {
            
            LoadingScreen()
                .onAppear() {
                    
                    classInfoManager.updateManagerData(userID: userID){ _ in
                        refresh = false
                        
                    }
                
                }
        } else {
            
                ScrollView {
                    ForEach(classInfoManager.allManagerClasses, id: \.self) { classroom in
                        NewManagerTabView(title: classroom.title, classCode: classroom.code, colors: classInfoManager.classColors[classroom] ?? settingsManager.userColors, ownerPfp: classInfoManager.ownerPfps[classroom], allClasses: $classInfoManager.allManagerClasses, classroom: classroom)
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
                .onChange(of: className) { oldValue, newValue in
                    
                    let newClass = Classroom(code: "\(createClassCode())", managerCode: "\(createManagerCode())", title: "\(className)", owner: authID, peopleList: [], managerList: [userID], minServiceHours: minServiceHours, minSpecificHours: minClassSpecificHours, colors: [])
                    
                    storeClassInfoInFirestore(org: newClass)
                    
                    uploadImageToClassroomStorage(code: "\(newClass.code)", image: settingsManager.pfp, file: "Pfp\(newClass.code)")
                    
                    classInfoManager.classes.append(newClass.code)
                    storeUserCodeInFirestore(uid: userID, codes: classInfoManager.classes)
                    
                    
                  
                }
                .alert("Join Class", isPresented: $managerCodeAlert) {
                    TextField("Enter Manager Code", text: $joinCode)
                    Button("Ok") {
                        checkIfManagerCodeExists(manCode: joinCode) { exists in
                            if exists {
                                fetchClassDetailsForManagerCode(manCode: joinCode)
                                joinCode = ""
                                
                            } else {
                                alertMessage = "Code Does Not Exist"
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
                .refreshable {
                    refresh = true
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
                          let colors = classData["colors"] as? [String],
                          let owner = classData["owner"] as? String {
                           managerList.append(userID)
                           addManagerToClass(person: userID, classCode: classCode)
                           let classroom = Classroom(code: classCode, managerCode: manCode, title: className, owner: owner, peopleList: peopleList, managerList: managerList, minServiceHours: minServiceHours, minSpecificHours: minSpecificHours, colors: colors)
                            classInfoManager.classes.append(classroom.code)
                           storeUserCodeInFirestore(uid: userID, codes: classInfoManager.classes)
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
}

