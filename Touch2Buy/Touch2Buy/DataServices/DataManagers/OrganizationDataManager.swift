//
//  OrganizationDataManager.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation

class OrganizationDataManager: BaseDataManager {
    static let sharedInstance = OrganizationDataManager()
    private override init(){}
    
    private var organizationList = [Organization]()
    
    func requestAssignedOrganizations(){
        let reqObject = AllOrganizationsRequest()
        sendRequestObject(reqObject)
    }
    
    func requestOrganizationItems(org_id:Int, offset:Int){
        let reqObject = OrganizationItemsRequest(orgId: org_id)
        reqObject.offset = offset
        sendRequestObject(reqObject)
    }
    
    func requestOrganizationBranches(org_id:Int){
        let reqObject = OrganizationBranchesRequest(orgId: org_id)
        sendRequestObject(reqObject)
    }
    
    func requestAvailablePayMethods(branch_id:Int?){
        let reqObject = AvailableChannelPayMethodsRequest()
        reqObject.branchId = branch_id
        sendRequestObject(reqObject)
    }
    
    func requestOrganizationItemsCategories(org_id:Int) {
        let reqObject = OrganizationItemsCategoriesRequest()
        reqObject.orgId = org_id
        sendRequestObject(reqObject)
    }
    
    func requestOrganizationItemsByCategories(org_id:Int, category_id:Int, offset:Int) {
        let reqObject = OrganizationItemsByPublishedCategoriesRequest()
        reqObject.orgId = org_id
        reqObject.catId = category_id
        reqObject.offset = offset
        sendRequestObject(reqObject)
    }
    
    override func responseReceived(response:BaseResponse){
        if let allOrganizationsResponse = response as? AllOrganizationsResponse {
            organizationList.removeAll()
            organizationList.appendContentsOf(allOrganizationsResponse.organizationList)
        }else if let organizationBranchesResponse = response as? OrganizationBranchesResponse {
            if organizationBranchesResponse.organizationBranches.count>0 {
                if let organization = self.getOrganizationById(organizationBranchesResponse.organizationBranches[0].orgId) {
                    organization.organizationBranches=organizationBranchesResponse.organizationBranches
                }
            }
        }else if let availablePayMethodsResponse = response as? AvailableChannelPayMethodsResponse {
            
        }
        
        super.responseReceived(response)
    }
    
    func getOrganizationsList()->[Organization]{
        return organizationList
    }
    
    func getOrganizationBranches(org_id:Int)->[Branch]?{
        if let organization = self.getOrganizationById(org_id) {
            return organization.organizationBranches
        }
        return nil
    }
    
    func getOrganizationById(org_id:Int)->Organization? {
        for org in getOrganizationsList() {
            if org.orgId==org_id {
                return org
            }
        }
        return nil
    }
}