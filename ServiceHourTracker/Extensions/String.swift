//
//  String.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/18/24.
//

import Foundation

extension String {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
        let regex = try! NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
}
