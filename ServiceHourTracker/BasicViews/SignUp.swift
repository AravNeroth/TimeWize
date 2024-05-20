//
//  SignUp.swift

//
//  Created by kalsky_953982 on 10/4/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct SignUp: View {
    
    @State private var userName = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var isSecure = true
    @State private var registerView = false
    @State private var noMatch = false
    @State private var agreeToTerms = false
    @State private var goToTerms = false
    @State private var goToPrivacy = false
    @State private var shouldContinue = false
    @State private var showDoNotMatch = false
    @State private var selectedIndex = 0
    @AppStorage("uid") var userID: String = ""
    @State private var alertError = ""
    @State private var showAlert = false
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var darkIndex = 1
    //1
    @AppStorage("authuid") var authUID = ""
    
    init(passedPassword: String){
        self.password = passedPassword
        
    }
    var body: some View {
        
        
        VStack{
            
//            Rectangle()
//                .foregroundColor(Color("green-8"))
//                .frame(width: 400, height: 50)
            
            Image(.sandclock).resizable().scaledToFit().frame(width: 50,height: 50).padding(.init(top: 50, leading: 0, bottom: 50, trailing: 0)).foregroundColor(.blueLogin)
            
            VStack(alignment: .leading){
                
                Text("Email").font(.caption).opacity(0.5)
                
                
                
                
                TextField("example@timeWize               .com", text: $userName).padding().frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    
                        .stroke(lineWidth: (userName.isValidEmail(userName)||(userName == "")) ? 0 : 1)
                        .foregroundColor(.red)
                    )
                
                
                Text("Password").font(.caption).opacity(0.5)
                
                //
                
                ZStack(alignment: .trailing){
                    //HStack{
                    Group {
                        if isSecure {
                            ZStack {
                                
                                SecureField("Password", text: $password).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                            }
                        } else {
                            ZStack {
                                
                                
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
                    
                    
                }.onChange(of: confirm){
                    if confirm != password{
                        noMatch = true
                    }
                }
                
                
                Text("Confirm Password").font(.caption).opacity(0.5)
                ZStack(alignment: .trailing){
                    //HStack{
                    Group {
                        if isSecure {
                            ZStack {
                                
                                SecureField("Confirm Password", text: $confirm).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
                            }
                        } else {
                            ZStack {
                                
                                
                                TextField("Confirm Password", text: $confirm).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).autocorrectionDisabled().textInputAutocapitalization(.never)
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
                
            }
            
            HStack{
                Button{
                    agreeToTerms.toggle()
                    
                }label: {
                    Image(systemName: agreeToTerms ? "checkmark.square" : "square")
                }.foregroundColor(.gray).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                
                Text("I agree to the").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Text("terms and services").foregroundColor(.blue).onTapGesture {
                    goToTerms = true
                }
                
                NavigationLink(destination: TermsAndServices(), isActive: $goToTerms){}
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
//            Picker(selection: $selectedIndex, label: Text("Account Type")) {
//                
//                Text("Student").tag(0)
//                Text("Manager").tag(1)
//                   
//                
//            }.frame(width:300)
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            Picker(selection: $darkIndex, label: Text("Dark mode")) {
                
                Text("Dark Mode").tag(0)
                Text("Light Mode").tag(1)
                   
                
            }.frame(width:300)
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
            Text("Register").frame(width: 300 ,height: 50).background(shouldContinue ? Color(UIColor(resource: .blueLogin)) : Color.gray).foregroundColor(.white).cornerRadius(3.0).padding().onTapGesture {
                
                
                Auth.auth().createUser(withEmail: userName, password: password) { authResult, error in
                    
                    if let error = error {
                        print(error)
                        if password.count < 6 {
                            alertError = "try a password longer than 6 digits"
                        }
                        
                        
                        showAlert = true
                        return
                        
                        
                    }
                    if let authResult = authResult?.user{
                        
                 
                        if shouldContinue{
                            if confirm == password {
                                authUID = authResult.uid
                                                        
                                let newUser = User(uid: authUID, email: authResult.email ?? "", userColors: ["007AFF"])
//                                let newUser = User(uid: authResult.uid, email: authResult.email ?? "")
                                
                                withAnimation {
//                                    userID = authResult.uid
                                    userID = authResult.email ?? ""
//                                    pswd = password
                                    
                                    storeUserInfoInFirestore(user: newUser)
                                    userData.currentUser = newUser
                                    registerView = true
                                }
                                        
                                }else{
                                    showDoNotMatch = true
                                }
                        }
                            
                    }
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(
                    title: Text("oops!"),
                    message: Text("\(alertError)"),
                    dismissButton: .default(Text("OK")) {
                        //action
                    }
                )
            })
            .onChange(of: darkIndex, { oldValue, newValue in
                if newValue == 0{
                    settingsManager.isDarkModeEnabled = true
                    
                }else{
                    settingsManager.isDarkModeEnabled = false
                }
                
                
            })
            .onChange(of: userName) { oldValue, newValue in
                if agreeToTerms && userName != "" && password != "" && password.count >= 6 && confirm != ""{
                    if userName.isValidEmail(userName){
                        
                        shouldContinue = true
                    }
                }else{
                    shouldContinue = false
                }
            }
            .onChange(of: password) { oldValue, newValue in
                if agreeToTerms && userName != "" && password != "" && password.count >= 6 && confirm != ""{
                    shouldContinue = true
                }else{
                    shouldContinue = false
                }
            }
            .onChange(of: confirm) { oldValue, newValue in
                if agreeToTerms && userName != "" && password.count >= 6 && password != "" && confirm != ""{
                    shouldContinue = true
                }else{
                    shouldContinue = false
                }
            }
            .onChange(of: agreeToTerms) { oldValue, newValue in
                if agreeToTerms && userName != "" && password.count >= 6 && password != "" && confirm != ""{
                    shouldContinue = true
                }else{
                    shouldContinue = false
                }
            }
            .alert(isPresented: $showDoNotMatch){
                return Alert(
                    title: Text("Mismatch"),
                    message: Text("password and confirmed password do not match"),
                    dismissButton: .default(Text("OK"))
                    
                )
            }
            NavigationLink(destination: StudentView(), isActive: $registerView){}
            
//            Rectangle()
//                .foregroundColor(Color("green-8"))
//                .frame(width: 400, height: 50)
        }.padding()
        Spacer()
        
        HStack(){
            Text("Privacy").padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0)).foregroundColor(.blue).onTapGesture {
                goToPrivacy = true
                
            }
            
//            NavigationLink(destination: Privacy(), isActive: $goToPrivacy){}
            //setup a navlink for the privacy
            Spacer()
        }
        
        Spacer()
            .onAppear(){
                darkIndex = settingsManager.isDarkModeEnabled ? 0 : 1
            }
    }
    
    
    
}
    




#Preview {
    SignUp(passedPassword: "")
}
