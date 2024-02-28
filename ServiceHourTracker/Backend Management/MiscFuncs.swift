//
//  MiscFuncs.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
func getEmail() -> String{
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

