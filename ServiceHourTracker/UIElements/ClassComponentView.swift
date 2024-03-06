//
//  ClassComponentView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/3/24.
//

import SwiftUI

struct ClassComponentView: View {
    
    @State var classCode: String = ""
    @State var colors: [Color] = [.green4, .green6]
    @State var creator: String = "Creator"
    @State var creatorName: String = "Name"
    @State var title: String = "Test Title"
    @State var message: String = "No Announcement to Display"
    @State var date: Date
    @State var timeMade: Date
    @State var size = 0
    @State var signedUp: [String] = []
    @State var numHours = 0
    @State var isTask = true
    @State var showTaskPopUp = false
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        if isTask {
            Button {
                showTaskPopUp.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.background)
                    .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    .frame(height: 100)
                    .padding(.horizontal, 10.0)
                    .shadow(radius: 2.0, y: 2.0)
                    .overlay(
                        VStack {
                            HStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "list.clipboard.fill")
                                            .font(.system(size: 15.0, weight: .bold))
                                            .imageScale(.large)
                                            .foregroundStyle((colors.last!.luminance > 0.8) ? .black : .white)
                                            .padding(.bottom, 5.0)
                                    )
                                    .padding(.leading, 20.0)
                                    
                                VStack(alignment: .leading) {
                                    Text("\(title)")
                                        .multilineTextAlignment(.leading)
                                        .font(.title3)
                                        .bold()
                                    
                                    Text("\(formatDate(timeMade))")
                                        .multilineTextAlignment(.leading)
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    if Date() > date {
                                        Text("Sign Up Ended:")
                                            .font(.caption)
                                            .bold()
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 30.0)
                                    } else {
                                        Text("Sign Up Ends:")
                                            .font(.caption)
                                            .bold()
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 30.0)
                                    }
                                    
                                    Text("\(formatDate(date))")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30.0)
                                }
                            }
                        }
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showTaskPopUp) {
                taskPopUp(title: title, creator: creator, signedUp: $signedUp, size: size, numHours: numHours, date: date, isShowing: $showTaskPopUp)
            }
        } else {
            VStack {
                HStack {
                    Text("\(creatorName):")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 30.0)
                        .padding(.top, 15.0)
                    
                    Spacer()
                }
                
                HStack {
                    Text("\(formatDate(timeMade))")
                        .font(.caption)
                        .padding(.horizontal, 30.0)
                        .padding(.bottom, 15.0)
                    
                    Spacer()
                }
                
                HStack {
                    Text(message)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 30.0)
                        .padding(.bottom, 15.0)
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    .padding(.horizontal, 10.0)
                    .shadow(radius: 2.0, y: 2.0)
            )
            
        }
            
    }
}

private struct taskPopUp: View {
    
    @AppStorage("uid") var userID = ""
    @State var title = ""
    @State var creator: String = ""
    @Binding var signedUp: [String]
    @State var signedUpNames: [String:String] = [:]
    @State var signedUpColors: [String:[Color]] = [:]
    @State var signedUpPfps: [String:UIImage] = [:]
    @State var size = 0
    @State var numHours = 0
    @State var date: Date
    @State var loading = true
    @State var showFullAlert = false
    @EnvironmentObject var classData: ClassData
    @Binding var isShowing: Bool
    
    var body: some View {
        if loading {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    getTaskParticipants(classCode: classData.code, title: title) { list in
                        signedUp = list
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        for userEmail in signedUp {
                            getUserColors(email: userEmail) { colors in
                                signedUpColors[userEmail] = colors
                            }
                            getData(uid: userEmail) { user in
                                if let user = user {
                                    signedUpNames[userEmail] = user.displayName
                                    
                                    downloadImageFromUserStorage(id: user.uid, file: "Pfp\(user.uid).jpg") { pfp in
                                        if let pfp = pfp {
                                            signedUpPfps[userEmail] = pfp
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        loading = false
                    }
                }
        } else {
            VStack(alignment: .leading) {
                Text("\(title)")
                    .font(.largeTitle)
                    .bold()
                    .padding(30.0)
                
                Divider()
                    .padding(.horizontal, 30.0)
                    .padding(.bottom, 20.0)
                
                VStack {
                    Text("Details:")
                        .font(.title3)
                        .bold()
                    
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30.0)
                        .padding(.bottom, 10.0)
                    
                    GeometryReader { geometry in
                        HStack(alignment: .top, spacing: 0) {
                            VStack {
                                Text("Hours:")
                                    .shadow(radius: 1.0, y: 1.0)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                
                                Text("\(numHours)")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.regular)
                            }
                            .frame(width: geometry.size.width / 3)
                            
                            VStack {
                                Text("Max People:")
                                    .shadow(radius: 1.0, y: 1.0)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                
                                Text("\(size)")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.regular)
                            }
                            .frame(width: geometry.size.width / 3)
                            
                            VStack {
                                Text("End Date:")
                                    .shadow(radius: 1.0, y: 1.0)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                
                                Text("\(formatDate(date))")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.regular)
                            }
                            .frame(width: geometry.size.width / 3)
                        }
                    }
                    .frame(height: 80)
                }
                
                Divider()
                    .frame(height: 1)
                    .padding(.horizontal, 30.0)
                    .padding(.bottom, 20.0)
                
                VStack {
                    Text("Signed Up:")
                        .font(.title3)
                        .bold()
                    
                    ZStack(alignment: .top) {
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 30.0)
                        
                        ScrollView {
                            Text("")
                            
                            ForEach(signedUp, id: \.self) { person in
                                MiniProfileView(userEmail: person, userPfp: signedUpPfps[person], username: signedUpNames[person] ?? "", personCols: signedUpColors[person] ?? [.green4, .green6])
                            }
                        }
                        .frame(height: 200)
                    }
                }
                
                Spacer()
                
                if signedUp.contains(userID) {
                    Button {
                        getTaskParticipants(classCode: classData.code, title: title) { list in
                            signedUp = list
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            signedUp.remove(at: signedUp.firstIndex(of: userID)!)
                            updateTaskParticipants(classCode: classData.code, title: title, listOfPeople: signedUp)
                            loading = true
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(LinearGradient(gradient: Gradient(colors: [hexToColor(hex: "FF4D4D"), hexToColor(hex: "FF0000")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 60)
                            .padding(.horizontal, 30.0)
                            .overlay(
                                Text("Cancel")
                            )
                            .shadow(radius: 2.0, y: 2.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else if signedUp.count == size {
                    Button {
                        showFullAlert = true
                    } label: {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(LinearGradient(gradient: Gradient(colors: [hexToColor(hex: "AFAFAF"), hexToColor(hex: "757575")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 60)
                            .padding(.horizontal, 30.0)
                            .overlay(
                                Text("Sign Up")
                            )
                            .shadow(radius: 2.0, y: 2.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button {
                        getTaskParticipants(classCode: classData.code, title: title) { list in
                            signedUp = list
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            if signedUp.count != size {
                                signedUp.append(userID)
                                updateTaskParticipants(classCode: classData.code, title: title, listOfPeople: signedUp)
                                loading = true
                            } else {
                                showFullAlert = true
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(LinearGradient(gradient: Gradient(colors: [hexToColor(hex: "4CAF50"), hexToColor(hex: "087F23")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 60)
                            .padding(.horizontal, 30.0)
                            .overlay(
                                Text("Sign Up")
                            )
                            .shadow(radius: 2.0, y: 2.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
            .alert("Class is Full", isPresented: $showFullAlert) {
                Button("OK") {
                    showFullAlert = false
                }
            }
        }
    }
}
