//
//  SettingsView.swift

//
//  Created by kalsky_953982 on 10/3/23.
//

import SwiftUI
import FirebaseAuth

struct SettingsView:View {
    @State private var navToSign = false
    @State private var navToManager = false
    @State private var navToManagerViews = false

    @State private var navToReqList = false
    @State private var navToOrigin = false
    @State private var testData = ["General","Resume","Job options","Appearance","stuff","stuff"]
  
    @AppStorage("name") private var name = "Name"
    @State private var newName = ""
    @State private var alertField = ""
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var userData: UserData
    @State private var nameAlert = false
    @AppStorage("hours") var hoursEarned = 0
    @EnvironmentObject var settingsManager: SettingsManager
    @State var updated = false

    @AppStorage("authuid") private var authID = ""
    @State private var newPfp = UIImage(systemName: "person")
    @State private var changePfp = false
    @State private var managerIndex = 0
    var body: some View {
        NavigationStack{

            
            Form{
                
                Section{
                    HStack{
                        
                    
                            
                        Text("\(name)").font(.title).padding(.leading).bold()
                        Button{
                            
                        }label:{
                            Image(systemName: "bell.fill")
                        }.padding(.leading,2)
            
                    
                        
                        Spacer()
                        
                        Image(uiImage: settingsManager.pfp).resizable().aspectRatio(contentMode: .fill).frame(width:50, height:50).clipShape(Circle())
                            
                        Button{
                            changePfp = true
                        }label: {
                            Image(systemName: "pencil").frame(width: 50, height: 50)
                        }
                    }
                }header: {
                    Text("Details")
                }
                Section {
                    
                    Text("User: \(userID)")
                    
                    Text("Auth ID: \(authID)")
                    
                } header: {
                    Text("Account Information")
                }
                
                Section{
//                    TextField("Change Name", text: $newName)
                    
                    
                    Button{
                        nameAlert = true
                    }label: {
                        Text("Change Name")
                    }
                }header: {
                    Text("Name")
                }
                
                
                Section{
                    Button{
                        let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                            withAnimation {
                                userID = ""
                            }
                        } catch let signOutError as NSError {
                          print("Error signing out: %@", signOutError)
                        }
//                        navToSign = true
                        navToOrigin = true
    
    
                    }label: {
                        Text("sign out")
                    }
                    
                    
                }header: {
                    Text("Account Login")
                }
                Section{
                    
                    
                    Toggle(isOn: $settingsManager.isDarkModeEnabled, label: {
                        Text("Dark Mode")
                    })
                    
                    Picker(selection: $managerIndex, label: Text("Account mode")) {
                        
                        Text("Student").tag(0)
                        Text("Manager").tag(1)
                           
                        
                    }.frame(width:300)
                    .pickerStyle(SegmentedPickerStyle())
                    
//                    Text("manager mode: \(settingsManager.isManagerMode)")
                    Button{
                        navToManager = true
                    }label: {
                        Text("Manager Mode")
                    }
                    
                    // button takes you to 'manager' preview - FOR TESTING
                    Button{
                        navToManagerViews = true
                    }label: {
                        Text("Manager View Mode")
                    }
                    
                    Button{
                        updateHours(uid: userID, newHourCount: Float(hoursEarned))
                        updateDisplayName(uid: userID, newDisplayName: name)
                        updated = true
                        countDown(time: 5.0, variable: $updated)
                    }label: {
                        HStack{
                            Text("Update User Info")
                            Spacer()

                                if updated{
                                    Image(systemName: "person.fill.checkmark").foregroundStyle(.green5).padding().animation(.bouncy(duration: 1.0))
                                }
                                

                        }
                    }
                    
                    Stepper("Max Hours", value: $settingsManager.perfHourRange, in: 0...100, step: 2)
                /*
                    Button{
                        setClassHours(email: userID, type: "Math", hours: 2)
                    }label:{
                        Text("testing DB")
                    }
                    Button{
                        getClassHours(email: userID, type: "Math") { dict in
                            if let dict = dict{
                                print(dict.first as Any )
                                print(dict["Math"]!)
                            }
                        }
                    }label:{
                        Text("testing DB 2")
                    }
                    
                    Button{
                        addRequest(classCode: "6i092y", email: "jonathan.cs@gmail.com", hours: 2, type: "Math", description: "UIL Math")
                    }label:{
                        Text("testing DB 3")
                    }
                    
                    Button{
                        addRequest(classCode: "6694rI", email: "jonathan.cs@gmail.com", hours: 3, type: "Math", description: "UIL Math")
                    }label:{
                        Text("testing DB 4")
                    }
                    Button{
                       getRequest(classCode: "6694rI") { arrayOfMap in
                           if !arrayOfMap.isEmpty{
                               print("\n")
                               print(arrayOfMap)
                               print(arrayOfMap.first!["email"])
                               print("\n")
                           }
                       }
                   } label: {
                       Text("testing DB 5")
                   }
                    
                    Button{
                        addTask(classCode: "6i092y", title: "presentations", date: Date(), maxSize: 5)
                        addTask(classCode: "6i092y", title: "test", date: Date(), maxSize: 5)
                        addTask(classCode: "6i092y", title: "test2", date: Date(), maxSize: 6)
                        print("hit button 6")
                   } label: {
                       Text("testing DB 6")
                   }
                    
                    Button{
                        getTasks(classCode: "6i092y") { tasks in
                           if !tasks.isEmpty {
                               print("\n")
                               print(tasks)
                               print(tasks.first!["people"])
                               print("\n")
                           }
                       }
                   } label: {
                       Text("testing DB 7")
                   }
                    
                    Button{
                        updateTaskParticipants(classCode: "6i092y", title: "presentations", listOfPeople: ["jonathan.cs@gmail.com","parker.cs@gmail.com"])
                        updateTaskParticipants(classCode: "6i092y", title: "test", listOfPeople: ["jonathan.cs@gmail.com"])
                        updateTaskParticipants(classCode: "6i092y", title: "test2", listOfPeople: ["parker.huang10@k12.leanderisd.org", "jonathan.cs@gmail.com","parker.cs@gmail.com"])
                   }label:{
                       Text("testing DB 8")
                   }
                    Button{
                        getTaskParticipants(classCode: "6i092y", title: "presentations") { peopleList in
                            print(peopleList)
                        }
                   }label:{
                       Text("testing DB 9")
                   }
                    
                    Button{
                        addRequest(classCode: "56PG88", email: userID, hours: 7, type: "Robotics", description: "Brian the Robot")
                    }label:{
                        Text("hourhunter robotics")
                    }
                    
                    Button{
                        addRequest(classCode: "41K78c", email: userID, hours: 4, type: "Yearbook", description: "Quill & Scroll")
                    }label:{
                        Text("hourhunter yearbook")
                    }
                    
                    Menu{
                        NavigationLink(destination: JoinCodesView() ) {
                            Text("ClassJoining")
                        }
                        NavigationLink(destination: ManagerView() ) {
                            Text("Class View")
                        }
                        NavigationLink(destination: ManagerCreateClassView() ) {
                            Text("create class")
                        }
                        NavigationLink(destination: ManagerSettingsView() ) {
                            Text("settings")
                            //needs to use same settings
                        }
                        NavigationLink(destination: ManagerClass() ) {
                            Text("test class")
                        }
                    }label:{
                        Text("Manager Views")
                    }
                    */
                    //random sections
                    ForEach(0..<testData.count){ num in
                        Text("\(testData[num])")
                    }
                    
                    Button(action: {
//                        setColorScheme(classCode: "5788MR", colors: ["C77DFF", "7B2CBF"])
                        setColorScheme(classCode: "5788MR", colors: [.purple, .white])
                    }) {
                        Text("change color to purple")
                    }
                    
                    
                    
                    Button(action: {
//                        setColorScheme(classCode: "5788MR", colors: ["FFFFFF", "777777"])
                        setColorScheme(classCode: "5788MR", colors: [.white, .gray])
                    }) {
                        Text("change color to white/gray")
                    }
                    
                    NavigationLink(destination: ManagerRoomView()) {
                        Text("new manager room")
                    }
                    
                }header:{
                    Text("Dev controls")
                }
                
            }
        
            .onAppear{
                if(userID == ""){
                    getData(uid: "\(userData.currentUser.email)") { currUser in
                        name = currUser!.displayName!
                    }
                }else{
                    getData(uid: userID) { currUser in
                        
                        if let currentUser = currUser{
                            name = currentUser.displayName ?? "Name"
                        }else{
                            name = userData.currentUser.displayName ?? "Name"
                        }
                        
                    }
                    
                    
                }
                print(settingsManager.isManagerMode)
                managerIndex = settingsManager.isManagerMode ? 1 : 0
            }.onChange(of: updated) { oldValue, newValue in
                if(newName != ""){
                    
                    updateDisplayName(uid: userID, newDisplayName: newName)
                    getData(uid: userID) { currUser in
                        if let currentUser = currUser{
                            name = currentUser.displayName!
                        }else{
                            name = userData.currentUser.displayName!
                        }
                    }
                }
            }
            .onChange(of: managerIndex) { oldV, newV in
                if managerIndex == 0 {
                    settingsManager.isManagerMode = false
                }else{
                    settingsManager.isManagerMode = true
                }
            }
            
            
            
            
            
            
            
            
            NavigationLink(destination: LoginView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToSign){}
            NavigationLink(destination: AuthView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToOrigin){}
            NavigationLink(destination: ManagerClassesView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToManager){}
            NavigationLink(destination: ManagerReqListView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToReqList){}

//                .navigationTitle("Settings")
        }.alert("Enter new name", isPresented: $nameAlert) {
            TextField("new name", text: $alertField).foregroundColor(.black)
            Button("OK") {
                newName = alertField
            }
            Button("Cancel"){
                
            }
        } message: {
            Text("Change your name?")
        }
        .fullScreenCover(isPresented: $changePfp){
            
                ImagePicker(image: $newPfp)
                
            
            
                .ignoresSafeArea(edges: .all)

        }
        .onChange(of: newPfp, { oldValue, newValue in
            if let newPfp = newPfp{
                settingsManager.pfp = newPfp
               
                uploadImageToUserStorage(id: "\(authID)", image: newPfp, file: "Pfp\(authID)")
                
            }
            
        })
        

    }
    
}



