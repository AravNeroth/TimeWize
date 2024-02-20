//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Verlyn Fischer on 2/15/24.
//

import Foundation
import SwiftUI

struct ManagerClass: View {
    @Binding var loaded: Bool
    @State private var imageSelection = false
    @State private var newBanner = UIImage(systemName: "person")
    @EnvironmentObject var classData: ClassData
    @EnvironmentObject private var settingsManager: SettingsManager
    var body: some View{
        NavigationStack{
            VStack{
                Text("manager class")
            }
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    imageSelection = true
                }label: {
                    Image(systemName: "photo.fill")
                }
               
            }
            
        }
            
        .fullScreenCover(isPresented: $imageSelection) {
            ImagePicker(image: $newBanner)
                
                .ignoresSafeArea(edges: .bottom)
        }
        .onChange(of: newBanner) {
            if let newBanner = newBanner{
                print("code: \(classData.code)")
                uploadImageToClassroomStorage(code: classData.code , image: newBanner, file: "\(settingsManager.title)")
                loaded = false
            }
        }
    }
}
