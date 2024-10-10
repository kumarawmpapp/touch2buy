//
//  OrganizationItemsByPublishedCategoriesRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 6/24/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationItemsByPublishedCategoriesRequest: BaseRequest {
    var orgId:Int!
    var catId:Int!
    var offset:Int!
    
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeOrganizationItemsByPublishedCategories)
    }
    
    override func requestURLString()->String!
    {
        return "organization/publishedcategories/items"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("orgId",orgId), ("catId",catId),("offset",offset),("limit",ApplicationCommonValues.productItemsLimit))
    }
}

class OrganizationItemsByPublishedCategoriesResponse: OrganizationItemsResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrganizationItemsByPublishedCategories
    }
}