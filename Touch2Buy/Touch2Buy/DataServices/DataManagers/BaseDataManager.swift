//
//  BaseDataManager.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/8/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import Foundation
import SCLAlertView

protocol DataReceivable:class {
    func responseReceived(response:BaseResponse)
}

class BaseDataManager {
    
    var receivers = Array<DataReceivable>()
    
    func registerForData(reciever:DataReceivable){
        for item in receivers {
            if item === reciever {
                return
            }
        }
        
        receivers.append(reciever)
    }
    
    func unregisterForData(reciever:DataReceivable){
        var index = 0
        while index < receivers.count {
            if receivers[index] === reciever {
                receivers.removeAtIndex(index)
            }else{
                index += 1
            }
        }
    }
    
    func sendRequestObject(reqObject:BaseRequest, reqManager:BaseDataManager){
        dispatch_async(dispatch_queue_create("REQUEST_QUEUE", DISPATCH_QUEUE_CONCURRENT)) { () -> Void in
            let webConnectionManager = WebConnectionManager()
            webConnectionManager.sendRequest(reqObject, reqManager: reqManager)
        }
    }
    
    func sendRequestObject(reqObject:BaseRequest){
        sendRequestObject(reqObject, reqManager: self)
    }
    
    func responseReceived(response:BaseResponse){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for receiver:DataReceivable in self.receivers {
                receiver.responseReceived(response)
            }
        }
    }

}
