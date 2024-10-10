//
//  OrderListViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/11/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class OrderItemCell: UITableViewCell {
   
    @IBOutlet weak var lblLeftSideLabel: UILabel!
    @IBOutlet weak var lblRightSideLabel: UILabel!
    
    var orderObject:Order? {
        didSet {
            lblLeftSideLabel.text = ""
            lblRightSideLabel.text = ""
            
            if let companyID = orderObject?.organizationId {
                if let company = OrganizationDataManager.sharedInstance.getOrganizationById(companyID){
                    if let companyName = company.displayName {
                        lblLeftSideLabel.text = companyName
                    }
                
                }
            }
            lblRightSideLabel.text = orderObject?.expectedTime ?? ""
        }
    }
}

class OrderItemDetailsCell: UITableViewCell {
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBAction func btnViewClicked(sender: UIButton) {
        
    }
    
    var orderObject:Order? {
        didSet {
            var details:String {
                get {
                    var s = ""
                    if let cartid = orderObject?.cartId {
                        s += "Cart ID\t\t\t\t"+String(cartid)+"\n"
                    }
                    if let time = orderObject?.expectedTime {
                        s += "Order Time\t\t\t"+time+"\n"
                    }
                    if let price = orderObject?.totalValue {
                        s += "Order Value\t\t\t"+price.priceString+"\n"
                    }
                    if let deliveryoption = orderObject?.deliveryOption {
                        s += "Delivery Option\t\t" + {
                            () -> String? in
                            if deliveryoption == "1" {
                                return "Home Delivery"
                            }
                            else if deliveryoption == "2"  {
                                return "Store Pickup"
                            }
                            return ""
                            }()!+"\n"
                    }
                    return s
                }
            }
            
            lblDetails.text = details
            
            if let companyID = orderObject?.organizationId {
                let company = OrganizationDataManager.sharedInstance.getOrganizationById(companyID)
                if let urlString = (company?.images.last?.imageUri?.urlString()) {
                    self.imgCompanyLogo.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
                }
            }
        }
    }
}

class OrderListViewController: BaseViewController {
    @IBOutlet weak var orderListView: UITableView!
    
    @IBAction func btnCloseClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnMoreClicked(sender: UIButton) {
        
    }
    
    var ordersArray = [Order]()
    var loadMore = true
    
    var expandedSections = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderListView.estimatedRowHeight = 100
        orderListView.rowHeight = UITableViewAutomaticDimension
        
        
        OrdersDataManager.sharedInstance.requestPreviousOrderList(ordersArray.count)
        
//        let btnMore = UIButton(type: .Custom)
//        btnMore.setTitle("More", forState: .Normal)
//        btnMore.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
//        btnMore.backgroundColor=ApplicationColor.Green
//        btnMore.addTarget(self, action: #selector(OrderListViewController.btnMoreClicked(_:)), forControlEvents: .TouchUpInside)
//        
//        orderListView.tableFooterView = btnMore
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OrdersDataManager.sharedInstance.registerForData(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        OrdersDataManager.sharedInstance.unregisterForData(self)
        super.viewWillDisappear(animated)
    }
    
    override func responseReceived(response:BaseResponse){
        if let orderListResponse = response as? OrderListResponse {
            if orderListResponse.records.count == 0 {
                loadMore = false
            }else{
                addItemstoArray(orderListResponse)
                orderListView.reloadData()
            }
        }
    }
    
    override func sizeofFormSheetIniPhonePortraiteUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-10), height: (bounds.height-100))
    }
    
    func addItemstoArray(orderListResponse:OrderListResponse) {
        ordersArray.appendContentsOf(orderListResponse.records)
    }
}



extension OrderListViewController:UITableViewDataSource, UITableViewDelegate {
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            let range = NSMakeRange(indexPath.section, 1)
            
            if expandedSections.contains(indexPath.section) {
                expandedSections.removeAtIndex(expandedSections.indexOf(indexPath.section)!)
            }else{
                expandedSections.append(indexPath.section)
            }
            
//            var expandedIndex = 0
//            while expandedIndex < expandedSections.count {
//                if indexPath.section == expandedSections[expandedIndex] {
//                    expandedSections.removeAtIndex(expandedIndex)
//                }else{
//                    expandedIndex++
//                }
//            }
            
            let sectionToReload = NSIndexSet(indexesInRange: range)
            orderListView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ordersArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if ((ordersArray.count-1) == section) && loadMore {
            OrdersDataManager.sharedInstance.requestPreviousOrderList(ordersArray.count)
        }
        if let cell:OrderItemCell = orderListView.dequeueReusableCellWithIdentifier("OrderItemCell") as? OrderItemCell {
            cell.orderObject = ordersArray[section]
            cell.contentView.tag = section
            
            let headerTap = UITapGestureRecognizer(target: self, action: #selector(OrderListViewController.sectionHeaderTapped(_:)))
            cell.contentView.addGestureRecognizer(headerTap)
            return cell.contentView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section) {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell:OrderItemDetailsCell = orderListView.dequeueReusableCellWithIdentifier("OrderItemDetailsCell") as? OrderItemDetailsCell {
            cell.orderObject = ordersArray[indexPath.section]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cartView:CartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CartViewController") as? CartViewController{
            let cart = ShopingCart()
            cart.addItems(ordersArray[indexPath.section].orders)
            cartView.cart = cart
            cartView.userInteractionEnabledForQtySelection = false
            self.navigationController?.pushViewController(cartView, animated: true)
        }
    }
    
}
