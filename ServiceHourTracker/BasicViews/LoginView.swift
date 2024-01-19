
//  ContentView.swift
//  QuickWorksMVP
//
//  Created by Verlyn Fischer on 9/28/23.
//  worked on by Jonathan Kalsky 10/04/23

import SwiftUI
import FirebaseAuth
struct LoginView: View {
    public var LoginCode: [String] = []
    @State private var userName = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var errorPass:Double = 0.0 //change to 0.5 if wrong
    @State private var errorLogin:Double = 0.0 //change to 0.5 if wrong
    @State private var login = false
    @State private var SignUp = false
    private let segments = ["Login", "Sign Up"]
    @State private var selectedIndex = 0
    @State private var blueButtonText = "Login"
    @AppStorage("uid") var userID: String = ""
        
    var body: some View {
        
        
        ZStack(alignment: .bottomLeading){
            NavigationStack{
                
//                Rectangle()
//                    .foregroundColor(Color("green-8"))
//                    .frame(width: 400, height: 50)
                
                Image(systemName: "clock.circle").resizable().scaledToFit().frame(width: 50,height: 50).padding(.init(top: 50, leading: 10, bottom: 10, trailing: 10)).foregroundColor(.green)
                
                
                Text("Welcome to TimeWize").font(.title).bold().padding().padding(EdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 0))
                
                VStack(alignment: .leading){
                    
                    Text("Email").font(.caption).opacity(0.5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: CGFloat(errorPass))
                            .frame(width: 300, height: 50)
                        
                        
                        TextField("Email", text: $userName).padding().frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                    }
                    
                    Text("Password").font(.caption).opacity(0.5)
                    
                    //
                    
                    ZStack(alignment: .trailing){
                        //HStack{
                        Group {
                            if isSecure {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: CGFloat(errorPass))
                                        .frame(width: 300, height: 50)
                                    
                                    SecureField("Password", text: $password).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: CGFloat(errorPass))
                                        .frame(width: 300, height: 50)
                                    
                                    TextField("Password", text: $password).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                                }
                            }
                        }
                        
                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: self.isSecure ? "eye.slash" : "eye")
                                .accentColor(.gray)
                            
                        }.padding()
                    }
                    //}
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                
                
                Text("\(blueButtonText)").frame(width: 300 ,height: 50).background(Color(UIColor(resource: .blueLogin))).foregroundColor(.white).cornerRadius(3.0).onTapGesture {
                    
                    if blueButtonText == "Login"{
//                        authenticateLogin(Username: userName, password: password)
                        print("authenticating loggin")
                        
                        Auth.auth().signIn(withEmail: userName, password: password) {authResult, error in
                            if let error = error{
                                print(error)
                                return
                            }
                            if let authResult = authResult{
                                print(authResult.user.uid)
                                withAnimation {
                                    userID = authResult.user.uid
                                }
                            }
                        }
                        
                    }else{
                        SignUp = true
                        
                    }
                    
                    
                    
                    
                    
                }
                NavigationLink(destination: ServiceHourTracker.SignUp(passedPassword: password), isActive: $SignUp){}
                
                NavigationLink(destination: StudentView().navigationBarBackButtonHidden(true), isActive: $login){
                }.padding(5)
                
                Picker(selection: $selectedIndex, label: Text("Segments")) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index]).tag(index)
                       
                    }
                }.frame(width:200)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            
                
               
               
//                    NavigationLink("Sign up",destination: SignUpView()).padding(5)
                Spacer()
                
                Button{
                    
                }label: {
                    Text("Forgot password?")
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                Button{
                    
                }label: {
                    Text("Privacy")
                }.padding(EdgeInsets(top: 5, leading: 20, bottom: 15, trailing: 0))
                
//                Rectangle()
//                    .foregroundColor(Color("green-8"))
//                    .frame(width: 400, height: 50)
            }
            
           .onChange(of: selectedIndex){
                blueButtonText = segments[selectedIndex]
                if segments[selectedIndex] == "Sign Up"{
                    withAnimation {
                        SignUp = true
                    }
                    selectedIndex = 0
                    
                }
            }
        }
        
    }
        
    
    func authenticateLogin(Username: String, password: String){
        //check with database if it is equal to the password and login
        
        if userName == "cedarPark"{
            if password == "bestteam"{
                login = true
            }else{
                errorPass = 0.5
                
            }
        }else{
            errorLogin = 0.5
            errorPass = 0.5
            
        }
        
       
    }
}




                
#Preview {
    LoginView()
}
