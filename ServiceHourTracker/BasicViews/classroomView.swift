//
//  classroomView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/30/24.
//

import SwiftUI

struct classroomView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @State private var showIMGPicker = false
    @State private var selectedImage: UIImage?
    @State private var classImage: UIImage?
    @State private var loading = true
    @AppStorage("authuid") private var authID = ""
    
    var body: some View {
        //        ZStack{
        if loading{
            
             LoadingScreen().padding()
              
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ignoresSafeAreaEdges: .all)
            .animation(.easeOut(duration: 2))
            
            .onAppear(){
                
                downloadImageFromClassroomStorage(code: "\(classData.code)", file: "\(settingsManager.title).jpg", done: $loading) { image in
                    if let image = image{
                        classImage = image
                    }
                }
            }
            
        }else{
            NavigationView{
                ScrollView{
                    
                    if let image = classInfoManager.classImages[settingsManager.title]{
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
            
        
                .fullScreenCover(isPresented: $showIMGPicker) {
                    ImagePicker(image: $selectedImage)
                        .ignoresSafeArea(edges: .bottom)
                    
                }.onChange(of: selectedImage) { oldValue, newValue in
                    if let image = selectedImage{
                        uploadImageToUserStorage(id: authID, image: selectedImage!,file: settingsManager.title, done: $loading)
                    }
                }
                
                .onDisappear(){
                    if let image = classImage {
                        _ = saveImageToDocumentsDirectory(image: image, fileName: "\(settingsManager.title).jpg")
                    }
                }
            
        }
        
    }
}
#Preview {
    classroomView()
}
