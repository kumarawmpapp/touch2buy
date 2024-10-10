//
//  User.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation

class User {
    var username:String!
    var password:String!

    var addresses = [Address]()
    var userId:Int!
    var email:String!
    var mobile:String!
    var firstName:String!
    var middleName:String!
    var lastName:String!
    var name:String {
        var returnedname = ""
        if firstName != nil {
            returnedname.appendContentsOf(firstName)
        }
        if middleName != nil {
            returnedname.appendContentsOf(" "+middleName)
        }
        if lastName != nil {
            returnedname.appendContentsOf(" "+lastName)
        }
        return returnedname
    }
    var gender:String!
    var dateOfBirth:String!
    var country:String!
    var city:String!
}

class Address {
    var addressId:Int!
    var addressLine:String?
    var areaId:Int?
    var areaName:String?
    var city:String?
    var country:String!
    var telephone:String!
    var userId:Int!
    
    var apendedAddress:String {
        var addressString = ""
        if addressLine != nil {
            addressString = addressLine!
        }
        if areaName != nil {
            addressString += "," + areaName!
        }
        if city != nil {
            addressString += "," + city!
        }
        return addressString
    }
    
    
}