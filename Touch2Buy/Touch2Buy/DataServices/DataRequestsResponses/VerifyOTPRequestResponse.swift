//
//  VerifyOTPRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class VerifyOTPRequest: UserRequest {
    init(){
        super.init(requestType: RequestTypes.RequestTypeVerifyOTP)
    }
    
    var mobile:String!
    var otp:String!
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("mobile",self.mobile),("otp",self.otp))
    }
    
    override func requestURLString()->String!
    {
        return "User/verifyOtp"
    }
}

class VerifyOTPResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeVerifyOTP
    }
    
    override func setDataFromJSONResponse(response:JSON){
        message = response["message"].string
        code = response["code"].int
    }
}