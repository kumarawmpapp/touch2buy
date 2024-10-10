//
//  ApplicationSession.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/1/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation

class ApplicationSession {
    static let sharedInstance = ApplicationSession()
    private init(){}
    
    var authToken:String?
    var currentUser:User?
    var currentOrganization:Organization?
    var cart:ShopingCart?
}