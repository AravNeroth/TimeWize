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
    //    @State var totalHoursEarned: [Classroom:Int] = [:]
    //    @State var minHours: [Classroom: Int] = [:]
    //    @State var totalHours = 0
    //    @State var totalGoal = 0
    //    @State var points: [CGFloat] = [0]
    @State var classes: [Classroom] = []
    @AppStorage("authuid") var authID = ""
    @AppStorage("uid") var userID = ""
    @State var load = false
    
    var body: some View {
        
        
        ZStack{
            if load{
                
                LoadingScreen()
                    .onAppear{
                        
                        refreshVars(settingsManager: settingsManager, messageManager: messageManager, classInfoManager: classInfoManager){ _ in
                            load = false
                        }
                        
                        
                    }
                
                
            }else{
                ScrollView {
                    Spacer(minLength: 212.5)
                    
                    
                    ZStack {
                        Circle()
                            .fill(.black)
                        Circle()
                            .fill(.gray.opacity(0.3))
                            .overlay(
                                Text("\(classInfoManager.totalHours) Hours")
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
                        
                        if classInfoManager.totalHoursEarned.keys.count > 1 {
                            ForEach(0 ..< classInfoManager.totalHoursEarned.keys.count , id: \.self) { ind in                                if ind + 1 < classInfoManager.points.count {
                                    let currentPoint = classInfoManager.points[ind]
                                    let nextPoint = classInfoManager.points[ind+1] //ind+1
                                    if classInfoManager.totalHoursEarned[Array(classInfoManager.totalHoursEarned.keys)[ind]] != 0 {
                                        Circle()
                                            .trim(from: currentPoint/360, to: nextPoint/360)
                                            .stroke(
                                                LinearGradient(
                                                    colors: classInfoManager.classColors[Array(classInfoManager.totalHoursEarned.keys)[ind]] ?? settingsManager.userColors,
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
                            
                        }
                    }.padding(.horizontal, 50)
                    Spacer(minLength: 100)
                    NewHourBoardView(totalHoursEarned: $classInfoManager.totalHoursEarned).padding(.bottom, 7)
                    
                    
                    // MARK: Button to call email generation !do not delete as scrap! unless out of use
                    
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
                    }.padding(.bottom, 7)
                    
                }
                .refreshable {
                    load = true
                }
            }
            VStack{
                
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing)).shadow(radius: 3, y: 2)
                    .padding(.horizontal, 0)
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .top)
                    .overlay(
                        ZStack{
                            
                            VStack{
                                
                                
                                
                                HStack(alignment: .bottom){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(LinearGradient(colors: settingsManager.userColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .rotationEffect(Angle(degrees: -90))
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
                                                            Circle().frame(width: 25,height: 25).foregroundStyle(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                                .rotationEffect(Angle(degrees: -90))
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
                                }
                                .padding(.top, 130)
                                .padding(.bottom, UIScreen.main.bounds.height*60/2500)
                                
                            }
                            
                            
                            
                            HStack{
                                
                                Text(settingsManager.displayName)
                                
                                    .padding(.leading, 95)
                                    .bold()
                                
                                    .font(
                                        .system(
                                            size: CGFloat(28 + (28/settingsManager.displayName.count)*(10-settingsManager.displayName.count)),
                                            weight: .bold,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(settingsManager.userColors.first!.isBright() ? .black : .white)
                                
                                
                                Button{
                                    colorPaletteSheet = true
                                    
                                }label: {
                                    Image(systemName: "paintpalette.fill").resizable().scaledToFill().frame(width: 25, height: 25).foregroundStyle(.white).padding(.horizontal, 10)
                                }
                                Button{
                                    settingsManager.tab = 3
                                }label: {
                                    Image(systemName: "gearshape.fill").resizable().scaledToFit().frame(width: 25, height: 25)
                                }.padding(.horizontal, 17).foregroundStyle(.white)
                                
                            }
                            .padding(.vertical, 75)
                            
                        }
                        
                        
                    )

                    .frame(height: 225)
                    .frame(height: 190)
                Spacer()
            }
            
//            .ignoresSafeArea(edges: .top)
            
        }
        .ignoresSafeArea(edges: .top)
        
        
        
        
        
        
        .sheet(isPresented: $colorPaletteSheet) {
            UserColorPalette(showPop: $colorPaletteSheet, refresh: $refresh)
                .onDisappear() {
                    colorPaletteSheet = false
                }
        }
        .sheet(isPresented: $showImgPicker) {
            ImagePicker(image: $newPfp)
                .ignoresSafeArea(edges: .bottom)
        }.ignoresSafeArea()
            .onChange(of: newPfp) { oldValue, newValue in
                if let newPfp = newPfp{
                    userPfp = newPfp
                    
                    settingsManager.pfp = newPfp
                    
                    uploadImageToUserStorage(id: "\(authID)", image: newPfp, file: "Pfp\(authID)")
                }
            }
        /*
         .onAppear() {
         let DG = DispatchGroup()
         DG.enter()//allClasses
         DG.enter()//allrequests
         minHours = [:]
         totalHours = 0
         totalGoal = 0
         totalHoursEarned = [:]
         for classroom in classInfoManager.allClasses {
         totalGoal += classroom.minSpecificHours + classroom.minServiceHours
         minHours[classroom] = classroom.minServiceHours+classroom.minSpecificHours
         if classroom == classInfoManager.allClasses.last{
         DG.leave()//allClasses
         }
         }
         for request in classInfoManager.allRequests {
         DG.enter()//getClassInfo
         getClassInfo(classCloudCode: request.classCode) { classroom in
         
         if request.accepted && (classroom != nil ? request.timeCreated > classroom!.lastCollectionDate : true) {
         //&& request.classCode == classroom.code this causes no hours to be listed
         totalHours += request.numHours
         
         if let classroom = classroom{
         if totalHoursEarned[classroom] != nil {
         totalHoursEarned[classroom]! += request.numHours
         DG.leave()//getClassInfo
         } else {
         totalHoursEarned[classroom] = request.numHours
         DG.leave()//getClassInfo
         }
         }
         }else{
         DG.leave()//getClassInfo
         }
         }
         if request == classInfoManager.allRequests.last {
         DG.leave()//allRequests
         }
         }
         
         //                        let LimitedTotalHoursEarned = totalHoursEarned.values.map({ min($0, minHours[$0]) })
         //change the min to the classroom min
         //gets here with totalHoursEarned having 0 values
         DG.notify(queue: .main) {
         for (classroom) in totalHoursEarned.keys {
         if let hours = totalHoursEarned[classroom] {
         if hours > minHours[classroom] ?? 0{
         points.append(points.last! + CGFloat((minHours[classroom] ?? 0)*360/(totalGoal)))
         }else{
         points.append(points.last! + CGFloat(hours*360/(totalGoal)))
         }
         }
         }
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
         */
        
    }
}


#Preview {
    Profile()
}
