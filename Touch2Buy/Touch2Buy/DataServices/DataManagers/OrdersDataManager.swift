//
//  OrdersDataManager.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/14/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation

class OrdersDataManager: BaseDataManager {
    static let sharedInstance = OrdersDataManager()
    private override init(){}
    
    func sendNewOrder(reqObject:OrderRequest){
        sendRequestObject(reqObject)
    }
    
    func orderConfirm(){
        let reqObject = OrderConfirmCancelRequest(action: OrderAction.OrderActionConfirm)
        sendRequestObject(reqObject)
    }
    
    func orderCancel(){
        let reqObject = OrderConfirmCancelRequest(action: OrderAction.OrderActionCancel)
        sendRequestObject(reqObject)
    }
    
    func requestPreviousOrderList(offset:Int){
        let reqObject = OrderListRequest()
        reqObject.offset = offset
        sendRequestObject(reqObject)
    }
    
    func requestDeliveryCharge(address:Address?, order:OrderRequest?) {
        let reqObject = DeliveryChargeRequest()
        reqObject.address = address
        reqObject.order = order
        sendRequestObject(reqObject)
    }
    
    func requestPriceCalculation(reqObject:PriceCalculateRequest) {
        sendRequestObject(reqObject)
    }
    
    override func responseReceived(response:BaseResponse){
        if let orderResponse = response as? OrderResponse {
            ApplicationSession.sharedInstance.cart?.cartId = orderResponse.cartId
        }
        super.responseReceived(response)
    }
}
