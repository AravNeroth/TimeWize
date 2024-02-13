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
    @State private var isDarkMode = false
    @AppStorage("authuid") private var authID = ""
    @State private var newPfp = UIImage(systemName: "person")
    @State private var changePfp = false
    var body: some View {
        NavigationStack{
//            Rectangle()
//                .foregroundColor(Color("green-8"))
//                .frame(width: 400, height: 50)
            
            Form{
                
                Section{
                    HStack{
                        
                        VStack{
                            
                            Text("\(name)").font(.title).padding(.leading).bold()
                            Text("notifications").font(.subheadline).padding(.leading)
                            Spacer()
                        }.padding(.top)
                        
                        Spacer()
                        
                        Image(uiImage: settingsManager.pfp).resizable().aspectRatio(contentMode: .fill).frame(width:50, height:50).clipShape(Circle()).padding()
                            
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
                
                    ForEach(0..<testData.count){num in
                        Text("\(testData[num])")
                    }
                    
                }
            }.onAppear{
                if(userID == ""){
                    getData(uid: "\(userData.currentUser.email)") { currUser in
                        name = currUser!.displayName!
                    }
                }
                getData(uid: userID) { currUser in

                    if let currentUser = currUser{
                        name = currentUser.displayName ?? "Name"
                    }else{
                        name = userData.currentUser.displayName!
                    }
                    
                }
                
                
                
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
            
            
            
            
            
            
            
            
            NavigationLink(destination: LoginView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToSign){}
            NavigationLink(destination: AuthView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToOrigin){}
            NavigationLink(destination: ManagerMode().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToManager){}

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
//                .frame(maxHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea(edges: .bottom)

        }
        .onChange(of: newPfp, { oldValue, newValue in
            if let newPfp = newPfp{
                settingsManager.pfp = newPfp
               
                uploadImageToUserStorage(id: "\(authID)", image: newPfp, file: "Pfp\(authID)")
                
            }
            
        })
        
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
}



