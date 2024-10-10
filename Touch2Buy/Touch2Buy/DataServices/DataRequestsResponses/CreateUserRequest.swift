//
//  CreateUserRequest.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreateUserRequest: UserRequest {
    var emailforusername: Bool = false
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeCreateUser)
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("firstName",self.user.firstName),("password",self.user.password),("mobile",self.user.mobile),("country", self.user.country),("channel", BaseRequest.channel))
    }
    
    override func requestURLString()->String!
    {
        return "User/new"
    }
}

class CreateUserResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeCreateUser
    }
    
    var statusCode:Int!
    var userId:String!

    override func setDataFromJSONResponse(response:JSON){
        message = response["message"].string
        statusCode = response["statusCode"].intValue
        userId = response["userId"].stringValue
    }
}