//
//  UserLoginRequest.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserLoginRequest: UserRequest {
    init(){
        super.init(requestType: RequestTypes.RequestTypeLoginUser)
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("userName",self.user.username),("password",self.user.password),("channel",BaseRequest.channel))
    }
    
    override func requestURLString()->String!
    {
        return "User/login"
    }
}

class UserLoginResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeLoginUser
    }
    var authToken:String?
    var user:User?
    var loginStatus:Int?
    
    override func setDataFromJSONResponse(response:JSON){
        self.loginStatus = response["loginStatus"].int
        self.message = response["message"].string
        
        if self.loginStatus == 1 {
            self.authToken = response["authToken"].string
            self.setUserFromJSON(response["user"])
        }
    }
    
    func setUserFromJSON(jsonresponse:JSON){
        self.user = User()
        
        let user = User()
        
        user.email = jsonresponse["email"].string
        user.firstName = jsonresponse["firstName"].string
        user.lastName = jsonresponse["lastName"].string
        user.middleName = jsonresponse["middleName"].string
        user.userId = jsonresponse["userId"].int
        user.country = jsonresponse["country"].string
        user.mobile = jsonresponse["mobile"].string
        
        if let addressarray = jsonresponse["addresses"].array {
            for addressJSON:JSON in addressarray {
                let adress = Address()
                adress.addressId = addressJSON["addressId"].intValue
                adress.addressLine = addressJSON["addressLine1"].stringValue
                adress.areaId = addressJSON["areaId"].intValue
                adress.areaName = addressJSON["areaName"].stringValue
                adress.city = addressJSON["city"].stringValue
                adress.country = addressJSON["country"].stringValue
                
                user.addresses.append(adress)
            }
        }
        
        
        
        self.user = user
    }
}