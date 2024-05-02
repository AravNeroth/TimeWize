//
//  MiniProfileView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/1/24.
//

import SwiftUI

struct MiniProfileView: View {
    @Binding var showMessageSheet: Bool
    @Binding var showCurrSheet: Bool
    @State var classCode = ""
    @State var userEmail: String = ""
    @State var userPfp: UIImage? = UIImage(resource: .image2)
    @State var username = ""
    @State var personCols: [Color] = [.green4, .green6]
    @State var wantedPerson: String = ""
    @State var fromManView = false
    @State var isManager = false
    @State var displayOptions = false
    @Binding var loaded: Bool
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        if displayOptions {
            HStack {
                RoundedRectangle(cornerRadius: 50.0)
                    .fill(LinearGradient(gradient: Gradient(colors: personCols), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 40)
                    .padding(.leading, 20.0)
                    .padding(.trailing, 5.0)
                    .overlay(
                        HStack {
                            ZStack {
                                if let userPfp = userPfp {
                                    Image(uiImage: userPfp)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                        .shadow(radius: 2.0, y: 2.0)
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                        .shadow(radius: 2.0, y: 2.0)
                                        .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                                }
                            }
                            .padding(.leading, 30.0)
                            .padding(.trailing, 10.0)
                            
                            Text("\(username)")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                            
                            if(userEmail == wantedPerson) {
//                                Image(systemName: "crown.fill")
                                Text("👑")
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 2.5)
                                    .padding(.bottom, 2.5)
                            }
                            
                            Spacer()
                            
                            Button {
                                displayOptions.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 15.0, weight: .bold))
                                    .imageScale(.large)
                                    .rotationEffect(.degrees(90.0))
                                    .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 25.0)
                        }
                    )
                
                Button {
                    showCurrSheet = false
                    showMessageSheet = true
                    settingsManager.dm = userEmail
                } label: {
                    Image(systemName: "message.fill")
                        .font(.system(size: 15.0, weight: .bold))
                        .imageScale(.large)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: personCols), startPoint: .topLeading, endPoint: .bottomTrailing))
                }
                .frame(height: 40)
                .padding(.trailing, !(fromManView && !(userEmail == wantedPerson)) ? 20.0 : 5.0)
                
                if fromManView && !(userEmail == wantedPerson) {
                    Button {
                        if isManager {
                            leaveAsManager(uid: userEmail, code: classCode)
                            removeManagerFromClass(person: userEmail, classCode: classCode)
                            updateCodes(uid: userEmail, newCode: classCode)
                            addPersonToClass(person: userEmail, classCode: classCode)
                        } else {
                            removePersonFromClass(person: userEmail, classCode: classCode)
                            unenrollClass(uid: userEmail, code: classCode)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            loaded = false
                        }
                    } label: {
                        Image(systemName: "multiply")
                            .font(.system(size: 15.0, weight: .bold))
                            .imageScale(.large)
                            .foregroundStyle(.red)
                    }
                    .frame(height: 40)
                    .padding(.trailing, 20.0)
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 50.0)
                .fill(LinearGradient(gradient: Gradient(colors: personCols), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 40)
                .padding(.horizontal, 20.0)
                .overlay(
                    HStack {
                        ZStack {
                            if let userPfp = userPfp {
                                Image(uiImage: userPfp)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                                    .shadow(radius: 2.0, y: 2.0)
                            } else {
                                Image(systemName: "person")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                                    .shadow(radius: 2.0, y: 2.0)
                                    .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                            }
                        }
                        .padding(.leading, 30.0)
                        .padding(.trailing, 10.0)
                        
                        Text("\(username)")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                        
                        if(userEmail == wantedPerson) {
//                            Image(systemName: "crown.fill")
                            Text("👑")
                                .foregroundColor(.yellow)
                                .padding(.horizontal, 2.5)
                                .padding(.bottom, 2.5)
                        }
                        
                        Spacer()
                        
                        Button {
                            displayOptions.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 15.0, weight: .bold))
                                .imageScale(.large)
                                .rotationEffect(.degrees(90.0))
                                .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 40.0)
                    }
                )
        }
    }
}
