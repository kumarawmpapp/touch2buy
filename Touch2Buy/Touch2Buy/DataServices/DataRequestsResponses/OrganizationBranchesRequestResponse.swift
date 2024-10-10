//
//  OrganizationBranchesRequest.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/8/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationBranchesRequest: BaseRequest {
    var orgId:Int!
    
    init(orgId:Int){
        super.init(requestType: RequestTypes.RequestTypeOrganizationBranches)
        self.orgId=orgId
    }
    
    override func requestURLString()->String!
    {
        return "organization/branches"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("organizationId",String(orgId)))
    }
}

class OrganizationBranchesResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrganizationBranches
    }
    
    var organizationBranches = [Branch]()
    
    override func setDataFromJSONResponse(response:JSON){
        for branchJSON:JSON in response.arrayValue {
            let branch = Branch()
            branch.addressLine1=branchJSON["addressLine1"].stringValue
            branch.addressLine2=branchJSON["addressLine2"].stringValue
            branch.branchId=branchJSON["branchId"].int
            branch.branchName=branchJSON["branchName"].stringValue
            branch.cityId=branchJSON["cityId"].int
            branch.cityName=branchJSON["cityName"].string ?? ""
            branch.closeTime = branchJSON["closeTime"].string ?? ""
            branch.delevaryAvailable=branchJSON["delevaryAvailable"].boolValue
            branch.isDelevaryAvailable=branchJSON["isDelevaryAvailable"].boolValue
            branch.isMainBranch=branchJSON["isMainBranch"].boolValue
            branch.mainBranch=branchJSON["mainBranch"].boolValue
            branch.openCloseState=branchJSON["openCloseState"].string
            branch.orgId=branchJSON["orgId"].int
            branch.openTime = branchJSON["openTime"].string ?? ""
            branch.phone=branchJSON["phone"].stringValue
            
            if let paymentmethodsJSON = branchJSON["paymentMethods"].array {
                for paymentmethodJSON in paymentmethodsJSON {
                    branch.paymentMethods.append(PaymentMethod(id: paymentmethodJSON["id"].intValue, description: paymentmethodJSON["description"].stringValue))
                }
            }
            
            organizationBranches.append(branch)
        }
    }
}