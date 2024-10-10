//
//  UserDataManager.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/8/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation

class UserDataManager: BaseDataManager {
    static let sharedInstance = UserDataManager()
    private override init(){}
    func sendLoginRequest(userName:String, password:String ){
        let user = User()
        user.password = password
        user.username = userName
        
        let uLogReq = UserLoginRequest()
        uLogReq.user=user
        
        sendRequestObject(uLogReq, reqManager: self)
    }
    
    func createUser(firstName:String, password:String, mobile:String, country:String){
        let user = User()
        user.password = password
        user.firstName = firstName
        user.mobile = mobile
        user.country = country
        
        let uSignReq = CreateUserRequest()
        uSignReq.user=user
        
        sendRequestObject(uSignReq, reqManager: self)
    }
    
    func verifyOTP(mobile:String, otp:String){
        let uSignReq = VerifyOTPRequest()
        uSignReq.mobile=mobile
        uSignReq.otp = otp
        
        sendRequestObject(uSignReq, reqManager: self)
    }
    
    func resendOTP(mobile:String) {
        let req = ResendOTPRequest()
        req.mobile = mobile
        
        sendRequestObject(req)
        
    }
    
    func saveAddress(address:Address){
        let request = SaveAddressRequest()
        request.addressLine = address.addressLine
        request.areaId = address.areaId
        request.areaName = address.areaName
        request.city = address.city
        
        sendRequestObject(request, reqManager: self)
    }
    
    override func responseReceived(response:BaseResponse){
        if let userLoginResponse = response as? UserLoginResponse {
            if userLoginResponse.loginStatus == 1 {
                if let userLoginRequest = userLoginResponse.requestObject as? UserLoginRequest {
                    userLoginResponse.user?.username = userLoginRequest.user.username // login value mobile or email
                    userLoginResponse.user?.password = userLoginRequest.user.password
                }
                ApplicationSession.sharedInstance.currentUser=userLoginResponse.user
            }
        }
        super.responseReceived(response)
    }
}
