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
    @AppStorage("uid") var userID: String = ""
 
    var body: some View {
        NavigationStack{
//            Rectangle()
//                .foregroundColor(Color("green-8"))
//                .frame(width: 400, height: 50)
            
            Form{
                
                Section{
                    HStack{
                        
                        
                        
                        VStack{
                            Text("\(name)").font(.title)
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
                    Text("")
                }
                Section{
                    ForEach(0..<testData.count){num in
                        Text("\(testData[num])")
                    }
                }
            }
            Rectangle()
                .foregroundColor(Color("green-8"))
                .frame(width: 400, height: 20)
            NavigationLink(destination: LoginView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToSign){}
            NavigationLink(destination: AuthView().ignoresSafeArea().navigationBarBackButtonHidden(true), isActive: $navToOrigin){}

                .navigationTitle("Settings")
        }
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
    SettingsView()
}
