//
//  BaseRequestResponse.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RequestTypes:Int {
    case RequestTypeDefault
    case RequestTypeLoginUser
    case RequestTypeCreateUser
    case RequestTypeVerifyOTP
    case RequestTypeResendOTP
    case RequestTypeOrganizationAll
    case RequestTypeOrganizationItems
    case RequestTypeOrganizationBranches
    case RequestTypeOrderNew
    case RequestTypeOrderConfirmCancel
    case RequestTypeOrderList
    case RequestTypePaymentMethods
    case RequestTypeChannelPayMethods
    case RequestTypeDeliveryOptions
    case RequestTypeCities
    case RequestTypeCountries
    case RequestTypeSaveAddress
    case RequestTypeDeliveryCharge
    case RequestTypeOrganizationItemsCategories
    case RequestTypeOrganizationItemsByPublishedCategories
    case RequestTypeStatisticsOrganizationView
    case RequestTypePriceCalculate
    case RequestTypeAreas
}

class BaseRequest {
    let requestType:RequestTypes
    var mobileVersion:String?
    var userName:String?
    
    static let channel:String = {()->String in
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return "iPhone"
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return "iPad"
        }
        
        return ""
    }()
    
    static let channelID:Int = {()->Int in
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return 6
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return 5
        }
        
        return 0
    }()
    
    init(requestType:RequestTypes){
        self.requestType=requestType;
        self.mobileVersion = ApplicationInfo.applicationVersion
        self.userName = ApplicationSession.sharedInstance.currentUser?.username
    }
    
    func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return nil
    }
    
    func requestURLString()->String!
    {
        return nil
    }
    
    func printDebugURLParams() -> String
    {
        return requestURLString() + "->" + (getRequestParameters()?.keyvalueString() ?? "")
    }

}

enum ResponseTypes:Int {
    case ResponseTypeDefault
    case ResponseTypeLoginUser
    case ResponseTypeCreateUser
    case ResponseTypeVerifyOTP
    case ResponseTypeResendOTP
    case ResponseTypeOrganizationAll
    case ResponseTypeOrganizationItems
    case ResponseTypeOrganizationBranches
    case ResponseTypeOrderNew
    case ResponseTypeOrderList
    case ResponseTypePaymentMethods
    case ResponseChannelPayMethods
    case ResponseTypeDeliveryOptions
    case ResponseTypeCities
    case ResponseTypeCountries
    case ResponseTypeSaveAddress
    case ResponseTypeDeliveryCharge
    case ResponseTypeOrganizationItemsCategories
    case ResponseTypeOrganizationItemsByPublishedCategories
    case ResponseTypePriceCalculate
    case ResponseTypeAreas
}

class BaseResponse {
    var responseData:NSData!
    var urlResponse:NSURLResponse!
    var errorResponse:NSError!
    var requestObject:BaseRequest!
    var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeDefault
    }
    
    var message:String?
    var code:Int?
    
    func setDataFromJSONResponse(response:JSON){
        
    }
}