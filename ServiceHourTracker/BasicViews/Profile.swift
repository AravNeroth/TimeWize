//
//  Profile.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/21/24.
//

import SwiftUI
import SwiftSMTP

struct Profile: View {
    
    @EnvironmentObject private var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @State var colorPaletteSheet = false
    @State private var refresh = true
    @State var showImgPicker = false
    @State private var userPfp = UIImage(resource: .image1)
    @State private var newPfp = UIImage(systemName: "person")
    @State var totalHoursEarned: [Classroom:Int] = [:]
    @State var points: [CGFloat] = [0]
    @State var classes: [Classroom] = []
    @State var totalHours = 0
    @State var totalGoal = 0
    @AppStorage("authuid") var authID = ""
    @AppStorage("uid") var userID = ""
    @State var load = false
    
    var body: some View {
        if load{
            
            LoadingScreen()
                .onAppear{
                    let DS = DispatchSemaphore(value: 1)
                    DS.wait()
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                    DS.signal()
                    load = false
                }
            
            
        }else{
            
            ZStack{
                ScrollView {
                    Spacer(minLength: 212.5)
                    ZStack {
                        Circle()
                            .fill(.black)
                        Circle()
                            .fill(.gray.opacity(0.3))
                            .overlay(
                                Text("\(totalHours) Hours")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                
                                
                            )
                        Circle()
                            .trim(from: 0, to: 1)
                        //                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: -90))
                        
                        if totalHoursEarned.keys.count > 1 {
                            ForEach(0 ..< totalHoursEarned.keys.count , id: \.self) { ind in
                                if ind + 1 <= points.count {
                                    let currentPoint = points[ind]
                                    let nextPoint = points[ind + 1]
                                    if totalHoursEarned[Array(totalHoursEarned.keys)[ind]] != 0 {
                                        Circle()
                                            .trim(from: currentPoint/360, to: nextPoint/360)
                                            .stroke(
                                                LinearGradient(
                                                    colors: classInfoManager.classColors[Array(totalHoursEarned.keys)[ind]] ?? settingsManager.userColors,
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .shadow(radius: 20, y: 3)
                                    }
                                }
                            }
                            
                            //                        CircleTracker(settingsManager: _settingsManager, classInfoManager: _classInfoManager, totalGoal: totalGoal, totalHours: totalHours, classes: <#T##[Classroom]#>, points: <#T##[CGFloat]#>)
                            /*
                             Circle()
                             .trim(from: 60/360, to: 200/360)
                             //                .stroke(.red, lineWidth: 20)
                             .stroke(LinearGradient(colors: [.red, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                             .rotationEffect(Angle(degrees: -90))
                             .shadow(radius: 20, y: 3)
                             Circle()
                             .trim(from: 0/360, to: 60/360)
                             //                .stroke(.blue, lineWidth: 20)
                             .stroke(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                             .rotationEffect(Angle(degrees: -90))
                             .shadow(radius: 10, y: 3)
                             */
                        }
                    }.padding(.horizontal, 50)
                        Spacer(minLength: 100)
                        NewHourBoardView(totalHoursEarned: $totalHoursEarned)
                    }
                    //            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height )
                    .refreshable {
                        load = true
                        //                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                        
                    }
                    Rectangle().fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing)).shadow(radius: 3, y: 2).padding(.horizontal, 0).frame(height: 150)
                        .overlay(
                            ZStack{
                                
                                VStack{
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .bottom){
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.black)
                                                .frame(width: 80, height: 80)
                                            
                                            Image(uiImage: settingsManager.pfp)
                                                .resizable()
                                                .frame(width: 75,height: 75)
                                            
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .overlay(
                                                    
                                                    VStack{
                                                        Spacer()
                                                        HStack(alignment: .bottom){
                                                            Spacer()
                                                            ZStack{
                                                                Circle().frame(width: 25,height: 25).foregroundStyle(.black)
                                                                Button{
                                                                    showImgPicker = true
                                                                }label:{
                                                                    Image(systemName: "pencil").foregroundStyle(.white)
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                )
                                            
                                            
                                            
                                        }.padding(.leading, 10).shadow(radius: 3,y:3)
                                        Spacer()
                                    }.padding(.top, 130)
                                    
                                }
                                
                                
                                
                                HStack{
                                    
                                    Text(settingsManager.displayName)
                                        .padding(.leading, 95)
                                        .bold()
                                        .font(.largeTitle)
                                        .foregroundStyle(settingsManager.userColors.first!.isBright() ? .black : .white)
                                    Spacer()
                                    Button{
                                        colorPaletteSheet = true
                                        
                                    }label: {
                                        Image(systemName: "paintpalette.fill").resizable().scaledToFill().frame(width: 25, height: 25).foregroundStyle(.white).padding(10)
                                    }
                                    Button{
                                        settingsManager.tab = 3
                                    }label: {
                                        Image(systemName: "gearshape.fill").resizable().scaledToFit().frame(width: 25, height: 25)
                                    }.padding(10).foregroundStyle(.white)
                                    
                                }.padding(.top, 75)
                                
                            }
                            
                            
                        ).frame(height: 225)
                        .position(x: UIScreen.main.bounds.width / 2, y: -210)
                        .frame(height: 190)
                    
                    
                }
                .ignoresSafeArea()
                
                
                
                
                
                .sheet(isPresented: $colorPaletteSheet) {
                    UserColorPalette(showPop: $colorPaletteSheet, refresh: $refresh)
                        .onDisappear() {
                            colorPaletteSheet = false
                        }
                }
                .sheet(isPresented: $showImgPicker) {
                    ImagePicker(image: $newPfp)
                    
                }.ignoresSafeArea()
                    .onChange(of: newPfp) { oldValue, newValue in
                        if let newPfp = newPfp{
                            userPfp = newPfp
                            
                            settingsManager.pfp = newPfp
                            
                            uploadImageToUserStorage(id: "\(authID)", image: newPfp, file: "Pfp\(authID)")
                        }
                    }
                    .onAppear() {
                        totalHours = 0
                        totalGoal = 0
                        totalHoursEarned = [:]
                        for classroom in classInfoManager.allClasses {
                            totalGoal += classroom.minSpecificHours + classroom.minServiceHours
                        }
                        for request in classInfoManager.allRequests {
                            getClassInfo(classCloudCode: request.classCode) { classroom in
                                
                                if request.accepted && (classroom != nil ? request.timeCreated > classroom!.lastCollectionDate : true) {
                                    //&& request.classCode == classroom.code this causes no hours to be listed
                                    totalHours += request.numHours
                                    
                                    if let classroom = classroom{
                                        if totalHoursEarned[classroom] != nil {
                                            totalHoursEarned[classroom]! += request.numHours
                                            
                                        } else {
                                            totalHoursEarned[classroom] = request.numHours
                                        }
                                    }
                                }
                            }
                        }
                        let LimitedTotalHoursEarned = totalHoursEarned.values.map({ min($0, 2) })
                        //change the min to the classroom min
                        //gets here with totalHoursEarned having 0 values
                        for (hours) in LimitedTotalHoursEarned {
                            points.append(points.last! + CGFloat(hours*360/(totalGoal)))
                        }
                        //                    getUserRequests(email: userID) { requestList in
                        //                        for request in requestList {
                        //
                        //
                        //                            getClassInfo(classCloudCode: request.classCode) { classroom in
                        //                                if let classroom = classroom{
                        //                                    classes.append(classroom)
                        //                                    points.append(CGFloat(points.last + request.numHours*360/100/totalGoal))
                        //                                }
                        //                            }
                        //
                        //                        }
                        //                    }
                        
                        
                        
                        
                    }
                
                Button{
                    // Define receiver before calling generatePDF
                    let receiver = Mail.User(name: "Jonathan Kalsky", email: "jonathan.kalsky@gmail.com")
                    //verlyn.fischer.mobileapp@gmail.com
                    //parker.huang10@k12.leanderisd.org
                    generatePDF(userID: userID) { pdfData, error in
                        if let error = error {
                            // Handle error
                            print("Error generating PDF: \(error.localizedDescription)")
                        } else if let pdfData = pdfData {
                            // Use pdfData
                            sendMail(to: receiver, pdfData: pdfData)
                        }
                    }
                    
                    
                    
                    savePDF(userID: userID)
                    
                }label: {
                    Text("Generate Hour Log")
                }
            }
        }
    }

#Preview {
    Profile()
}
