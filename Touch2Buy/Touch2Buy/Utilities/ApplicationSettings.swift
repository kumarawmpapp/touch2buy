//
//  ApplicationSettings.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/19/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import ChameleonFramework

class ApplicationColor {
    static let Grey = UIColor(hexString:"#e5ffe5")
    static let Green = UIColor(hexString:"#4cb050")
    static let Orange = UIColor(hexString:"#ffb650")
    static let White = UIColor(hexString:"#ffffff")
    static let Purple = UIColor(hexString: "#b9b9b9")
    static let DarkRed = UIColor(hexString:"#8B0000")
    static let Black = UIColor(hexString: "#000000")
    static let Color1 = UIColor(hexString: "#0057aa")
    static let Color2 = UIColor(hexString: "#f58634")
    static let Color3 = UIColor(hexString: "#777777")
    
    static let TextFieldBorderColor = UIColor(hexString: "#8eac8e")
}

class ApplicationFont {
    static let NormalButtonFont = UIFont(name: "CenturyGothic", size: 16)
    static let NormalTabFont = UIFont(name: "CenturyGothic", size: 10)
    static let NormalCheckBoxFont = UIFont(name: "CODE2000", size: 18)
}

class ApplicationFontUnicodes {
    static let checkMark = "\u{2713}"
}

class ApplicationCommonValues {
    static let customerCareNumber = "+94770223348"
    static let productItemsLimit = 20
}

class ApplicationInfo {
    static var applicationVersion: String {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
}