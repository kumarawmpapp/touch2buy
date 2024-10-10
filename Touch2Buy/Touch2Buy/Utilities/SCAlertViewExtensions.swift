//
//  SCAlertViewExtensions.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 7/25/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SCLAlertView

class SCAlertViewHelper {
    static var alertViewResponder: SCLAlertViewResponder!
    static var SCalert: SCLAlertView!
    
    
    class func getSCAlert() -> SCLAlertView {
        SCalert = SCLAlertView()
        SCalert.showCircularIcon = false
        SCalert.modalTransitionStyle = .FlipHorizontal
        return SCalert
    }
    
    // MARK: - SCAlertView
    
    class func showError(title:String, subtitle:String) ->  SCLAlertViewResponder{
        return getSCAlert().showError(title, subTitle: subtitle, closeButtonTitle: "Close")//, duration: 0, colorStyle: 0xffffff, colorTextButton: 0xffb650)
    }
    
    class func showSuccess(title:String, subtitle:String) ->  SCLAlertViewResponder{
        return getSCAlert().showSuccess(title, subTitle: subtitle, closeButtonTitle: "OK")//, duration: 0, colorStyle: 0xffffff, colorTextButton: 0xffb650)
    }
    
    class func showInfo(title:String, subtitle:String) ->  SCLAlertViewResponder{
        return getSCAlert().showInfo(title, subTitle: subtitle, closeButtonTitle: "OK")//, duration: 0, colorStyle: 0xffffff, colorTextButton: 0xffb650)
    }
    
    class func showNotice(title: String, subTitle: String) ->  SCLAlertViewResponder{
        return getSCAlert().showNotice(title, subTitle: subTitle)
    }
    
}