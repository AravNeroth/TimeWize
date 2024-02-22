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
    @EnvironmentObject private var classInfoManager: ClassInfoManager
    @EnvironmentObject private var settingsManager: SettingsManager
   
    @State private var showTaskPopup = false
    var body: some View{
        NavigationStack{
            VStack{
                Text("manager class: \(classData.code)")
                if showTaskPopup {
                    taskPopup(showPop: $showTaskPopup)
                        .frame(width: 300, height: 500, alignment: .center).offset(y: -130)
                }
            }
            
            
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button{
                        
                        imageSelection = true
                    }label: {
                        Image(systemName: "photo.fill")
                    }
                    
                    Button{
                        showTaskPopup = true
                    }label: {
                        Image(systemName: "plus")
                    }
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
                classInfoManager.managerClassImages[settingsManager.title] = newBanner
                loaded = false
            }
        }
    }
}




struct taskPopup: View {
    @Binding var showPop: Bool
    @State private var taskName = ""

    @State private var date: Date = Date()
    @State private var taskHours: Double = 0
    @State private var maxPeople: Double = 0
    
    @EnvironmentObject private var classData:ClassData
    @AppStorage("uid") private var userID = ""
    

    var body: some View {
        VStack(spacing: 20) {
          
            TextField("Enter Task Title", text: $taskName).tint(Color.green7).padding()
            
            DatePicker("", selection: $date).padding()
            
            Slider(value: $taskHours, in: 0...10, step: 1)
                .padding().tint(Color.green7)
            Text("Hours: \(Int(taskHours))")
            
            Slider(value: $maxPeople, in: 0...20, step: 1)
                .padding().tint(Color.green7)
            Text("Max People: \(Int(maxPeople))")
            
            HStack{
                Button("OK") {
                    showPop = false
                    addTask(classCode: classData.code, title: taskName, date: date, maxSize: Int(maxPeople), numHours: Int(taskHours))
                    print("Hours: \(taskHours) in Button")
                }.padding().tint(Color.green7)
                Button("Cancel") {
                    showPop = false
                    taskName = ""
                    taskHours = 0
                    maxPeople = 0
                }.padding().tint(Color.green7)
            }
        }.padding(10)
        .background(Color.green3).cornerRadius(10)
       .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green6, lineWidth: 1))
       .padding(.horizontal)
    }
           
       
           

            
    }

