//
//  BaseViewController.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/8/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import UIKit
import Kingfisher
import DropDown
import MZFormSheetPresentationController

class BaseViewController: UIViewController, DataReceivable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func responseReceived(response:BaseResponse){
        if response.errorResponse != nil {
            SCAlertViewHelper.showError("", subtitle: response.errorResponse.localizedDescription)
        }else if response.code != nil && response.message != nil {
            SCAlertViewHelper.showInfo("", subtitle: response.message!)
        }
    }
    
     // MARK: - FormSheet
    
    func showViewControllerInFormSheet(contentViewController:UIViewController, contentSize:CGSize) {
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: contentViewController)
        formSheetController.presentationController?.contentViewSize = contentSize
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.backgroundColor = UIColor.clearColor()
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }

    func sizeofFormSheetInDeviceUnderBounds(bounds:CGSize) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if UIDevice.currentDevice().orientation == .Portrait {
                return sizeofFormSheetIniPhonePortraiteUnderBounds(bounds)
            }else if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                return sizeofFormSheetIniPhoneLandscapeUnderBounds(bounds)
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if UIDevice.currentDevice().orientation == .Portrait {
                return sizeofFormSheetIniPadPortraitUnderBounds(bounds)
            }else if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                return sizeofFormSheetIniPadLandscapeUnderBounds(bounds)
            }
        }
        
        
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPhonePortraiteUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPhoneLandscapeUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPadPortraitUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPadLandscapeUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    

}

class BaseTableViewController: UITableViewController, DataReceivable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = 10
        self.tableView.sectionFooterHeight = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func responseReceived(response:BaseResponse){
        if response.errorResponse != nil {
            SCAlertViewHelper.showError("\(response.errorResponse.code)", subtitle: response.errorResponse.localizedDescription)
        }else if response.code != nil && response.message != nil {
            SCAlertViewHelper.showInfo("\(response.code!)", subtitle: response.message!)
        }
    }
        
    // MARK: - FormSheet
    
    func showViewControllerInFormSheet(contentViewController:UIViewController, contentSize:CGSize) {
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: contentViewController)
        formSheetController.presentationController?.contentViewSize = contentSize
        formSheetController.presentationController?.shouldCenterVertically = true
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func sizeofFormSheetInDeviceUnderBounds(bounds:CGSize) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if UIDevice.currentDevice().orientation == .Portrait {
                return sizeofFormSheetIniPhonePortraiteUnderBounds(bounds)
            }else if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                return sizeofFormSheetIniPhoneLandscapeUnderBounds(bounds)
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if UIDevice.currentDevice().orientation == .Portrait {
                return sizeofFormSheetIniPadPortraitUnderBounds(bounds)
            }else if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                return sizeofFormSheetIniPadLandscapeUnderBounds(bounds)
            }
        }
        
        
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPhonePortraiteUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-10), height: (bounds.height-10))
    }
    
    func sizeofFormSheetIniPhoneLandscapeUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPadPortraitUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    func sizeofFormSheetIniPadLandscapeUnderBounds(bounds:CGSize) -> CGSize {
        return CGSize(width: (bounds.width-40), height: (bounds.height-40))
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 30
    }
    
}
