//
//  NewClassTabView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/28/24.
//

import SwiftUI

struct NewClassTabView: View {
    
    @AppStorage("uid") var userID = ""
    var title: String = "Title"
    var classCode: String
    @State var colors: [Color] = [.green2, .green4]
    @State var owner: String = ""
    var ownerPfp: UIImage? = UIImage(resource: .image2)
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @Binding var allClasses: [Classroom]
    @State var classroom: Classroom
    @State var showUnEnroll: Bool = false
    
    var body: some View {
        Button {
            settingsManager.tab = 4
            currentView = .ClassroomView
            settingsManager.title = title
            classData.code = classCode
        } label: {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
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
                            }
                            .padding(.horizontal, 30.0)
                        }
                        .frame(height: 100)
                        
                        Spacer()
                        
                        VStack() {
                            Button {
                                showUnEnroll.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20.0, weight: .bold))
                                    .imageScale(.large)
                                    .rotationEffect(.degrees(90.0))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20.0)
                            
                            Spacer()
                        }
                        .frame(height: 70)
                    }
                )
        }
        .onAppear() {
            getClassInfo(classCloudCode: classCode) { newClass in
                let list = newClass?.managerList
                
                if let list = list {
                    getData(uid: list.first!) { newUser in
                        owner = (newUser?.displayName)!
                    }
                }
            }
            // change this to not make it random
            switch (Int(arc4random_uniform(3)) + 1) {
            case 1:
                colors = [.green2, .green4]
                break
            case 2:
                colors = [.blue2, .blue4]
                break
            default:
                colors = [.purple2, .purple4]
                break
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showUnEnroll) {
            unEnrollPopUp(classCode: classCode, showUnEnroll: $showUnEnroll, allClasses: $allClasses, classroom: classroom)
                .presentationDetents([.height(50.0)])
        }
        .animation(.easeIn, value: showUnEnroll)
    }
}

private struct unEnrollPopUp: View {
    
    @AppStorage("uid") var userID = ""
    var classCode: String
    @Binding var showUnEnroll: Bool
    @Binding var allClasses: [Classroom]
    @State var classroom: Classroom
    
    var body: some View {
        VStack {
            Button {
                getCodes(uid: userID) { codesList in
                    if let codesList = codesList {
                        unenrollClass(uid: userID, codes: codesList, code: classCode)
                        allClasses.remove(at: allClasses.firstIndex(of: classroom)!)
                        removePersonFromClass(person: userID, classCode: classCode)
                    }
                }
                showUnEnroll = false
            } label: {
                Text("UNENROLL")
            }
            .foregroundStyle(isDarkModeEnabled() ? .white : .black)
        }
    }
}

private func isDarkModeEnabled() -> Bool {
    if UITraitCollection.current.userInterfaceStyle == .dark {
        return true
    } else {
        return false
    }
}
