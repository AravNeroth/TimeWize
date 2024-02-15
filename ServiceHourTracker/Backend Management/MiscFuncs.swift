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


