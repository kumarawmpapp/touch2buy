//
//  OrganizationItemsCategoriesRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 6/24/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationItemsCategoriesRequest: BaseRequest {
    var orgId:Int!
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeOrganizationItemsCategories)
    }
    
    override func requestURLString()->String!
    {
        return "organization/publishedCategories"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("orgId",orgId),("offset","0"),("limit","0"))
    }
}

class OrganizationItemsCategoriesResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrganizationItemsCategories
    }
    
    var organizationItemsCategories = [ProductCategory]()
    
    
    override func setDataFromJSONResponse(response:JSON){
        if let cateogoriesArray = response["data"].array {
            for categoryJSON:JSON in cateogoriesArray {
                let cateogry = ProductCategory(categoryId: categoryJSON["categoryId"].intValue, categoryName: categoryJSON["categoryName"].stringValue)
                organizationItemsCategories.append(cateogry)
            }
        }
    }
}

class ProductCategory {
    var categoryName:String!
    var categoryId:Int!
    
    init(categoryId:Int, categoryName:String){
        self.categoryId=categoryId
        self.categoryName=categoryName
    }
}