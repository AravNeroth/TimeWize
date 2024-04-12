
//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Jonathan Kalsky on 2/20/24.
//
import Foundation
import SwiftUI



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
            
            DatePicker("", selection: $date).padding().datePickerStyle(GraphicalDatePickerStyle()).tint(datePassed ? .red : .blue)
//            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute]).padding().datePickerStyle(GraphicalDatePickerStyle()).tint(datePassed ? .red : .blue)
            
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
                                            
                        let passed = hasDatePassed(date: date.formatted(.dateTime.year().month().day()))
                                                
                        if !passed {
                            datePassed = false
                            showPop = false
                            addTask(classCode: classData.code, creator: userID, title: taskName, date: date, timeCreated: Date(), maxSize: Int(maxPeople), numHours: Int(taskHours))
                            
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
