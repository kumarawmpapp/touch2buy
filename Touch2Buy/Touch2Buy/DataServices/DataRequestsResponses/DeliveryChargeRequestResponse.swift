//
//  DeliveryChargeRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 5/20/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeliveryChargeRequest: BaseRequest {
    var address:Address?
    var order:OrderRequest?
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeDeliveryCharge)
    }
    
    override func requestURLString()->String!
    {
        return "delivaries/charging"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["address"] = (address?.areaName ?? "") + "," + (address?.city ?? "")
        parameterDictionary["branchId"] = self.order?.branchId
        parameterDictionary["orgId"] = ApplicationSession.sharedInstance.currentOrganization?.orgId
        parameterDictionary["toLocationId"] = address?.areaId
        parameterDictionary["totalNetValue"] = self.order?.currentShopingCart?.calculatedNetTotal
        parameterDictionary["totalValue"] = self.order?.currentShopingCart?.calculatedSubTotal
        parameterDictionary["orders"] = self.order?.ordersParameterArray()
        return parameterDictionary
    }
}

class DeliveryChargeResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeDeliveryCharge
    }
    
    var distance:Double!
    var discountedValue:Double!
    var rejectReason:String!
    var status:Int!
    
    override func setDataFromJSONResponse(response:JSON){
        distance = response["distance"].double ?? 0.0
        discountedValue = response["discountedValue"].double ?? 0.0
        rejectReason = response["rejectReason"].string ?? ""
        status = response["status"].intValue
    }
}