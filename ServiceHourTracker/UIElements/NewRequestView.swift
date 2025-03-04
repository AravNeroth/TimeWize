//
//  NewRequestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/19/24.
//

import SwiftUI

struct NewRequestView: View {
    
    @Binding var showMessageSheet: Bool
    @State var className = "name"
    @State var classCode = "code"
    @State var colors: [Color] = [.green4, .green6]
    @State var title = "title"
    @State var description = "description"
    @State var verifier = "verifier"
    @State var numHours = 0
    @State var hourType = "type"
    @State var email = "email"
    @State var request: Request
    @State var fromManSide = true
    @Binding var done: Bool
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        if fromManSide {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(.background)
                .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                .frame(height: 250)
                .padding(.horizontal, 10.0)
                .shadow(radius: 2.0, y: 2.0)
                .overlay(
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(title)
                                        .font(.title2)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Button {
                                        showMessageSheet = true
                                        settingsManager.dm = email
                                    } label: {
                                        Image(systemName: "message.fill")
                                            .font(.title2)
                                            .imageScale(.large)
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    }
                                }
                                .padding(.top, 2.5)
                                .padding(.bottom, 7.5)
                                
                                Text(className)
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text(email)
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30.0)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                
                                
                                Text("Hour Type: \(hourType)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Hours: \(numHours)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Reference: \(verifier)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("\(description)")
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 50)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Accept or\nDecline?")
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .bold()
                                
                                HStack {
                                    Button {
                                        acceptRequest(request: request, classCode: classCode)
                                        request.accepted = true
                                        done.toggle()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(colors.first!.isBright() ? .black : .white)
                                                    .bold()
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button {
                                        declineRequest(request: request, classCode: classCode)
                                        done.toggle()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Image(systemName: "xmark")
                                                    .foregroundStyle(colors.first!.isBright() ? .black : .white)
                                                    .bold()
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 30.0)
                    }
                )
        } else {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(.background)
                .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                .frame(height: 200)
                .padding(.horizontal, 10.0)
                .shadow(radius: 2.0, y: 2.0)
                .overlay(
                    VStack {
                        HStack {
                            Text(title)
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30.0)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(className)
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Hour Type: \(hourType)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Hours: \(numHours)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("Reference: \(verifier)")
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                                    .bold()
                                
                                Text("\(description)")
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 50)
                            }
                            .padding(.horizontal, 30.0)
                            
                            Spacer()
                        }
                    }
                )
        }
    }
}
