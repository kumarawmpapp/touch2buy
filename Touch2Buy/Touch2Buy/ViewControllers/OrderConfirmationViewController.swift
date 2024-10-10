//
//  OrderConfirmationViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 4/3/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: BaseViewController {
    @IBOutlet weak var imgOrganization: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtvPersonalDetails: UITextView!
    @IBOutlet weak var txtvOrderDetails: UITextView!
    @IBOutlet weak var btnDone: DefaultButton!
    
    @IBAction func btnDoneClicked(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("cartconfirmationtocompanies", sender: nil)
    }
    
    var orderResponse:OrderResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "The order's been sent to " + {
            var companyatbranch = ""
            
            if let organization = OrganizationDataManager.sharedInstance.getOrganizationById(orderResponse.organizationId) {
                if let urlString = (organization.images.last?.imageUri?.urlString()) {
                    self.imgOrganization.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
                }
                companyatbranch = organization.displayName
                if let branch = organization.getBranchByID(orderResponse.branchId) {
                    companyatbranch.appendContentsOf(" at \(branch.branchName)")
                }
            }
            return companyatbranch
            }() + ". We'll inform you as soon as its accepted."
        
        let datetimeformatter = NSDateFormatter()
        datetimeformatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let displaydatetimeformatter = NSDateFormatter()
        displaydatetimeformatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        let personaldetails:String = orderResponse.customerName +
            {
                () -> (String) in
                if self.orderResponse.deliveryOption == "2" {
                    return "\nDelivery Address : " + (orderResponse.address?.apendedAddress ?? "")
                }
                return ""
            }() +
            
             "\nContact Number : " + orderResponse.customerMobile
        txtvPersonalDetails.text = personaldetails
        
        let orderdetails:String = "Order ID : \(orderResponse.cartId)\n\n" +
                            "Order Value : \(orderResponse.totalNetValue.priceString)\n\n" + "Delivery Charges : " + orderResponse.deliveryCharges.priceString + "\n\n" + "Total Amount : " + Double(orderResponse.totalNetValue + orderResponse.deliveryCharges).priceString + "\n\n" + "Delivery Time : " + orderResponse.expectedTime + "\n\n" +
            "Delivery Option : " + {
                switch self.orderResponse.deliveryOption {
                case "1":return "Store Pickup"
                case "2":return "Home Delivery"
                default:return ""
                }
            }() + "\n\n" +
            "Payment Method : " + {
                if let payOption = orderResponse.paymentOption {
                    let payOtpionID = Int(payOption) ?? 0
                    if let paymethod = PublicDataManager.sharedInstance.getPaymentMethodByID(payOtpionID) {
                        return paymethod.description
                    }
                }
                
                
                return ""
                }()
        
        txtvOrderDetails.text = orderdetails
    }
    
    
}
