//
//  ProductItem.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/8/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation

class ProductItem {
    var description:String = ""
    var itemId:Int!
    var itemName:String!
    var organizationId:Int!
    var products = [ProductItem]()
    
    var discount:Double! = 0.0
    var finalPrice:Double! = 0.0
    var foodProductId:Int!
    var imageUrl:String!
    var name:String! = ""
    var originalPrice:Double! = 0.0
    var sizeId:Int!
    var sizeName:String!
    var status:Int!
}

func ==(lhs:ProductItem, rhs:ProductItem)->Bool{
    return lhs.foodProductId == rhs.foodProductId
}