
//
//  Created by Kentaro Mihara on 2023/08/16.
//


///reference documentation: https://firebase.google.com/docs/cloud-messaging/ios/client?authuser=0&hl=en
///original version of the file by MIhara: https://github.com/kenmaro3/ios-firebase-cloud-messaging/blob/main/CloudMessagingIos/CloudMessagingIosApp.swift
///Miharas youtube video: https://www.youtube.com/watch?v=6LAQBbLC_qE
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SwiftUI
import FirebaseStorage


final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var settingsManager: SettingsManager?
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        //        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().token { token, error in
            if let error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token {
                print("\n\nregistration token: \(token)\n\n")
            }
        }
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
//            reactToNoti(response: response)
        
            if let whereTo = response.notification.request.content.userInfo["view"] as? String{
                
                
                if whereTo == "requests"{
                    currActionSelected = .Requests
                    if let settingsManager = settingsManager{
                        if settingsManager.isManagerMode{
                            settingsManager.manTab = 5
                        }else{
                            settingsManager.tab = 6
                        }
                    }
                }
                
                
            }
        
            
    }
    
    
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }
    
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("registeredFRNWDT")
        var readableToken = ""
        for index in 0 ..< deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
        }
        Messaging.messaging().apnsToken = deviceToken //added b/c of swizzling or something
        Messaging.messaging().token { token, error in
            if let error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token {
                print("\n\nregistration token: \(token)\n\n")
            }
        }
        //added:
        // if ask for permission first then add a metadata value to your Info.plist (not your GoogleService-Info.plist): FirebaseMessagingAutoInitEnabled = NO
        //Then if yes then you can do this:
        //Messaging.messaging().isAutoInitEnabled = true
    }
}

extension AppDelegate: MessagingDelegate {
    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        //added:
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .list, .sound]])
    }
    /*
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
        completionHandler()
    }
     */
}





func createNoti(timeWait: Double, title: String, body: String, whereTo: String?){
    @AppStorage("uid") var userID: String = ""
    // Create a notification content

    
    
    
    
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
                        let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: destinationURL, options: nil)
                        
                        // Create notification content
                        let content = UNMutableNotificationContent()
                        content.title = title
                        content.body = body
                        content.sound = UNNotificationSound.default
                        if let attachment = attachment{
                            content.attachments = [attachment]
                        }
                        if let whereTo = whereTo{
                            content.userInfo["view"] = whereTo
                        }
                        // Optionally, you can also set userInfo with attachment URL
                        content.userInfo["attachment-url"] = downloadURL.absoluteString
                        
                        // Display the notification
                        UNUserNotificationCenter.current().getDeliveredNotifications { notis in
                            UNUserNotificationCenter.current().setBadgeCount(notis.count+1)
                                
                        }
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeWait, repeats: false)
                        let request = UNNotificationRequest(identifier: "notificationIdentifier", content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { (error) in
                            if let error = error {
                                print("Error displaying notification: \(error.localizedDescription)")
                                UNUserNotificationCenter.current().getDeliveredNotifications { notis in
                                    UNUserNotificationCenter.current().setBadgeCount(notis.count-1)
                                        
                                }
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
    
    
    
    
    
}

func createNoti(atDate: Date, title: String, body: String, classCode: String?, userIDIcon: String?, whereTo: String?){
    let DG = DispatchGroup()
    DG.enter()
    
    var storageRef:StorageReference? = nil
    if let classCode = classCode{
        getClassInfo(classCloudCode: classCode) { classroom in
            if let classroom = classroom{
                storageRef = Storage.storage().reference(withPath: "classrooms/\(classCode)/Home\(classroom.title).jpg")
                print(storageRef!.fullPath)
                UNUserNotificationCenter.current().getDeliveredNotifications { notis in
                    UNUserNotificationCenter.current().setBadgeCount(notis.count+1)
                    DG.leave()
                }
                
            }
        }
    }else if let userIDIcon = userIDIcon{
        getData(uid: userIDIcon) {user in
            if let user = user {
                storageRef = Storage.storage().reference(withPath: "users/\(user.uid)/Pfp\(user.uid).jpg")
                print(storageRef!.fullPath)
                DG.leave()
            }
        }
    }else{
        //no attachments
        DG.leave()
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
    DG.notify(queue: .main){
        print("path: " + storageRef!.fullPath)
        storageRef!.downloadURL { (url, error) in
            if let error = error {
                print("path: " + storageRef!.fullPath)
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
                    let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: destinationURL, options: nil)
                    
                    // Create notification content
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = body
                    content.sound = .default
                    if let attachment = attachment{
                        content.attachments = [attachment]
                    }
                    if let whereTo = whereTo{
                        content.userInfo = ["view" : whereTo]
                    }
                    // Optionally, you can also set userInfo with attachment URL
                    content.userInfo = ["attachment-url": downloadURL.absoluteString]
                    
                    // Display the notification
                    let triggerDate = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day, .hour, .minute,.second], from: atDate), repeats: false)
                    let request = UNNotificationRequest(identifier: "notificationIdentifier\(Date())", content: content, trigger: triggerDate)
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


