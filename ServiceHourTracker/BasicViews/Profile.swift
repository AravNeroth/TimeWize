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
    @AppStorage("authuid") var authID = ""
    @AppStorage("uid") var userID = ""
    @State var load = false
    
    // circle vars
    @State private var totalHours = 0
    @State private var animate = false
    @State private var className = ""
    @State private var isSettingGoal = false // toggles when button to set goals is clocked
    @State private var goalHours: Int? = nil // stores the goal, and passes the value into "circleGoal" when user sets it
    @AppStorage("circleGoal") var circleGoal: Int = 10 // stores goal for circle (this can prob be optimized)
    @State private var requests: [[String:String]] = [] // for the table getRequest
    @State private var isDarkMode = true
    //@State private var percentFull: CGFloat = 0.0
    @State private var acceptedRequests: [Request] = []
    @State private var percentFull: Double? = nil
    @State private var classAndHours = [String: Int]()


        // total hours
        private var totalHoursEarnedValue: Int {
            var total = 0
            for request in acceptedRequests {
                total += request.numHours
            }
            return total
        }
        
        // the percentage of the circle filled
        private var percentFullValue: Double {
            return totalHours != 0 ? Double(totalHours) / Double(circleGoal) : 0.0
        }
        
        // start point for each new circle
        // ex. class 1: 0% -> 20% filled, class 2: 20% --> 65% filled.  startPoint goes from 0 -> 20 -> 65
        private var startPoints: [Double] {
            var points: [Double] = []
            var currentPoint = 0.0
            for request in acceptedRequests {
                let percentage = Double(request.numHours) / Double(totalHours)
                points.append(currentPoint)
                currentPoint += percentage
            }
            return points
        }

    var body: some View {
        if load{
            
            LoadingScreen()
                .onAppear{
                    load = false
                }
            
            
        }else{
        
            ZStack{ // start of upper pfp & banner area
                
            ScrollView {
                
                Spacer(minLength: 170)

                HStack {
                    Text("Goal: \(circleGoal) hours")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.mint))
                        .padding(.horizontal, 20)

                    Spacer()
                    
                    Button(action: {
                        // reveal goal setting alert
                        isSettingGoal.toggle()
                    }) {
                        Text("Set Goal")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                    }
                    .padding(.trailing, 20)
                    
                } // end of goal-setting & display
                
                    Spacer(minLength: 35)
                    
                    ZStack { 
                        // circle display
//                        let circleW = 305.0
//                        let circleH = 305.0

                        /*
                         ORGANIZATION
                         
                         from accepted Requests- class codes, class color, hours earned
                         
                         inside circle: [total hours from all accepted requests / circleGoal]
                         
                         allClassCodes = amt enrolled classes + all class codes
                         
                         for each class: new Circle() filled with [ classHours / total hours from all accepted requests ]
                         
                         var percentFill = how much is filled
                         
                         
                         proccess- fetch all data, new linked list with class code:hours
                         this is so that multiple requests from the same class get the hours updated rather than re-written
                         
                         
                         Circle()
                             .trim(from: 0/360, to: 60/360)
                             .stroke(.blue, lineWidth: 26.5)
                             .rotationEffect(Angle(degrees: -90))
                             .frame(width: circleW, height: circleH)
                         
                         */
                        
                      
                        // Circle display
                        let circleSize = CGSize(width: 305, height: 305)
                        let keysArray = Array(classAndHours.keys)
                        var startPoint = 0.0
                        
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 26.5)
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: circleSize.width, height: circleSize.height)
                       
                    .padding(.top, 20)
                
                            ForEach(keysArray) { request in

                                Circle()
                                // circle starts at 0, and then fills till the current request's number of hours divided by total hours
                                    .trim(from: startPoint, to: CGFloat(startPoint + (Double(classAndHours[keysArray]) / Double(totalHours))))
                                    .stroke(Color.red, lineWidth: 26.5)
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: circleSize.width, height: circleSize.height)
                                                
                            startPoint += CGFloat(Double(classAndHours[keysArray]) / Double(totalHours))
                        }
                        
                    }
                                        
                    Spacer(minLength: 85)
                    NewHourBoardView(totalHoursEarned: $totalHoursEarned)
                }
                
                
                //            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height )
                .refreshable {
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                    load = true
                    
                    
                } // start of banner
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
                
                
            } // end of upper pfp & banner area
            .ignoresSafeArea()
            
            
            
            
            
            // color pallet + pfp
            
            .sheet(isPresented: $colorPaletteSheet) {
                UserColorPalette(showPop: $colorPaletteSheet, refresh: $refresh)
                    .onDisappear() {
                        colorPaletteSheet = false
                    }
            }
            
            // for setting goal toggle
            .sheet(isPresented: $isSettingGoal) {
                    GoalSettingView(isSettingGoal: $isSettingGoal, goalHours: $goalHours)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
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
                    
                    
                    for classroom in classInfoManager.allClasses {
                        for request in classInfoManager.allRequests {
                            if request.accepted && request.classCode == classroom.code {
                                if totalHoursEarned[classroom] != nil {
                                    totalHoursEarned[classroom]! += request.numHours
                                } else {
                                    totalHoursEarned[classroom] = request.numHours
                                }
                            }
                        }
                    }
                    
                    
                    // for circle
                    
                    getAcceptedRequests(email: userID) { requests in
                        for request in requests {
                            acceptedRequests.append(request)
                            totalHours += (request.numHours)
                            
                            /* 
                             dictionary classAndHours keeps key of class code and value of total hours in that class
                             
                             this checks if the class of the current request is present in this list, and if it is, add the hours
                             of the current request to the existing hours of the class.
                             
                             if the class is not present in the list of keys, then it adds it.
                             
                             this dictionary is used for the circle bc it makes sure all the hours for a class is gathered
                             */
                            if classAndHours.contains(where: { $0.key == request.classCode }) {
                                // 9999 is there so that if it hits an error here we know where
                                classAndHours.updateValue(((classAndHours[request.classCode] ?? 9999) + request.numHours), forKey: request.classCode)
                            } else {
                                classAndHours[request.classCode] = request.numHours
                            }
                        }
                        
                    }
                    
                }
            
            // send hours
            
            Button{
                // Define receiver before calling generatePDF
                let receiver = Mail.User(name: "Jonathan Kalsky", email: "jonathan.kalsky@gmail.com")
//verlyn.fischer.mobileapp@gmail.com
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

// set hour goal
struct GoalSettingView: View {
    @Binding var isSettingGoal: Bool
    @Binding var goalHours: Int?
    @FocusState private var isTextFieldFocused: Bool
    @EnvironmentObject private var settingsManager: SettingsManager
    @State private var enteredGoal: String = ""
    @State private var tempGoal: Int?
    @AppStorage("circleGoal") var circleGoal: Int = 10
    var body: some View {
        VStack {
            Text("Enter an Hour Goal")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .frame(width: 350, alignment: .center)
            
            TextField("Enter Goal", text: $enteredGoal)
                .keyboardType(.numberPad)
                .padding()
                .focused($isTextFieldFocused)
                .onAppear {
                    isTextFieldFocused = true
                }
                .background(Color.green.opacity(0.45))
                .cornerRadius(15)
            
            
            Button("Set Goal") {
                if let goal = Int(enteredGoal) {
                    goalHours = goal
                    settingsManager.perfHourRange = goal
                    circleGoal = goal
                    
                    isSettingGoal = false

                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(15)
            
        }
        
        .padding()
        
    }
}


#Preview {
    Profile()
}

