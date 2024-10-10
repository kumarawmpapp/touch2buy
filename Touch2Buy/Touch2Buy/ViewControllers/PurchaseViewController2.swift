//
//  PurchaseViewController2.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/26/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class PurchaseViewController2: BaseViewController {
    @IBOutlet weak var shopingItemsContainerView: UIView!
    @IBAction func btnCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCartViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Purchase2ToCartView" {
            if let cartView:CartViewController = segue.destinationViewController as? CartViewController {
                cartView.cart = ApplicationSession.sharedInstance.cart!
            }
        }
    }
    
    func addCartViewController() {
        if let cartView:CartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CartViewController") as? CartViewController{
            cartView.cart = ApplicationSession.sharedInstance.cart!
            addChildCartControllerToContainer(cartView)
        }
        
        
    }
    
    func addChildCartControllerToContainer(content: UIViewController){
        self.addChildViewController(content)
        content.view.frame = self.shopingItemsContainerView.bounds
        self.shopingItemsContainerView.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
}
