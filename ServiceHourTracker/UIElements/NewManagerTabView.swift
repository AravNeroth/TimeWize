//
//  NewManagerTabView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/6/24.
//

import SwiftUI

struct NewManagerTabView: View {
    
    @AppStorage("uid") private var userID = ""
    var title: String = "Title"
    var classCode: String
    @State var colors: [Color] = [.green4, .green6] // green6 as last is important because its a default
    @State var owner: String = ""
    var ownerPfp: UIImage? = UIImage(resource: .image2)
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @Binding var allClasses: [Classroom]
    @State var classroom: Classroom
    @State var showMenu: Bool = false
    
    var body: some View {
        Button {
            classData.code = classCode
            settingsManager.title = title
            currManagerView = .ManagerClass
            settingsManager.manTab = 3
        } label: {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 130)
                .padding(.horizontal, 10.0)
                .shadow(radius: 2.0, y: 2.0)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal, 30.0)
                                .shadow(radius: 2.0, y: 2.0)
                                .foregroundStyle(colors.first!.isBright() ? .black : .white)
                            
                            Spacer()
                            
                            HStack {
                                Circle()
                                    .frame(maxWidth: 35.0, maxHeight: 35.0)
                                    .overlay(
                                        VStack {
                                            Image(uiImage: ownerPfp ?? UIImage(resource: .image2))
                                                .resizable()
                                                .clipShape(Circle())
                                        }
                                    )
                                
                                Text(owner)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colors.first!.isBright() ? .black : .white)
                            }
                            .padding(.horizontal, 30.0)
                        }
                        .frame(height: 100)
                        
                        Spacer()
                        
                        VStack() {
                            Button {
                                showMenu.toggle()
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20.0, weight: .bold))
                                    .imageScale(.large)
                                    .foregroundStyle(colors.first!.isBright() ? .black : .white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20.0)
                            .padding(.vertical, 15.0)
                            
                            Spacer()
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showMenu) {
            menuPopUp(classCode: classCode, showMenu: $showMenu, allClasses: $allClasses, classroom: classroom)
                .presentationDetents([.height(60.0)])
        }
        .animation(.easeIn, value: showMenu)
    }
}

private struct menuPopUp: View {
    
    @AppStorage("uid") var userID = ""
    var classCode: String
    @Binding var showMenu: Bool
    @Binding var allClasses: [Classroom]
    @State var classroom: Classroom
    
    var body: some View {
        VStack {
            Button {
                getClasses(uid: userID) { classesList in
                    if classesList != nil {
                        leaveAsManager(uid: userID, code: classCode)
                        allClasses.remove(at: allClasses.firstIndex(of: classroom)!)
                        removeManagerFromClass(person: userID, classCode: classCode)
                    }
                }
                showMenu = false
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()

                    Text("Leave As Manager")
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
