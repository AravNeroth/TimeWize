// hourboard views
// ooga booga

import SwiftUI

struct HourBoardView: View {
    
    @State private var animate = false
    
    @State private var totalHoursEarned = 0 // Removed @State
    @State private var className = ""
    @State private var classDescription = ""
    
    @State private var goalHours: Int? = nil
    @State private var isSettingGoal = false
    @AppStorage("range") var range: Int = 0
    @AppStorage("uid") var userID: String = ""
    @State private var requests: [[String:String]] = [] // for the table getRequest
    @State private var isDarkMode = true
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HStack {
                Text("Goal: \(range) hours")
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
                    .trim(from: 0, to: animate ? CGFloat(totalHoursEarned) / CGFloat(range ?? settingsManager.perfHourRange) : 1)
                    .stroke(Color.green, lineWidth: 20)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5))
                Text("\(totalHoursEarned) hours") // Display total hours earned
                    .font(.title)
            }
            .padding(.top, 20)
            
            // display from func getClassHoursField
            Spacer()
            List(requests, id: \.self) { request in
                VStack(alignment: .center) {
                    Text(request["className"] ?? "")
                    Text("\(request["hours"] ?? "") hours")
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
            Spacer()
        }
        .sheet(isPresented: $isSettingGoal) {
            GoalSettingView(isSettingGoal: $isSettingGoal, goalHours: $goalHours) // Corrected the order
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
        }
        .onAppear {
            // Fetch class hours for the current user
            getClassHoursField(email: userID) { classHours in
                if let classHours = classHours {
                    // Update the requests array with the fetched data
                    self.requests = classHours
                    // Calculate total hours earned
                    self.totalHoursEarned = classHours.reduce(0) { $0 + (Int($1["hours"] ?? "") ?? 0) }
                } else {
                    // Handle case where class hours couldn't be fetched
                    print("Failed to fetch class hours.")
                    // You can display an error message or handle it in any other appropriate way
                }
            }
            // Start animation
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
    @EnvironmentObject private var settingsManager: SettingsManager
    @State private var enteredGoal: String = ""
    @State private var tempGoal: Int?
    @AppStorage("range") var range: Int = 0
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
                    settingsManager.perfHourRange = goal
                    range = goal
                    
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
