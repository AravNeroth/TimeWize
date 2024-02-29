//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Verlyn Fischer on 2/15/24.
//

import Foundation
import SwiftUI

struct ManagerClassroomView: View {
    @State private var showPpl = false
    //@Binding var loaded: Bool
    @State private var imageSelection = false
    @State private var homeImageSelection = false
    @State private var newBanner = UIImage(systemName: "person")
    @State private var newHome = UIImage(systemName: "person")
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
                        .frame(width: 375, height: 500, alignment: .center).offset(y: -130)
                }
            }
            
            
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button{
                        showPpl = true
                    }label: {
                        Image(systemName: "person.3")
                    }
                    
                    Menu{
                        Button("Banner"){
                            imageSelection = true
                        }
                        Button("Home"){
                           homeImageSelection = true
                        }
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
        .sheet(isPresented: $showPpl) {
            PeopleListView(code: classData.code, classTitle: settingsManager.title, isShowing: $showPpl)
        }
        .fullScreenCover(isPresented: $imageSelection) {
            ImagePicker(image: $newBanner)
                
                .ignoresSafeArea(edges: .bottom)
        }
        
        .sheet(isPresented: $homeImageSelection, content: {
            ImagePicker(image: $newHome)
            
                .ignoresSafeArea(edges: .bottom)
        })
        .onChange(of: newHome, {
            if let newHome = newHome{
                uploadImageToClassroomStorage(code: classData.code, image: newHome, file: "Home\(settingsManager.title)")
                
            }
        })
        .onChange(of: newBanner) {
            if let newBanner = newBanner{
                print("code: \(classData.code)")
                uploadImageToClassroomStorage(code: classData.code , image: newBanner, file: "\(settingsManager.title)")
                classInfoManager.managerClassImages[settingsManager.title] = newBanner
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
    @State private var showStroke:Bool = false
    @State private var datePassed:Bool = false
    @EnvironmentObject private var classData:ClassData
    @AppStorage("uid") private var userID = ""
    

    var body: some View {
        ScrollView() {
          //spacing 20 VStack
            TextField("Enter Task Title", text: $taskName).tint(Color.green7).padding()
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                
                    .stroke(lineWidth: 1)
                    .foregroundColor(showStroke ? .red : .black)
                )
            
            DatePicker("", selection: $date, displayedComponents: .date).padding().datePickerStyle(GraphicalDatePickerStyle()).tint(datePassed ? .red : .blue)
            
            Slider(value: $taskHours, in: 0...10, step: 1)
                .padding().tint(Color.blue)
            Text("Hours: \(Int(taskHours))")
            
            Slider(value: $maxPeople, in: 0...20, step: 1)
                .padding().tint(Color.blue)
            Text("Max People: \(Int(maxPeople))")
            
            HStack{
                Button("OK") {
                    
                    if taskName != ""{
                        showStroke = false
                                            print(date.formatted(.dateTime.year().month().day()))
                        let passed = hasDatePassed(date: date.formatted(.dateTime.year().month().day()))
                                                print(passed)
                        if !passed {
                            datePassed = false
                            showPop = false
                            addTask(classCode: classData.code, title: taskName, date: date, maxSize: Int(maxPeople), numHours: Int(taskHours))
                            print("Hours: \(taskHours) in Button")
                        }else{
                            datePassed = true
                        }
                    }else{
                        showStroke = true
                    }
                    
                    
                }.padding().tint(Color.green7)
                Button("Cancel") {
                    showPop = false
                    taskName = ""
                    taskHours = 0
                    maxPeople = 0
                }.padding().tint(Color.green7)
            }
        }.padding(10)
            .background(.white).cornerRadius(10) // was green3
       .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1)) // was green6
       .padding(.horizontal)
    }
           
       
           

            
    }

