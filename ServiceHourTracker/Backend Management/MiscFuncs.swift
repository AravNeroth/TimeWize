//
//  MiscFuncs.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

func getEmail() -> String {
    var out = ""
    if let email = Auth.auth().currentUser?.email{
        out = email
    }else{
       out = "not signed in"
    }
    return out
}

func countDown(time: Double, variable: Binding<Bool>){
    Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
        variable.wrappedValue = false
    }
}

//has date in form of M/d/year -> ex: 2/15/2024 <-  note: M/d/yy  ex: 2/15/24
//has date passed compared to current Date
func hasDatePassed(date: String)->Bool{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yyyy"
    dateFormatter.timeZone = TimeZone(identifier: "America/Chicago")
    
    if let selectedDate = dateFormatter.date(from: date){
        
        if selectedDate.compare(dateFormatter.date(from: dateFormatter.string(from: Date()))!) == .orderedSame{
            return false
        }else{
            return selectedDate.compare(dateFormatter.date(from: dateFormatter.string(from: Date()))!) == .orderedAscending

        }
        //false if input is later than current date or same AKA our date hasnt passed it
        //true if input is earlier than current date AKA our date has passed the input date
    }
    return true
    //something wrong with passed in date
}

func colorToHex(color: Color) -> String{
    let uiColor = UIColor(color)
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
                
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let redInt = Int(red * 255)
    let greenInt = Int(green * 255)
    let blueInt = Int(blue * 255)
    
    let hexString = String(format: "%02X%02X%02X", redInt, greenInt, blueInt)
    return hexString //returns hex without #
}

func hexToColor(hex: String) -> Color{
    print(hex)
    if hex == "\(.green6 as Color)"{
        print("green6")
        return .green6
    }
    if hex == "" {
        return .white
    }
    
    var hexD = hex
    if hex.hasPrefix("#"){
        hexD = String(hex.dropFirst())
    }
    let red = hexD.prefix(2)
    let redNum = Double(Int(red, radix: 16)!) / 255
    let green = hexD.prefix(4).suffix(2)
    let greenNum = Double(Int(green, radix: 16)!) / 255
    let blue = hexD.suffix(2)
    let blueNum = Double(Int(blue, radix: 16)!) / 255
    
    return Color(red: redNum, green: greenNum, blue: blueNum)

}


//Example:
//if colors.contains(where: {$0 != .white}) {
//dominantColor = mostDominantColor(in: colors) ?? .blue
//
//}else if colors.allSatisfy({$0 == .white}){
//dominantColor = .blue
//}
func mostDominantColor(in colors: [Color]) -> Color? {
    guard !colors.isEmpty else { return nil }

    // Use a dictionary to store color frequencies
    var colorFrequencies: [Color: Int] = [:]

    // Count the occurrences of each color
    for color in colors {
        colorFrequencies[color, default: 0] += 1
    }

    // Find the color with the maximum frequency
    if let (dominantColor, _) = colorFrequencies.max(by: { $0.value < $1.value }) {
        return dominantColor
    }

    return nil
}

func darkestColor(in colors: [Color]) -> Color? {
    guard let firstColor = colors.first else { return nil }

    var darkestColor = firstColor
    var darkestLuminance = firstColor.luminance

    for color in colors {
        let luminance = color.luminance
        if luminance < darkestLuminance {
            darkestColor = color
            darkestLuminance = luminance
        }
    }

    return darkestColor
}

func isDarkModeEnabled() -> Bool {
    if UITraitCollection.current.userInterfaceStyle == .dark {
        return true
    } else {
        return false
    }
}

func formatDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: today)!
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM d"
    
    if calendar.isDate(date, inSameDayAs: yesterday) {
        dateFormatter.dateFormat = "'Yesterday', h:mm a"
    } else if calendar.isDate(date, inSameDayAs: today) {
        dateFormatter.dateFormat = "h:mm a"
    } else if calendar.isDate(date, inSameDayAs: tomorrow) {
        dateFormatter.dateFormat = "'Tomorrow', h:mm a"
    } else if calendar.isDate(date, inSameDayAs: today) || calendar.isDate(date, inSameDayAs: endOfWeek) || (date > today && date < endOfWeek) {
        dateFormatter.dateFormat = "EEEE"
    }
    return dateFormatter.string(from: date)
}

//func callGeneratePDFAction() {
//    var contentView = ContentView()
//        contentView.generatePDFAction = {
//            print("generatePDFAction triggered")
//
//            contentView.generatePDFButtonTapped()
//        }
//        // Call the generate PDF action from another class
//        contentView.generatePDFAction?()
//    }
