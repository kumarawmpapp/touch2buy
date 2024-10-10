//
//  OrganizationItemsRequest.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/26/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationItemsRequest: BaseRequest {
    var orgId:Int!
    var offset:Int!
    
    
    init(orgId:Int){
        super.init(requestType: RequestTypes.RequestTypeOrganizationItems)
        self.orgId=orgId
    }
    
    override func requestURLString()->String!
    {
        return "organization/items"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("organizationId",orgId),("offset",offset),("limit",ApplicationCommonValues.productItemsLimit))
    }
}

class OrganizationItemsResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrganizationItems
    }
    
    var organizationItems = [ProductItem]()
    var recordCount = 0
    
    
    override func setDataFromJSONResponse(response:JSON){
        if let dataArray = response.array {
            for productJSON:JSON in dataArray {
                let productitem = ProductItem()
                productitem.description = productJSON["description"].string ?? ""
                productitem.imageUrl = productJSON["imageUrl"].string
                productitem.itemId = productJSON["itemId"].intValue
                productitem.itemName = productJSON["itemName"].string
                productitem.organizationId = productJSON["organizationId"].intValue
                
                recordCount = productJSON["recordCount"].intValue
                
                if let subProductsDataArray = productJSON["products"].array {
                    for subProductJSON:JSON in subProductsDataArray {
                        let subProductitem = ProductItem()
                        subProductitem.discount = subProductJSON["discount"].double ?? 0.0
                        subProductitem.itemId = productJSON["itemId"].intValue
                        subProductitem.itemName = productJSON["itemName"].string
                        
                        subProductitem.finalPrice = subProductJSON["finalPrice"].double ?? 0.0
                        subProductitem.foodProductId = subProductJSON["foodProductId"].intValue
                        subProductitem.imageUrl = subProductJSON["imageUrl"].string
                        subProductitem.name = subProductJSON["name"].string
                        subProductitem.originalPrice = subProductJSON["originalPrice"].double ?? 0.0
                        subProductitem.sizeId = subProductJSON["sizeId"].intValue
                        subProductitem.sizeName = subProductJSON["sizeName"].string ?? ""
                        subProductitem.status = subProductJSON["status"].intValue
                        
                        if subProductitem.status == 2 {
                            productitem.products.append(subProductitem)
                        }
                    }
//                    if productitem.products.count > 0 {
                        organizationItems.append(productitem)
//                    }
                }
            }
        }
    }
}