//
//  AppObjects.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/10/24.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject{
    static let shared =  SettingsManager()
    @AppStorage("managerMode") var isManagerMode:Bool = false
    @Published var pfp: UIImage = UIImage()
    @Published var perfHourRange = 20
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    @Published var title:String = "Classes"
    @Published var classes: [String] = UserDefaults.standard.stringArray(forKey: "classes") ?? []{
            didSet{
                updateUserDefaults()
            }
    }
    @Published var inClass = false
    @Published var tab: Int = 2
    
    private func updateUserDefaults() {
           UserDefaults.standard.set(classes, forKey: "classes")
       }
    
}


class ClassInfoManager: ObservableObject {
    @Published var classInfo: [Classroom] = []
    @Published var classImages: [String: UIImage] = [:]
    @Published var classPfp: [String: UIImage] = [:]
}

