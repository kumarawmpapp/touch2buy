//
//  CompaniesViewController.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/25/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import CHTCollectionViewWaterfallLayout

class CompanyCell:UICollectionViewCell
{
    @IBOutlet weak var companyImageView:UIImageView!
    @IBOutlet weak var companyNameLabel:UILabel!
    
    var branchesClicked:((orgId:Int)->Void)?
    
    var company:Organization! {
        didSet {
            self.companyNameLabel.text=company.displayName
            if let urlString = (company.images.last?.imageUri?.urlString()) {
                self.companyImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
            }
//            self.companyProductsCount.text = String(company.itemCount) + " items"
//            self.companyBranchesButton.hidden = !company.hasBranches
        }
    }
    
    @IBAction func branchesButtonClicked(sender: AnyObject) {
        if let handler = branchesClicked{
            handler(orgId: company.orgId)
        }
    }
}

class CompaniesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    
    @IBAction func cartConfirmationDoneAction(segue: UIStoryboardSegue) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        if !segue.sourceViewController.isBeingDismissed() {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        }
    }
    
    @IBAction func noOpenBranchesAction(segue: UIStoryboardSegue) {
        
    }
  
    var companiesArray = [Organization]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.companiesCollectionView.collectionViewLayout = layout
        
        OrganizationDataManager.sharedInstance.requestAssignedOrganizations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OrganizationDataManager.sharedInstance.registerForData(self)
        companiesArray = OrganizationDataManager.sharedInstance.getOrganizationsList()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        OrganizationDataManager.sharedInstance.unregisterForData(self)
    }
    
    override func responseReceived(response:BaseResponse){
        companiesArray = OrganizationDataManager.sharedInstance.getOrganizationsList()
        companiesCollectionView.reloadData()
        super.responseReceived(response)
    }
    
    func setLongPressGestureToCollectionView(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.companiesCollectionView.addGestureRecognizer(lpgr)
    }
    
    func cellLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            return
        }
        
        let p = gestureReconizer.locationInView(self.companiesCollectionView)
        if let indexPath = self.companiesCollectionView.indexPathForItemAtPoint(p) {
            if let org:Organization = companiesArray[indexPath.row] {
                ApplicationSession.sharedInstance.currentOrganization=org
                performSegueWithIdentifier("CompaniesToBranches", sender: nil)
            }
        }
    }
    
    // MARK: - Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companiesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CompanyCell = collectionView.dequeueReusableCellWithReuseIdentifier("CompanyCell", forIndexPath: indexPath) as! CompanyCell
        cell.company=companiesArray[indexPath.row]
        cell.branchesClicked = {(orgId) in
            
            if let branchesViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("BranchesViewController") as? BranchesViewController{
                branchesViewController.organizationID = orgId
                let branchesnavigationcontroller = FormSheetViewController(rootViewController:branchesViewController)
                
                let formSheetController = MZFormSheetPresentationViewController(contentViewController: branchesViewController)
                
                if let formSheetControllerPresentationController = formSheetController.presentationController {
                    formSheetControllerPresentationController.contentViewSize = CGSizeMake(312, self.view.bounds.size.height*0.84)
                    formSheetControllerPresentationController.shouldDismissOnBackgroundViewTap = true
                    formSheetControllerPresentationController.backgroundColor = UIColor.clearColor()
                    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
                    formSheetControllerPresentationController.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
                        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
                            return CGRectMake(3, self.view.bounds.size.height*0.16, currentFrame.size.width, currentFrame.size.height)
                        }
                        return currentFrame
                    };
                }
                
                self.presentViewController(formSheetController, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return collectionViewItemSize()
        
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columnCountForSection section: Int) -> Int {
        return Int(collectionView.contentSize.width / collectionViewItemSize().width)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let org:Organization = companiesArray[indexPath.row] {
            ApplicationSession.sharedInstance.currentOrganization=org
            ApplicationSession.sharedInstance.cart = ShopingCart()
            StatServiceDataManager.sharedInstance.sendStatOrganizationView()
            
            if let companiesDetailsView = CompanyDetailsViewController.instantiateFromStoryboard(self.storyboard) {
                companiesDetailsView.organizationID=org.orgId
                
                if (self.navigationController != nil) {
                    self.navigationController?.pushViewController(companiesDetailsView, animated: true)
                }
            }
        }
    }
    
    func collectionViewItemSize() -> CGSize {
        return CGSize(width: 150, height: 117)
    }
    
    // MARK: - segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
}
