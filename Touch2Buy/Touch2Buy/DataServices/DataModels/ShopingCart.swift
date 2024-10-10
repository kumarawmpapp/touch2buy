//
//  ShopingCart.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/8/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation

class ShopingCart {
//    static let sharedInstance = ShopingCart()
//    private init(){}
    
    private var itemsList = Set<CartItem>()
    
    var cartId:Int?
    
    var calculatedNetTotal:Double {
        var total = 0.0
        
        for cartitem in itemsList {
            total += cartitem.netTotal
        }
        
        return total
    }
    
    var calculatedTotalDiscount:Double {
        var discount = 0.0
        for cartitem in itemsList {
            discount += cartitem.cartItemProduct.discount * Double(cartitem.cartItemQty)
        }
        return discount
    }
    
    var calculatedSubTotal:Double {
        var total = 0.0
        for cartitem in itemsList {
            total += cartitem.subTotal
        }
        return total
    }
    
    var serverNetTotal:Double?
    var serverTotalDiscount:Double?
    var serverSubTotal:Double?
    
    
    var cartIsEmpty:Bool {
        if itemsList.count > 0 {
            return false
        }
        return true
    }
    
    
    func addItem(item:ProductItem, qty:Int){
        self.addItem(CartItem(item: item, qty: qty))
    }
    
    func addItem(item:CartItem){
        if itemsList.contains(item){
            itemsList.remove(item)
        }
        
        itemsList.insert(item)
        
    }
    
    func addItems(items:[CartItem]){
        for item in items {
            self.addItem(item)
        }
    }
    
    func addItem(item:ProductItem){
        self.addItem(item, qty: 1)
    }
    
    func deleteItem(item:CartItem){
        itemsList.remove(item)
    }
    
    func clearAll() {
        itemsList.removeAll()
    }
    
    func getCartItems() -> [CartItem]{
        if itemsList.isEmpty {
            return [CartItem]()
        }else{
            return itemsList.sort({ (lhs, rhs) -> Bool in
                return lhs.cartItemProduct.itemName.localizedCaseInsensitiveCompare(rhs.cartItemProduct.itemName) == NSComparisonResult.OrderedAscending
            })
        }
    }
}

class CartItem: Hashable {
    var cartItemProduct:ProductItem!
    var cartItemQty:Int
    
    init(item:ProductItem, qty:Int){
        self.cartItemProduct=item;
        self.cartItemQty=qty;
    }
    
    var netPrice:Double {
        return cartItemProduct.finalPrice
    }
    
    var subPrice:Double {
        return cartItemProduct.originalPrice
    }
    
    var name:String {
        return cartItemProduct.name
    }
    
    var netTotal:Double {
        return netPrice * Double(cartItemQty)
    }
    
    var subTotal:Double {
        return subPrice * Double(cartItemQty)
    }
    
    var hashValue: Int {
        return self.cartItemProduct.sizeId
    }
}

func ==(lhs: CartItem, rhs: CartItem) -> Bool {
    return lhs.cartItemProduct == rhs.cartItemProduct
}