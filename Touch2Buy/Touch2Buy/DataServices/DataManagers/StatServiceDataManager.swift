//
//  StatServiceDataManager.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 6/24/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation

class StatServiceDataManager: BaseDataManager {
    static let sharedInstance = StatServiceDataManager()
    private override init(){}
    
    func sendStatOrganizationView() {
        let reqObject = StatisticsOrganizationViewRequest()
        reqObject.orgId = ApplicationSession.sharedInstance.currentOrganization?.orgId
        reqObject.user = ApplicationSession.sharedInstance.currentUser?.username
        sendRequestObject(reqObject)
    }
    
    override func responseReceived(response:BaseResponse){
        super.responseReceived(response)
    }
}