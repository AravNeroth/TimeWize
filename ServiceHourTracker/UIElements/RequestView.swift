//
//  RequestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/17/24.
//

import SwiftUI

struct RequestView: View {
    
    @State var className: String = "Test Class"
    @State var classCode: String = "testCode"
    @State var description: String = "Test Description"
    @State var numHours: Int = 0
    @State var hourType: String = "General"
    @State var email: String = "testEmail@gmail.com"
    @State var request: [String:String] = [:]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20.0, style: .circular)
            .frame(width: 375, height: 250)
            .foregroundColor(.green5)
            .overlay(
        VStack {
            HStack {
                Text(className)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .bold()
                    .padding(10)
                    
                Spacer()
                
                Text(email)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(10)
            }
            
            Divider()
                .frame(width: 350)
                
            HStack {
                Text(description)
                    .multilineTextAlignment(.center)
                    .frame(width: 175, height: 75)
                    .padding(10)
                    
                Spacer()
                    
                Text("Hour Type:\n\(hourType)")
                    .multilineTextAlignment(.center)
                    .bold()
                    .frame(height: 75)
                    .padding(10)
            }
                
            Divider()
                .frame(width: 350)
                
            HStack {
                Text("Hours: \(numHours)")
                    .bold()
                    .padding(10)
                
                Spacer()
                
                Text("Accept/Decline:")
                    .bold()
                
                HStack {
                    Button(action: {
                        acceptRequest(request: request, classCode: classCode)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.green)
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                        }
                    }
                    Button(action: {
                        declineRequest(request: request, classCode: classCode)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.red)
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(10)
            }
        })
    }
}

#Preview {
    RequestView()
}
