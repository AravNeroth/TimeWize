//
//  MiscFuncs.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import SwiftSMTP


//            Button{
//                sendMail(to: Mail.User(name: "Night Wielder", email: "2findmyemail@gmail.com"))
//            }label: {
//                Text("Send Mail")
//            }
//        }
//
//    }
//https://www.youtube.com/watch?v=rDQ5ENvJxyc

func sendMail(to receiver: Mail.User, pdfData: Data) {
    
    let fileAttachment = Attachment(data: pdfData, mime: "application/pdf", name: "Hour Log")

    let smtp = SMTP(
        hostname: "smtp.gmail.com",     // SMTP server address
        email: "noreply.Timewize@gmail.com",        // username to login
        password: "kazv khiq dqzl yvvi"            // password to login
    )
    
    let me = Mail.User(
        name: "TimeWize",
        email: "TestWize.test@gmail.com"
    )
    
    let mail = Mail(
        from: me,
        to: [receiver],
        subject: "TimeWize Community Hour Log.",
        text: "",
        attachments: [fileAttachment]
    )
    
    smtp.send(mail) { (error) in
        if let error = error {
            print(error)
            
        } else {
            
        }
    }
}

func generatePDF(userID: String, completion: @escaping (Data?, Error?) -> Void) {
    getUserRequests(email: "jonathan.cs@gmail.com") { requests in
        var titleContent = "Time Wize Hour Log Report\n\n"
        var content = ""
        let dispatchGroup = DispatchGroup() // Create a dispatch group
        var name = ""
        getName(email: userID) {  usnm in
            
            name = usnm
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let currYear: String = dateFormatter.string(from: Date())
        
        for (index, request) in requests.enumerated() {
            dispatchGroup.enter() // Enter the dispatch group
            
            let date = request.timeCreated.formatted(date: .numeric, time: .omitted)
            
            let classCode = request.classCode
            let description = request.description
            let hours = "\(request.numHours) hours"
            let numbers = ""
            
           
            // Construct the line with headers and details
            getClassInfo(classCloudCode: classCode) { classroom in
                if let classroom = classroom {
                    let className = classroom.title
                    let line = "\(date)\t\(className.padding(toLength: 20, withPad: " ", startingAt: 0))\t\t\t\t\t\t\(hours.padding(toLength: 15, withPad: " ", startingAt: 0))\nDescription: \(description)\n\n"
                    
                    // Append the line to content
                    content += line
                }
                
                
                
                dispatchGroup.leave() // Leave the dispatch group once the operation is complete
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // All asynchronous operations have completed
            
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
            UIGraphicsBeginPDFPage()
            
            // Draw the title content with increased text size
            let titleBounds = CGRect(x: 36, y: 36, width: 8.5 * 72.0 - 2 * 36, height: CGFloat.greatestFiniteMagnitude)
            let titleFont = UIFont.systemFont(ofSize: 26, weight: .bold)
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
            let attributedTitleContent = NSAttributedString(string: titleContent, attributes: titleAttributes)
            let titleHeight = attributedTitleContent.boundingRect(with: titleBounds.size, options: .usesLineFragmentOrigin, context: nil).height
            attributedTitleContent.draw(with: titleBounds, options: .usesLineFragmentOrigin, context: nil)
            
            let subTitleBounds = CGRect(x: 36, y: 36 + titleHeight, width: 8.5 * 72.0 - 2 * 36, height: 11.0 * 72.0 - 2 * 36 - titleHeight)
            let subtitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
            let subTitleAttributes: [NSAttributedString.Key: Any] = [.font: subtitleFont]
            let attributedsubTitleContent = NSAttributedString(string: "\(name) \(currYear)", attributes: subTitleAttributes)
            let subTitleHeight = attributedsubTitleContent.boundingRect(with: subTitleBounds.size, options: .usesLineFragmentOrigin, context: nil).height
            attributedsubTitleContent.draw(with: subTitleBounds, options: .usesLineFragmentOrigin, context: nil)
            
            // Draw the content with regular text size below the title
            let contentBounds = CGRect(x: 36, y: 36 + titleHeight + subTitleHeight, width: 8.5 * 72.0 - 2 * 36, height:  11.0 * 72.0 - 2 * 36 - (titleHeight + subTitleHeight))
            let contentFont = UIFont.systemFont(ofSize: 12)
            let contentAttributes: [NSAttributedString.Key: Any] = [.font: contentFont]
            let attributedContent = NSAttributedString(string: content, attributes: contentAttributes)
            
            attributedContent.draw(with: contentBounds, options: .usesLineFragmentOrigin, context: nil)
            
            UIGraphicsEndPDFContext()
            
            completion(pdfData as Data, nil) // Call completion handler with PDF data
        }
    }
}








@MainActor func savePDF(userID: String) {
    let fileName = "GeneratedPDF.pdf"
    
    generatePDF(userID: userID) { pdfData, error in
        if let error = error {
            print("Error generating PDF: \(error.localizedDescription)")
            return
        }
        
        guard let pdfData = pdfData else {
            print("No PDF data generated.")
            return
        }
        
        if let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let documentURL = documentDirectories.appendingPathComponent(fileName)
            do {
                try pdfData.write(to: documentURL)
                
                // Set documentUrl
                documentUrl = documentURL // Assigning the value directly
            } catch {
                print("Error saving PDF: \(error.localizedDescription)")
            }
        }
    }
}


private var documentUrl: URL?// State variable to hold document URL


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
    
    if hex == "\(.green6 as Color)"{
        
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

func refreshVars(messageManager: MessageManager, classInfoManager: ClassInfoManager, completion: ((Bool) -> Void )? = nil ) {
//    @EnvironmentObject var settingsManager: SettingsManager
//    @EnvironmentObject var classInfoManager: ClassInfoManager
//    @EnvironmentObject var messageManager: MessageManager
    @AppStorage("uid") var userID = ""
   
   
    let DG = DispatchGroup()
    
    if userID != "" {
        
        DG.enter()
        DG.enter()
        DG.enter()
        
        messageManager.updateData(userID: userID){ _ in
            DG.leave()
            print("left message")
        }
        classInfoManager.updateManagerData(userID: userID){ _ in
            DG.leave()
            print("left manager")
        }
        classInfoManager.updateData(userID: userID){ _ in
            DG.leave()
            print("left student")
        }
        
        
    }
    DG.notify(queue: .main){
        completion?(userID != "")
    }
   
}
