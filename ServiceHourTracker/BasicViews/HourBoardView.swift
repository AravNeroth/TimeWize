// hourboard views
// ooga booga

import SwiftUI

struct HourBoardView: View {
    
    @State private var animate = false
    @AppStorage("hours") private var hoursEarned = 0
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 20)
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: animate ? CGFloat(hoursEarned) / CGFloat(settingsManager.perfHourRange) : 1) // Assuming maximum 100 hours
                    .stroke(Color.green, lineWidth: 20)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0))
                Text("\(hoursEarned) hours")
                    .font(.title)
            }
            Spacer()
            HStack {
                Button(action: {
                    // Subtract one hour when button is pressed, if hours are greater than 0
                    if self.hoursEarned > 0 {
                        self.hoursEarned -= 1
                    }
                }) {
                    Text("Minus Hour")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
                Button(action: {
                    // Add one hour when button is pressed
                    self.hoursEarned += 1
                }) {
                    Text("Add Hour")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
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
