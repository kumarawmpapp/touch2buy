//
//  MainViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/16/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import UIKit
import DropDown
import MZFormSheetPresentationController

class MainViewController: BaseViewController {

    @IBOutlet weak var btnUserOptions: UIButton!
    
    @IBAction func btnUserOptionsClicked(sender: UIButton) {
        if userOptionsDropDown.hidden {
            userOptionsDropDown.show()
        } else {
            userOptionsDropDown.hide()
        }
    }
    
    let userOptionsDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userOptionsDropDown.dataSource = [
           "Order List", "Logout"
        ]
        
        userOptionsDropDown.selectionAction = { [unowned self] (index, item) in
            switch index {
                case 0:
                    self.showOrderListView()
                    break
                case 1:
                    self.performSegueWithIdentifier("logout", sender: self)
                    break
                
            default:
                break
            }
        }
        
        userOptionsDropDown.anchorView = self.btnUserOptions
        userOptionsDropDown.bottomOffset = CGPoint(x: -100, y:(self.btnUserOptions.bounds.height + 20))
        userOptionsDropDown.width = 100
    }
    
    func showOrderListView() {
        if let rootcontroller =  self.storyboard?.instantiateViewControllerWithIdentifier("OrderListViewController") as? OrderListViewController{
            rootcontroller.title = "Order List"
            let orderlistnavigationcontroller = FormSheetViewController(rootViewController:rootcontroller)
            
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: orderlistnavigationcontroller)
            
            orderlistnavigationcontroller.navigationBar.barTintColor = ApplicationColor.Color3
            orderlistnavigationcontroller.navigationBar.tintColor = ApplicationColor.White
            orderlistnavigationcontroller.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ApplicationColor.White]
            
            if let formSheetControllerPresentationController = formSheetController.presentationController {
                formSheetControllerPresentationController.contentViewSize = rootcontroller.sizeofFormSheetInDeviceUnderBounds(UIScreen.mainScreen().bounds.size)
                formSheetControllerPresentationController.shouldDismissOnBackgroundViewTap = true
                formSheetControllerPresentationController.backgroundColor = ApplicationColor.White.colorWithAlphaComponent(0.9)
                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
                formSheetControllerPresentationController.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
                    if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
                        return CGRectMake((self.view.bounds.size.width - currentFrame.size.width)/2, 80, currentFrame.size.width, currentFrame.size.height-80)
                    }
                    return currentFrame
                };
            }
            
            self.presentViewController(formSheetController, animated: true, completion: nil)
        }
    }
}
