//
//  Organization.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/26/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class Organization {
    var addressLine:String!
    var organizationBranches = [Branch]()
    var categoryId:Int!
    var cityId:Int!
    var companyMotto:String!
    var companyRegNumber:String!
    var countryId:Int!
    var createdBy:String!
    var description:String!
    var displayName:String!
    var email:String!
    var hasBranches:Bool!
    var images = [ImageItem]()
    var itemCount:Int = 0
    var landLine:String!
    var mainBranchId:Int!
    var minOrderTime:String!
    var orgId:Int!
    var orgName:String!
    var status:Int!
    
    init(dicOrganization:JSON){
        self.cityId=dicOrganization["cityId"].int
        self.companyMotto=dicOrganization["companyMotto"].string
        self.description=dicOrganization["description"].string
        self.displayName=dicOrganization["displayName"].string
        self.itemCount = dicOrganization["itemCount"].intValue
        self.orgId=dicOrganization["orgId"].int
        self.orgName=dicOrganization["orgName"].string
        self.mainBranchId=dicOrganization["mainBranchId"].int
        self.minOrderTime = dicOrganization["minOrderTime"].string
        self.hasBranches=dicOrganization["hasBranches"].bool
        self.companyRegNumber=dicOrganization["companyRegNumber"].string
        
        for (_,imageJSON):(String, JSON) in dicOrganization["images"] {
            let imageItem = ImageItem()
            imageItem.imageType=imageJSON["imageType"].stringValue
            imageItem.imageId=imageJSON["imageId"].intValue
            imageItem.imageUri=imageJSON["imageUri"].stringValue
            
            images.append(imageItem)
        }
    }
    
    func getBranchByID(id:Int) -> Branch? {
        for branch in organizationBranches {
            if branch.branchId == id {
                return branch
            }
        }
        return nil
    }
}

enum BranchOpenCloseStates {
    case BranchStateNotDefined
    case BranchStateOpen
    case BranchStateClosed
}

class Branch {
    var branchId : Int!
    var closeTime : String!
    var openCloseState : String!
    var openTime : String!    
    var mainBranch : Bool = false
    var isDelevaryAvailable : Bool = false
    var delevaryAvailable : Bool = false
    var cityId : Int!
    var cityName:String!
    var branchName : String = ""
    var orgId : Int!
    var addressLine1 : String = ""
    var isMainBranch : Bool = false
    var addressLine2 : String = ""
    var phone : String = ""
    var paymentMethods = [PaymentMethod]()
    
    
    var address: String {
        get {
            return addressLine1 + ", " + addressLine2
        }
    }
    
    var branchOpenClosedState:BranchOpenCloseStates {
        if openCloseState == "open" {
            return BranchOpenCloseStates.BranchStateOpen
        }else if openCloseState == "closed" {
            return BranchOpenCloseStates.BranchStateClosed
        }else{
            return BranchOpenCloseStates.BranchStateNotDefined
        }
    }
    
}