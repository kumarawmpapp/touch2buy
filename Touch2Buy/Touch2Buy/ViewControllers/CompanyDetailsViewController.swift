//
//  CompanyDetailsViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 7/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit
import PageMenu

class CompanyDetailsViewController: BaseViewController, CAPSPageMenuDelegate {
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCompanyMoto: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    
    @IBAction func backClicked(sender: AnyObject) {
        if let nav=self.navigationController {
            nav.popToRootViewControllerAnimated(true)
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func companyViewTapped(sender: UITapGestureRecognizer) {
        
    }
    
    var organizationID:Int!
    var pageMenu : CAPSPageMenu?
    var pageMenuControllerArray : [UIViewController] = []
    var pageMenuparameters: [CAPSPageMenuOption] = [
        .MenuItemFont(ApplicationFont.NormalTabFont!),
        .UseMenuLikeSegmentedControl(true),
        .ScrollMenuBackgroundColor(UIColor.clearColor()),
        .SelectionIndicatorHeight(2),
        .SelectionIndicatorColor(ApplicationColor.Color1),
        .SelectedMenuItemLabelColor(UIColor.blackColor())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyImageView.backgroundColor = UIColor.clearColor()
        fillTopHeader()
        
        if let productView = ProductsViewController.instantiateFromStoryboard(self.storyboard) {
            productView.title = "ITEMS"
            productView.organizationID = self.organizationID
            pageMenuControllerArray.append(productView)
        }
        
        if let branchesView = BranchesViewController.instantiateFromStoryboard(self.storyboard) {
            branchesView.title = "BRANCHES"
            branchesView.organizationID = self.organizationID
            pageMenuControllerArray.append(branchesView)
        }
        
        pageMenu = CAPSPageMenu(viewControllers: pageMenuControllerArray, frame: CGRectMake(0.0, 60.0, self.view.frame.width, (self.view.frame.height-60.0)), pageMenuOptions: pageMenuparameters)
        pageMenu!.delegate = self
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        self.pageMenu?.didMoveToParentViewController(self)
    }
    
    class func instantiateFromStoryboard(storyboard:UIStoryboard?) -> CompanyDetailsViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("CompanyDetailsViewController") as? CompanyDetailsViewController
    }
    
    func fillTopHeader() {
        let org=ApplicationSession.sharedInstance.currentOrganization
        
        if let urlString = (org?.images.last?.imageUri?.urlString()) {
            companyImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
        lblCompanyName.text=org?.displayName
        lblCompanyMoto.text=org?.companyMotto
    }
    
    // Mark Page Menu
    func willMoveToPage(controller: UIViewController, index: Int){
    
    }
    
    func didMoveToPage(controller: UIViewController, index: Int){
    
    }
}
