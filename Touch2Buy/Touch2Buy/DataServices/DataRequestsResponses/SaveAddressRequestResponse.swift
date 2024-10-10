//
//  SaveAddressRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 5/19/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class SaveAddressRequest: BaseRequest {
    var addressLine:String?
    var areaId:Int?
    var areaName:String?
    var city:String?
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeSaveAddress)
    }
    
    override func requestURLString()->String!
    {
        return "User/address/new"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["addressLine1"] = self.addressLine
        parameterDictionary["areaId"] = self.areaId
        parameterDictionary["areaName"] = self.areaName
        parameterDictionary["city"] = self.city
        parameterDictionary["userId"] = ApplicationSession.sharedInstance.currentUser?.userId
        return parameterDictionary
    }
}

class SaveAddressResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeSaveAddress
    }
    
    override func setDataFromJSONResponse(response:JSON){
        
    }
}
