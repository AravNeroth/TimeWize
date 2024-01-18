//
//  SettingsView.swift

//
//  Created by kalsky_953982 on 10/3/23.
//

import SwiftUI


struct SettingsView:View {
    @State private var navToSign = false
    @State private var testData = ["General","Resume","Job options","Appearance","stuff","stuff"]
    @State private var name = "Name"

 
    var body: some View {
        NavigationStack{
            Rectangle()
                .foregroundColor(Color("green-8"))
                .frame(width: 400, height: 50)
            
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
                    Text("Your account")
                }
                Section {
                    Text("hello world")
                    Text("brightness settings")
                    
                } header: {
                    Text("First Section")
                }
                
                Section{
                    Button{
                        navToSign = true
    
    
                    }label: {
                        Text("sign up")
                    }
                }header: {
                    Text("login")
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

                .navigationTitle("Settings")
        }
    }
}


#Preview {
    SettingsView()
}
