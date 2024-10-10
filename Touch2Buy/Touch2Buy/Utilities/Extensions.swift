//
//  Extensions.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func urlString()->String?{
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}

extension Double {
    var priceString:String {
        get {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.currencySymbol = "Rs "
            return formatter.stringFromNumber(self)!
        }
    }
}

extension Dictionary {
    func keyvalueString() -> String {
        var returendString = ""
        for (key, value) in self {
            returendString.appendContentsOf("\(key)=\(value),")
        }
        return returendString
    }
}

extension UIScreen {
    class func HeightEqual480() -> Bool {
        if UIScreen.mainScreen().bounds.height == 480 {
            return true
        }
        return false
    }
    
    class func HeightEqual568() -> Bool {
        if UIScreen.mainScreen().bounds.height == 568 {
            return true
        }
        return false
    }
}