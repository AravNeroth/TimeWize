//
//  allExtensions.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/9/24.
//

import Foundation
import SwiftUI


extension String {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[\\w.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
        let regex = try! NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }

    func isOnlyWhitespace() -> Bool {
        
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // If the trimmed string is empty, it means the original string contained only whitespace characters
        return trimmed.isEmpty
    }
    
   
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Color {
    func isBright() -> Bool {
        guard let components = cgColor?.components else { return false }

        let red = components[0]
        let green = components[1]
        let blue = components[2]

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue

        return luminance > 0.5
    }
    
    var luminance: Double {
            guard let components = cgColor?.components, components.count >= 3 else { return 0.0 }
            return 0.299 * Double(components[0]) + 0.587 * Double(components[1]) + 0.114 * Double(components[2])
    }
    
    var bright: Bool {
        return luminance > 0.5
    }
}
