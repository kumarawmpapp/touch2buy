//
//  StatisticsOrgViewRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 6/24/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatisticsOrganizationViewRequest: BaseRequest {
    var orgId:Int?
    var user:String?
    
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeStatisticsOrganizationView)
    }
    
    override func requestURLString()->String!
    {
        return "Statistics/orgView"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("orgId",orgId),("ipAddress",""),("communityUser",user),("channel",BaseRequest.channel))
    }
}