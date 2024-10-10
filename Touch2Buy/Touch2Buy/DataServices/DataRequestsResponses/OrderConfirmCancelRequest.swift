//
//  OrderConfirmCancelRequest.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 1/6/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

enum OrderAction:Int {
    case OrderActionConfirm=2
    case OrderActionCancel=3
}

class OrderConfirmCancelRequest:BaseRequest {
    var action:OrderAction
    
    init( action:OrderAction) {
        self.action=action
        super.init(requestType: RequestTypes.RequestTypeOrderConfirmCancel)
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["cartId"] = ApplicationSession.sharedInstance.cart?.cartId
        parameterDictionary["action"] = action.rawValue
        return parameterDictionary
    }
    
    override func requestURLString()->String!
    {
        return "orders/confirmOrCancel"
    }
}