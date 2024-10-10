//
//  AllOrganizationsRequest.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class AllOrganizationsRequest: BaseRequest {
    init(){
        super.init(requestType: RequestTypes.RequestTypeOrganizationAll)
    }
    
    override func requestURLString()->String!
    {
        return "organization/getAll"
    }
}

class AllOrganizationsResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeOrganizationAll
    }
    
    var organizationList = [Organization]()
    
    override func setDataFromJSONResponse(response:JSON){
        for (_,subJson):(String, JSON) in response {
            let org = Organization(dicOrganization: subJson)
            if org.itemCount>0 {
                organizationList.append(org)
            }
        }
    }
}