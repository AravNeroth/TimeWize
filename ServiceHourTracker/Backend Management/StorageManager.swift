//
//  StorageManager.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/9/24.
//

import Foundation
import SwiftUI
import FirebaseStorage


// Upload image to firebase storage
// can pass in boolean but make it binded -> will turn the boolean false once loaded successfully to turn off the loading screen
func uploadImageToUserStorage(id: String, image: UIImage, file: String? = "", done: Binding<Bool>? = nil){
    
    guard !id.isEmpty else {
            return
        }
    
    var ref: StorageReference
    if(file == ""){
        ref = Storage.storage().reference().child("users").child(id).child("\(UUID().uuidString).jpg")
    }else{
        ref = Storage.storage().reference().child("users").child(id).child("\(file!).jpg")
    }
    guard let imageData = image.jpegData(compressionQuality: 0.5)else{return}
    
    ref.putData(imageData, metadata: nil){
        metada, error in
        if let err = error {
            print( "Failed to push image to Storage: \(err)")
            return
        }
        
        ref.downloadURL { url, error in
            if let error = error{
                print("failed to download url \(error)")
                return
            }
            if let done = done{
                done.wrappedValue = false
            }
            print(url?.absoluteString ?? "no url")
            return
        }
    }
            
        
}

func uploadImageToClassroomStorage(code: String, image: UIImage, file: String? = "", done: Binding<Bool>? = nil){
    
    guard !code.isEmpty else {
            return
        }
    
    var ref: StorageReference
    if(file == ""){
        ref = Storage.storage().reference().child("classrooms").child(code).child("\(UUID().uuidString).jpg")
    }else{
        ref = Storage.storage().reference().child("classrooms").child(code).child("\(file!).jpg")
    }
    guard let imageData = image.jpegData(compressionQuality: 0.5)else{return}
    
    ref.putData(imageData, metadata: nil){
        metada, error in
        if let err = error {
            print( "Failed to push image to Storage: \(err)")
            return
        }
        
        ref.downloadURL { url, error in
            if let error = error{
                print("failed to download url \(error)")
                return
            }
            if let done = done{
                done.wrappedValue = false
            }
            print(url?.absoluteString ?? "no url")
            return
        }
    }
            
        
}

//AUTHID, FileName with .jpg!!!
func downloadImageFromUserStorage(id: String, file: String, done: Binding<Bool>? = nil, completion: @escaping (UIImage?) -> Void) {
    
    print("inside downloadImage")
    guard !id.isEmpty else {
        print("downloadImageFromUserStorage \n folder is empty")
//        completion(nil)
        return
    }
    
    // Create a reference to the Firebase Storage using the provided UID and fileName
    let storageRef = Storage.storage().reference().child("users").child(id).child(file)

    // Download the image data
    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
        if let error = error {
            print("Failed to download image data: \(error)")
//            completion(nil)
            return
        }

        // Convert the downloaded data to a UIImage
        if let imageData = data, let image = UIImage(data: imageData) {
            if let done = done{
                done.wrappedValue = false
                
            }
            
            completion(image)
        } else {
            print("Failed to convert data to UIImage")
//            completion(nil)
        }
    }
}
func downloadImageFromClassroomStorage(code: String, file: String, done: Binding<Bool>? = nil, completion: @escaping (UIImage?) -> Void) {
    
    guard !code.isEmpty else {
        print("downloadImageFromClassroomStorage \n folder is empty")
//        completion(nil)
        return
    }
    
    // Create a reference to the Firebase Storage using the provided UID and fileName
    let storageRef = Storage.storage().reference().child("classrooms").child(code).child(file)

    // Download the image data
    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
        if let error = error {
            print("Failed to download image data: \(error)")
//            completion(nil)
            return
        }

        // Convert the downloaded data to a UIImage
        if let imageData = data, let image = UIImage(data: imageData) {
            if let done = done{
                done.wrappedValue = false
            }
            completion(image)
        } else {
            print("Failed to convert data to UIImage")
//            completion(nil)
        }
    }
}
// download image to app file storage
// can pass in boolean but make it binded -> will turn the boolean false once loaded successfully to turn off the loading screen
func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return nil
    }

    let fileURL = documentsDirectory.appendingPathComponent(fileName)

    do {
        try image.jpegData(compressionQuality: 0.8)?.write(to: fileURL)
        
        return fileURL
    } catch {
        print("Error saving image: \(error.localizedDescription)")
        return nil
    }
}

func loadImageFromDocumentsDirectory(fileName: String, done: Binding<Bool>? = nil) -> UIImage? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return nil
    }

    let fileURL = documentsDirectory.appendingPathComponent(fileName)

    do {
        let imageData = try Data(contentsOf: fileURL)
        if let done = done{
            done.wrappedValue = false
        }
        return UIImage(data: imageData)
    } catch {
        print("Error loading image: \(error.localizedDescription)")
        return nil
    }
}
