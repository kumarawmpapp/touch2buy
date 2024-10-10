//
//  OrderListRequest.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/11/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderListRequest: BaseRequest {
    let currentUser = ApplicationSession.sharedInstance.currentUser!
    let limit = 20
    var offset = 0
    
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeOrderList)
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        var parameterDictionary = Dictionary<String, AnyObject!>()
        parameterDictionary["userName"] = currentUser.username
        parameterDictionary["offset"] = offset
        parameterDictionary["limit"] = limit
        return parameterDictionary
    }
    
    override func requestURLString()->String!
    {
        return "orders/orderList"
    }
}

class OrderListResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrderList
    }
    
    var recordCount:Int?
    var pageNumber:Int?
    var records = [Order]()
    
    override func setDataFromJSONResponse(response:JSON){
        recordCount = response["recordCount"].int
        pageNumber = response["pageNumber"].int
        
        if let orderArray = response["data"].array {
            for orderJSON:JSON in orderArray {
                let orderObject = Order()
                orderObject.cartId = orderJSON["cartId"].int
                orderObject.deliveryAgent = orderJSON["deliveryAgent"].string
                orderObject.expectedTime = orderJSON["expectedTime"].string
                orderObject.reference = orderJSON["reference"].string
                orderObject.organizationId = orderJSON["organizationId"].int
                orderObject.deliveryCharges = orderJSON["deliveryCharges"].double
                orderObject.deliveredTime = orderJSON["deliveredTime"].string
                orderObject.deliveryOption = orderJSON["deliveryOption"].string
                orderObject.totalValue = orderJSON["totalValue"].double
                orderObject.status = orderJSON["status"].int
                
                orderObject.deliveryAddress = Address()
                orderObject.deliveryAddress?.city = orderJSON["city"].string
                orderObject.deliveryAddress?.addressLine = orderJSON["addressLine1"].string
                orderObject.deliveryAddress?.areaName = orderJSON["addressLine2"].string
                
                if let itemsArray = orderJSON["orders"].array {
                    self.fillJSONResponseToOrderObject(itemsArray, orderObject: orderObject)
                }
                
                records.append(orderObject)
            }
        }
        
    }
    
    func fillJSONResponseToOrderObject(response:[JSON], orderObject:Order){
        for cartItemJSON:JSON in response {
            let product = ProductItem()
            product.discount = cartItemJSON["discount"].double
            product.finalPrice = cartItemJSON["netAmount"].double
            product.foodProductId = cartItemJSON["foodProductId"].int
            product.itemName = cartItemJSON["itemName"].string
            product.originalPrice = cartItemJSON["price"].double
            product.sizeId = cartItemJSON["sizeId"].int

            if let productJSON:JSON = cartItemJSON["product"] {
                product.imageUrl = productJSON["imageUrl"].string
                product.name = productJSON["name"].string
            }
            
            let qty = cartItemJSON["netQty"].intValue
            
            orderObject.orders.append(CartItem(item: product, qty: qty))
        }
    }
}