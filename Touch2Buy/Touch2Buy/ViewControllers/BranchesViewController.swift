//
//  BranchesViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/20/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import UIKit

class BranchCell: UITableViewCell {
    var branch:Branch!{
        didSet {
            lblBranchName.text = branch.branchName + "\n" + branch.cityName
            lblBranchDetails.text = branch.address+"\r\n"+branch.phone
        }
    }
    @IBOutlet weak var lblBranchName: UILabel!
    @IBOutlet weak var lblBranchDetails: UILabel!
    
}

class BranchesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var organizationID:Int!
    var branchesArray = [Branch]()
    
    @IBOutlet weak var branchesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("closeClicked"))
        OrganizationDataManager.sharedInstance.requestOrganizationBranches(organizationID)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OrganizationDataManager.sharedInstance.registerForData(self)
        self.getDataAndReload()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        OrganizationDataManager.sharedInstance.unregisterForData(self)
    }
    
    class func instantiateFromStoryboard(storyboard:UIStoryboard?) -> BranchesViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("BranchesViewController") as? BranchesViewController
    }
    
    override func responseReceived(response:BaseResponse){
        self.getDataAndReload()
    }
    
    private func getDataAndReload(){
        if let barray = OrganizationDataManager.sharedInstance.getOrganizationBranches(organizationID){
            branchesArray.removeAll()
            branchesArray.appendContentsOf(barray)
            branchesTableView.reloadData()
        }
    }
    
    func closeClicked(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branchesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BranchCell = tableView.dequeueReusableCellWithIdentifier("BranchCell") as! BranchCell
        cell.branch=branchesArray[indexPath.row]
        return cell
    }
}
