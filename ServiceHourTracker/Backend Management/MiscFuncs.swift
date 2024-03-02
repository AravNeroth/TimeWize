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
