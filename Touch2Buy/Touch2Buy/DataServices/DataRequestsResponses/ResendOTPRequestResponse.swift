//
//  VerifyOTPRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResendOTPRequest: UserRequest {
    init(){
        super.init(requestType: RequestTypes.RequestTypeResendOTP)
    }
    
    var mobile:String!
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("mobile",self.mobile))
    }
    
    override func requestURLString()->String!
    {
        return "User/resendOtp"
    }
}

class ResendOTPResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeResendOTP
    }
    
    override func setDataFromJSONResponse(response:JSON){
        message = response["message"].string
        code = response["code"].int
    }
}