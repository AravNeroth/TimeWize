//
//  classroomView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/30/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
struct classroomView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showIMGPicker = false
    @State private var selectedImage: UIImage?
    @State private var classImage: UIImage?
    @State private var loading = true
    @AppStorage("authuid") private var authID = ""
    
    var body: some View {
        ZStack{
            
            NavigationView{
                ScrollView{
                    
                    if let image = classImage{
                        Image(uiImage: image).resizable().scaledToFill().frame(width: 500, height: 200).padding()
                    }
                    
                    Text("\(settingsManager.title)").padding()
                    Spacer()
                    Button{
                        showIMGPicker = true
                    }label:{
                        Text("change the image").padding().clipShape(.capsule).cornerRadius(50).background(.blue).foregroundStyle(.white).padding()
                    }
                    
                    
                }
                
            }.animation(.easeInOut)
            if loading{
                VStack{
                    LoadingScreen().padding()
                    
//                    if classImage == nil {
//                        Button{
//                            showIMGPicker = true
//                        }label:{
//                            Text("pick an image").padding().clipShape(.ellipse).cornerRadius(50).background(.blue).foregroundStyle(.white).padding()
//                        }
//                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .animation(.easeOut(duration: 2))
            }
        }
            .fullScreenCover(isPresented: $showIMGPicker) {
                ImagePicker(image: $selectedImage)
                
            }.onChange(of: selectedImage) { oldValue, newValue in
                if let image = selectedImage{
                    uploadImageToStorage(uid: authID, image: selectedImage!,className: settingsManager.title, done: $loading)
                }
            }.onAppear(){
                classImage = loadImageFromDocumentsDirectory(fileName:"\(settingsManager.title).jpg",done: $loading)
                downloadImageFromStorage(uid: authID, fileName: "\(settingsManager.title).jpg", done: $loading) { image in
                    if let image = image{
                        classImage = image
                    }
                }
            }.onDisappear(){
                if let image = classImage {
                    _ = saveImageToDocumentsDirectory(image: image, fileName: "\(settingsManager.title).jpg")
                }
            }
            
        }
        
    }
// Upload image to firebase storage
// can pass in boolean but make it binded -> will turn the boolean false once loaded successfully to turn off the loading screen
func uploadImageToStorage(uid: String, image: UIImage, className: String? = "", done: Binding<Bool>? = nil){
    
    guard !uid.isEmpty else {
            return
        }
    print(uid)
    var ref: StorageReference
    if(className == ""){
        ref = Storage.storage().reference().child(uid).child("\(UUID().uuidString).jpg")
    }else{
        ref = Storage.storage().reference().child(uid).child("\(className!).jpg")
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


func downloadImageFromStorage(uid: String, fileName: String, done: Binding<Bool>? = nil, completion: @escaping (UIImage?) -> Void) {
    guard !uid.isEmpty else {
        print("UID is empty")
        completion(nil)
        return
    }

    // Create a reference to the Firebase Storage using the provided UID and fileName
    let storageRef = Storage.storage().reference().child(uid).child(fileName)

    // Download the image data
    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
        if let error = error {
            print("Failed to download image data: \(error)")
            completion(nil)
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
            completion(nil)
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
        print("Image saved successfully to \(fileURL.path)")
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
#Preview {
    classroomView()
}
