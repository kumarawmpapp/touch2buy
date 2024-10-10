//
//  Order.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/13/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation

enum OrderStatus:Int {
    case ORDER_STATUS_OPEN = 1
    case ORDER_STATUS_SUBMIT = 2
    case ORDER_STATUS_CANCEL = 3
    case ORDER_STATUS_CONFIRMED = 4
    case ORDER_STATUS_REJECTED = 5
    case ORDER_STATUS_RELEASED = 6
    case ORDER_STATUS_DELIVERED = 7
    case ORDER_STATUS_DELIVER_ACCEPTED = 8
    case ORDER_STATUS_DELIVER_REJECTED = 9
    
    var stringValue: String {
        switch self {
        case .ORDER_STATUS_OPEN:return "Open"
        case .ORDER_STATUS_SUBMIT:return "Submited"
        case .ORDER_STATUS_CANCEL:return "User Cancelled"
        case .ORDER_STATUS_CONFIRMED:return "Confirmed"
        case .ORDER_STATUS_REJECTED:return "Rejected"
        case .ORDER_STATUS_RELEASED:return "Released"
        case .ORDER_STATUS_DELIVERED:return "Delivered"
        case .ORDER_STATUS_DELIVER_ACCEPTED:return "Accepted"
        case .ORDER_STATUS_DELIVER_REJECTED:return "Delivery Rejected"
        }
    }
}

class Order {
    var cartId:Int?
    var txnId:String?
    var reference:String?
    var organizationId:Int?
    var branchId:Int?
    var inventoryId:Int?
    var communityUser:String?
    var date:String?
    var deliveredTime:String?
    var deliveryOption:String?
    var deliveryAddress:Address?
    var deliveryAgent:String?
    
    var expectedTime:String?
    var totalDiscount:Double?
    var totalValue:Double?
    var totalDiscountedValue:Double?
    var paymentOption:String?
    var status:Int?
    var pickupBranchId:Int?
    var deliveryCharges:Double?
    var paymentStatus:Int?
    var paidAmount:Double?
    var balance:Double?
    var tableNo:Int?
    var amendStatus:Int?
    var orders = [CartItem]()
}

