//
//  SettingsView.swift

//
//  Created by kalsky_953982 on 10/3/23.
//

import SwiftUI
import FirebaseAuth

struct SettingsView:View {
    @State private var navToSign = false
    @State private var navToOrigin = false
    @State private var testData = ["General","Resume","Job options","Appearance","stuff","stuff"]
    @State private var name = "Name"
    @State private var newName = ""
    @State private var alertField = ""
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var userData: UserData
    @State private var nameAlert = false
    
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var isDarkMode = false
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
                    }
                }header: {
                    Text("Details")
                }
                Section {
                    
                    Text("\(userID)")
                    
                    Text("\(getEmail())")
                    
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
                        name = currentUser.displayName!
                    }else{
                        name = userData.currentUser.displayName!
                    }
                    
                }
                
            }.onChange(of: newName) { oldValue, newValue in
                updateDisplayName(uid: userID, newDisplayName: newName)
                getData(uid: userID) { currUser in
                    if let currentUser = currUser{
                        name = currentUser.displayName!
                    }else{
                        name = userData.currentUser.displayName!
                    }
                }
            }
            
            
            
            
            
            
            
            
            NavigationLink(destination: LoginView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToSign){}
            NavigationLink(destination: AuthView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToOrigin){}

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


        
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
}
func getEmail() -> String{
    var out = ""
    if let email = Auth.auth().currentUser?.email{
        out = email
    }else{
       out = "not signed in"
    }
    return out
}

#Preview {
    SettingsView().environmentObject(UserData(user: User(uid: "sampleUID", email: "sample.email@gmail.com", displayName: "Guest")))
}


