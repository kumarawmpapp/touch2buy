//
//  CartViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/1/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class CartItemCell:UITableViewCell {
    var cartItem:CartItem!{
        didSet{
            self.setValues()
            cartItemCellPriceQty.QtyDropDownValueChanged={(qty:Int) in
                self.cartItem.cartItemQty=qty
                self.setValues()
            }
            if let urlString = (cartItem.cartItemProduct.imageUrl.urlString()) {
                cartItemCellImage.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
            }
            cartItemCellItemName.text=cartItem.cartItemProduct.name ?? ""
            cartItemCellItemSize.text = ""
        }
    }
    
    @IBOutlet weak var cartItemCellTotal: UILabel!
    @IBOutlet weak var cartItemCellPriceQty: QtyDropDown!
    @IBOutlet weak var cartItemCellImage: UIImageView!
    @IBOutlet weak var cartItemCellItemName: UILabel!
    @IBOutlet weak var cartItemCellItemSize: UILabel!
    
    func setValues(){
        cartItemCellTotal.text=cartItem.netTotal.priceString
        self.cartItemCellPriceQty.captionLabelText="\(self.cartItem.netPrice.priceString)x\(self.cartItem.cartItemQty)"
    }
}

class CartItemFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var netTotal: UILabel!
    @IBOutlet weak var totalDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}

class CartViewController: BaseViewController {
    @IBOutlet weak var cartItemsView: UITableView!
    
    var cart:ShopingCart = ShopingCart() {
        didSet {
            cartItemsArray = cart.getCartItems()
        }
    }
    
    var userInteractionEnabledForQtySelection = true
    
    
    private var cartItemsArray:Array<CartItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CartViewControllerFooterView", bundle: nil)
        cartItemsView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CartViewControllerFooterView")
        
        cartItemsView.estimatedRowHeight = 44.0
        cartItemsView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshDataAndView()
    }
    
    func refreshDataAndView(){
        cartItemsArray = cart.getCartItems()
        cartItemsView.reloadData()
    }

}

extension CartViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if let cell:CartItemFooterCell = tableView.dequeueReusableCellWithIdentifier("CartItemFooterCell") as? CartItemFooterCell {
//            cell.netTotal.text = cart.calculatedNetTotal.priceString
//            cell.subTotal.text = cart.calculatedSubTotal.priceString
//            cell.totalDiscount.text = cart.calculatedTotalDiscount.priceString
//            return cell.contentView
//        }
//        let footerview = CartItemFooterView(coder: <#T##NSCoder#>)
//        footerview.netTotal.text = cart.calculatedNetTotal.priceString
//        footerview.subTotal.text = cart.calculatedSubTotal.priceString
//        footerview.totalDiscount.text = cart.calculatedTotalDiscount.priceString
//        
//        return footerview
        
        let footercell = self.cartItemsView.dequeueReusableHeaderFooterViewWithIdentifier("CartViewControllerFooterView")
        let footerview = footercell as! CartItemFooterView
        footerview.netTotal.text = cart.calculatedNetTotal.priceString
        footerview.subTotal.text = cart.calculatedSubTotal.priceString
        footerview.totalDiscount.text = cart.calculatedTotalDiscount.priceString
        return footercell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell:CartItemCell = tableView.dequeueReusableCellWithIdentifier("CartItemCell") as? CartItemCell {
        if let citem:CartItem = cartItemsArray[indexPath.row] {
            cell.cartItem=citem
            cell.cartItemCellPriceQty.QtyDropDownValueChanged={(qty:Int) in
                cell.cartItem.cartItemQty=qty
                self.cart.addItem(cell.cartItem)
                cell.setValues()
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
        cell.cartItemCellPriceQty.userInteractionEnabled = userInteractionEnabledForQtySelection
        return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle==UITableViewCellEditingStyle.Delete {
            cart.deleteItem(cartItemsArray[indexPath.row])
            self.refreshDataAndView()
        }
    }
}
