//
//  SettingsView.swift

//
//  Created by kalsky_953982 on 10/3/23.
//

import SwiftUI
import FirebaseAuth
import UserNotifications
import FirebaseStorage
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
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @State var updated = false

    @AppStorage("authuid") private var authID = ""
    @State private var newPfp = UIImage(systemName: "person")
    @State private var changePfp = false
    @State private var managerIndex = 0
    var body: some View {
        NavigationStack{

            
            Form{
                /*
                Section{
                    HStack{
                        
                        
                        
                        Text("\(settingsManager.displayName)").font(.title).padding(.leading).bold()
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
                */
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
                    
                    Button{
                        createNoti(atDate: Date(timeIntervalSinceNow: 3), title: "testing", body: "my body", classCode: "02zg92", userIDIcon: nil, whereTo: "nowhere")
                    }label:{
                        Text("create scheduled noti")
                    }
                    Button{
                        createNoti(atDate: Date(timeIntervalSinceNow: 3), title: "testing", body: "my body", classCode: nil, userIDIcon: userID, whereTo: "nowhere")
                    }label:{
                        Text("create scheduled noti IDIcon")
                    }
                    
                    Button{
                        

                        // Create a notification content
                        let content = UNMutableNotificationContent()
                        content.title = "Notification Title"
                        content.body = "Notification Body"
                        content.sound = .default
//                        content.badge =  (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
                        
                        UNUserNotificationCenter.current().getDeliveredNotifications { notis in
                            print("is this my badge number?? \(notis.count)")
                            content.badge = notis.count as NSNumber
                        }
                       
                        // Add an image attachment
//                        if let imageURL = Bundle.main.url(forResource: "Designer-5", withExtension: "png") {
//                            let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
//                            if let attachment = attachment {
//                                content.attachments = [attachment]
//                                //multiple attachments, change UNNotificationAttachment, use firebase url
//                                
//                            }
//                        }else{
//                            print("noImageURL")
//                        }
                        
                        //storage image
                        getData(uid: userID) {user in
                            if let user = user {
                                let storageRef = Storage.storage().reference(withPath: "users/\(user.uid)/Pfp\(user.uid).jpg")
                                
                                print(storageRef.fullPath)
                                storageRef.downloadURL { (url, error) in
                                    if let error = error {
                                        print("Error getting storage URL: \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    guard let downloadURL = url else {
                                        print("Download URL not found")
                                        return
                                    }
                                    
                                    // Download the image from downloadURL
                                    let task = URLSession.shared.downloadTask(with: downloadURL) { (tempLocalUrl, response, error) in
                                        if let error = error {
                                            print("Error downloading image: \(error.localizedDescription)")
                                            return
                                        }
                                        
                                        guard let tempLocalUrl = tempLocalUrl else {
                                            print("Temporary local URL not found")
                                            return
                                        }
                                        
                                        // Move downloaded file to a permanent location
                                        
                                        let destinationURL = FileManager.default.temporaryDirectory
                                            .appendingPathComponent(downloadURL.lastPathComponent)
                                        
                                        do {
                                            if FileManager.default.fileExists(atPath: destinationURL.path) {
                                                try FileManager.default.removeItem(at: destinationURL) // Delete existing file
                                            }
                                            try FileManager.default.moveItem(at: tempLocalUrl, to: destinationURL)
                                            
                                            // Create a notification attachment
                                            let attachment = try UNNotificationAttachment(identifier: "imageAttachment", url: destinationURL, options: nil)
                                            
                                            // Create notification content
                                            let content = UNMutableNotificationContent()
                                            content.title = "Notification Title"
                                            content.body = "Notification Body"
                                            content.sound = UNNotificationSound.default
                                            content.attachments = [attachment]
                                            
                                            // Optionally, you can also set userInfo with attachment URL
                                            content.userInfo = ["attachment-url": downloadURL.absoluteString]
                                            
                                            // Display the notification
                                            let triggerDate = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day, .hour, .minute,.second], from: Date(timeInterval: 1, since: Date())), repeats: false)
                                            let request = UNNotificationRequest(identifier: "notificationIdentifier", content: content, trigger: triggerDate)
                                            UNUserNotificationCenter.current().add(request) { (error) in
                                                if let error = error {
                                                    print("Error displaying notification: \(error.localizedDescription)")
                                                }
                                            }
                                            
                                        } catch {
                                            print("Error moving downloaded file: \(error.localizedDescription)")
                                        }
                                    }
                                    
                                    task.resume()
                                }
                            }
}
                        

                        // Create a trigger
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                        let triggerDate = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day], from: Date()), repeats: false) //same day
                       

                    }label:{
                        Text("Test notifcation")
                    }
                    /*
                    Button("test"){
                        getAuthIDForEmail(email: "parker.cs@gmail.com") { id in
                            print("\n\(id)\n")
                        }
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
                                Image(systemName: "person.fill.checkmark").foregroundStyle(.green5).padding()
                            }
                            
                            
                        }
                    }
                    
                    Stepper("Max Hours", value: $settingsManager.perfHourRange, in: 0...100, step: 2)
                    
                    

                    
                    NavigationLink(destination: ContenetView()) {
                                Text("crop?")
                    }
                    
                    Button {
                        //let semaphore = DispatchSemaphore(value: 1)
                        //semaphore.wait()
                        collectHours(code: "5788MR") { reqsPerPerson in
                            print("DICTIONARY: \(reqsPerPerson)")
                            print("CLASS CODES: \(classInfoManager.classCodes)")
                            //semaphore.signal()
                        }
                    } label: {
                        Text("Test Hour Collection")
                    }
                     */
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
                if newName.trimmingCharacters(in: .whitespaces) != ""{
                    settingsManager.displayName = newName
                    updateDisplayName(uid: userID, newDisplayName: name)
                    updated = true
                }
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



