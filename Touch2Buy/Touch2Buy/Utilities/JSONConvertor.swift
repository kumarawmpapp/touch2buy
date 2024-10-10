//
//  JSONConvertor.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONConvertor {
    class func convertToObject(data:NSData) -> JSON
    {
        return JSON(data: data)
    }
}