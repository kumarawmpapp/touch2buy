//
//  DeliveryOptionsRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeliveryOptionsRequest: BaseRequest {
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeDeliveryOptions)
    }
    
    override func requestURLString()->String!
    {
        return "public/delevaryOptions"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary()
    }
}

class DeliveryOptionsResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeDeliveryOptions
    }
    
    var deliveryOptions = [DeliveryOption]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let deliveryOptionsArray = response.array {
            for deliveryOptionJSON:JSON in deliveryOptionsArray {
                deliveryOptions.append(DeliveryOption(id: deliveryOptionJSON["id"].intValue, description: deliveryOptionJSON["description"].stringValue))
            }
        }
    }
}

struct DeliveryOption {
    let id:Int
    let description:String
    
    init(id:Int, description:String){
        self.id=id
        self.description=description
    }
}

