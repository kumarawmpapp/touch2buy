//
//  PriceCalculateRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 6/24/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class PriceCalculateRequest: OrderRequest {
    
    override init(){
        super.init(requestType: RequestTypes.RequestTypePriceCalculate)
    }
    
    override func requestURLString()->String!
    {
        return "orders/price/calculate"
    }
}

class PriceCalculateResponse: OrderResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypePriceCalculate
    }
    
    override func setDataFromJSONResponse(response:JSON){
        
    }
}