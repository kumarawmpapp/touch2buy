//
//  PaymentMethodsRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class PaymentMethodsRequest: BaseRequest {
    
    init(){
        super.init(requestType: RequestTypes.RequestTypePaymentMethods)
    }
    
    override func requestURLString()->String!
    {
        return "public/paymentMethods"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary()
    }
}

class PaymentMethodsResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypePaymentMethods
    }
    
    var paymentMethods = [PaymentMethod]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let paymentMethodsArray = response.array {
            for payMethodJSON:JSON in paymentMethodsArray {
                paymentMethods.append(PaymentMethod(id: payMethodJSON["id"].intValue, description: payMethodJSON["description"].stringValue))
            }
        }
    }
}

class AvailableChannelPayMethodsRequest: BaseRequest {
    
    var branchId:Int?
    
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeChannelPayMethods)
    }
    
    override func requestURLString()->String!
    {
        return "organization/availableChannelPayMethods"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["branchId"] = self.branchId
        parameterDictionary["channelId"] = BaseRequest.channelID
        return parameterDictionary
    }
}

class AvailableChannelPayMethodsResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseChannelPayMethods
    }
    
    var paymentMethods = [PaymentMethod]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let paymentMethodsArray = response.array {
            for payMethodJSON:JSON in paymentMethodsArray {
                paymentMethods.append(PaymentMethod(id: payMethodJSON["id"].intValue, description: payMethodJSON["description"].stringValue))
            }
        }
    }
}

struct PaymentMethod {
    let id:Int
    let description:String
    
    init(id:Int, description:String){
        self.id=id
        self.description=description
    }
}

struct PaymentMethods {
    static let Visa = PaymentMethod(id: 1, description: "Visa")
    static let MasterCard = PaymentMethod(id: 2, description: "Master Card")
    static let AmericanExpress = PaymentMethod(id: 3, description: "American Express")
    static let MobitelMCash = PaymentMethod(id: 4, description: "Mobitel M Cash")
    static let DialogEzCash = PaymentMethod(id: 5, description: "Dialog EzCash")
    static let PayOnDelevary = PaymentMethod(id: 6, description: "Pay On Delevary")
    static let PayOnPickup = PaymentMethod(id: 7, description: "Pay On Pickup")
    
    static let allPaymentMethods = [AmericanExpress, DialogEzCash, MasterCard, MobitelMCash, PayOnDelevary, PayOnPickup, Visa]
}