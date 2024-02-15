// hourboard views
// ooga booga

import SwiftUI

struct HourBoardView: View {
    
    @State private var animate = false
    
    @State private var totalHoursEarned = 0
    @State private var className = ""
    @State private var classDescription = ""
    
    @State private var goalHours: Int? = nil
    @State private var isSettingGoal = false

    @AppStorage("uid") var userID: String = ""
    @State private var requests: [[String:String]] = [] // for the table getRequest
    @State private var isDarkMode = true
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HStack {
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
                        }
                        
                Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 20)
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: animate ? CGFloat(totalHoursEarned) / CGFloat(goalHours ?? settingsManager.perfHourRange) : 1)
                    .stroke(Color.green, lineWidth: 20)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5))
                Text("\(totalHoursEarned) hours")
                    .font(.title)
            }
            .padding(.top, 20)
            
           
            List(requests, id: \.self) { request in
                           VStack(alignment: .leading) {
                               Text("Class: \(className)")
                               Text("Hours: \(request["hours"] ?? " Error: Could Not Retrieve Hours")")
                               Text("Description: \(classDescription)")
                           }
                
                           .padding()
                           .background(isDarkMode ? Color.green : Color.mint)
                           .cornerRadius(10)
                           .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 1)
                           )
                       }
            
                       .padding(.horizontal)
                       Spacer()
            
                   }
        
        .sheet(isPresented: $isSettingGoal) {
            GoalSettingView(isSettingGoal: $isSettingGoal, goalHours: $goalHours) // Corrected the order
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
        }
                   .onAppear {
                       // Fetch data from Firestore when the view appears
                       let userDocument = db.collection("userInfo").document(userID)
                       userDocument.getDocument { document, error in
                           if let document = document, document.exists {
                               if let classes = document.data()?["classes"] as? [String] {
                                   for classCode in classes {
                                       getRequest(classCode: classCode) { fetchedRequests in
                                           // Append fetched requests to the existing requests array
                                           requests.append(contentsOf: fetchedRequests)
                                           
                                           // Calculate total hours earned
                                           for request in fetchedRequests {
                                               if let hoursString = request["hours"],
                                                  let hours = Int(hoursString) {
                                                   totalHoursEarned += hours
                                               }
                                               
                                               // Store type in className and desc in classDescription
                                               className = request["type"] ?? ""
                                               classDescription = request["description"] ?? ""
                                           }
                                       }
                                   }
                               }
                           } else {
                               print("User document does not exist")
                           }
                       }
                       
                       animate = true
                   }
                   .padding()
               }
           }

struct HourBoardView_Previews: PreviewProvider {
    static var previews: some View {
        HourBoardView()
    }
}

struct GoalSettingView: View {
    @Binding var isSettingGoal: Bool
    @Binding var goalHours: Int?
    @FocusState private var isTextFieldFocused: Bool

    @State private var enteredGoal: String = ""
    @State private var tempGoal: Int?

    var body: some View {
        VStack {
            Text("Enter an Hour Goal")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.green))
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
