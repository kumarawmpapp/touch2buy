//
//  OrderRequest.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/15/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderRequest: BaseRequest {
    var currentShopingCart = ApplicationSession.sharedInstance.cart
    private var currentUser = ApplicationSession.sharedInstance.currentUser!
    private var currentOrg = ApplicationSession.sharedInstance.currentOrganization!
    
    var address:Address?
    var branchId:Int?
    var expectedTime:String?
    var paymentMethod:Int?
    var deliveryCharges:Double?
    var deliveryOption:String?
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeOrderNew)
    }
    
    override init(requestType: RequestTypes) {
        super.init(requestType: requestType)
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["addressLine1"] = address?.addressLine
        parameterDictionary["addressLine2"] = address?.areaName
        parameterDictionary["reference"] = currentOrg.companyRegNumber
        parameterDictionary["organizationId"] = currentOrg.orgId
        parameterDictionary["branchId"] = branchId
        parameterDictionary["channel"] = BaseRequest.channel
        parameterDictionary["city"] = address?.city
        parameterDictionary["communityUser"] = currentUser.username
        parameterDictionary["customerName"] = currentUser.name
        parameterDictionary["customerMobile"] = currentUser.mobile
        parameterDictionary["deliveryCharges"] = deliveryCharges
        parameterDictionary["expectedTime"] = expectedTime
        parameterDictionary["orders"] = self.ordersParameterArray()
        parameterDictionary["paymentOption"] = paymentMethod
        parameterDictionary["deliveryOption"] = deliveryOption
        return parameterDictionary
    }
    
    override func requestURLString()->String!
    {
        return "orders/new"
    }
    
    func ordersParameterArray()->Array<Dictionary<String,AnyObject!>> {
        var ordersArray = [Dictionary<String,AnyObject!>]()
        for cartItem in (currentShopingCart?.getCartItems())! {
            var cartItemDictionary = Dictionary<String, AnyObject!>()
            cartItemDictionary["foodItemId"] = cartItem.cartItemProduct.itemId
            cartItemDictionary["sizeId"] = cartItem.cartItemProduct.sizeId
            cartItemDictionary["quantity"] = cartItem.cartItemQty
            
            ordersArray.append(cartItemDictionary)
        }
        return ordersArray
    }
}

class OrderResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrderNew
    }
    
    var address:Address?
    var branchId:Int!
    var cartId : Int!
    var customerName:String!
    var customerMobile:String!
    var deliveryCharges:Double!
    var deliveryOption:String!
    var expectedTime:String!
    var organizationId:Int!
    var paymentOption:String!
    var reference : String!
    var status:Int!
    var totalDiscount : Double = 0
    var totalNetValue : Double = 0
    var totalValue : Double = 0
    
    
    
    override func setDataFromJSONResponse(response:JSON){
        address = Address()
        address?.addressLine = response["addressLine1"].string ?? ""
        address?.areaName = response["addressLine2"].string ?? ""
        branchId=response["branchId"].int
        cartId=response["cartId"].int
        address?.city = response["city"].string ?? ""
        customerName=response["customerName"].string
        customerMobile=response["customerMobile"].string
        deliveryCharges=response["deliveryCharges"].double ?? 0.0
        deliveryOption=response["deliveryOption"].string
        expectedTime=response["expectedTime"].string ?? ""
        organizationId=response["organizationId"].int
        paymentOption=response["paymentOption"].string
        reference=response["reference"].string
        status=response["status"].int
        totalDiscount=response["totalDiscount"].doubleValue
        totalValue=response["totalValue"].doubleValue
        totalNetValue=response["totalNetValue"].doubleValue
        
    }
}