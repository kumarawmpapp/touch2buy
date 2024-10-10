//
//  LoginViewController.swift
//  Touch2Buy
//
//  Created by MAC BOOK PRO on 11/8/15.
//  Copyright (c) 2015 TouchBuy. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import SCLAlertView

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imgLoginBackground: UIImageView!
    @IBOutlet weak var txtUserName: DefaultTextField!
    @IBOutlet weak var txtPassword: DefaultTextField!
    @IBOutlet weak var btnLogin: DefaultButton!
    @IBOutlet weak var lblCustomerCare: UILabel!
    
    @IBAction func customerCareClicked() {
        if let url = NSURL(string: "tel://+94770223348") {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    @IBAction func loginClicked(sender: UIButton) {
        txtUserName.resignFirstResponder()
        txtPassword.resignFirstResponder()
        UserDataManager.sharedInstance.sendLoginRequest(txtUserName.text!, password: txtPassword.text!)
    }
    
    @IBAction func signupClicked(sender: UIButton) {
        if let rootcontroller =  self.storyboard?.instantiateViewControllerWithIdentifier("SignupViewController") as? SignupViewController{
//            let signupnavigationcontroller = FormSheetViewController(rootViewController:rootcontroller)
////            showViewControllerInFormSheet(signupnavigationcontroller, contentSize: rootcontroller.sizeofFormSheetInDeviceUnderBounds(self.view.bounds.size))
//            let formSheetController = MZFormSheetPresentationViewController(contentViewController: rootcontroller)
//            
//            if let formSheetControllerPresentationController = formSheetController.presentationController {
//                formSheetControllerPresentationController.contentViewSize = CGSizeMake(self.view.bounds.size.width*0.98, 380)
//                formSheetControllerPresentationController.shouldDismissOnBackgroundViewTap = true
//                formSheetControllerPresentationController.backgroundColor = UIColor.clearColor()
//                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
//                formSheetControllerPresentationController.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
//                    if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
//                        return CGRectMake((self.view.bounds.size.width - currentFrame.size.width)/2, self.view.bounds.size.height*0.14, currentFrame.size.width, currentFrame.size.height)
//                    }
//                    return currentFrame
//                };
//            }
//            
//            self.presentViewController(formSheetController, animated: true, completion: nil)
            self.presentViewController(rootcontroller, animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutAction(segue: UIStoryboardSegue) {
        ApplicationSession.sharedInstance.currentUser = nil
    }
    
    let userDefaultsUserName = "USERNAME"
    let userDefaultsPassword = "PASSWORD"
    let nsuserdefaults = NSUserDefaults()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUserName.delegate=self
        txtUserName.attributedPlaceholder = NSAttributedString(string:"Username",
                                                               attributes:[NSForegroundColorAttributeName: ApplicationColor.White])
        
        txtPassword.delegate=self
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: ApplicationColor.White])
        
//        self.imgLoginBackground.image = {() in
//            if UIScreen.HeightEqual480() {
//                return UIImage(named: "LoginBackground640x960")
//            }else {
//                return UIImage(named: "LoginBackground640x1136")
//            }
//        }()
        
        let customerCareLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.customerCareClicked))
        lblCustomerCare.userInteractionEnabled = true
        lblCustomerCare.addGestureRecognizer(customerCareLabelTapGesture)
        
        if let nsuserdefaultsusername = nsuserdefaults.stringForKey(userDefaultsUserName){
            txtUserName.text = nsuserdefaultsusername
        }
        if let nsuserdefaultspassword = nsuserdefaults.stringForKey(userDefaultsPassword){
            txtPassword.text = nsuserdefaultspassword
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDataManager.sharedInstance.registerForData(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UserDataManager.sharedInstance.unregisterForData(self)
    }
    
    override func responseReceived(response:BaseResponse){
        if let userLoginResponse = response as? UserLoginResponse {
            if userLoginResponse.loginStatus == 1 {
                self.checkSavingCredentials(userLoginResponse)
                performSegueWithIdentifier("LoginToMain", sender: nil)
            }else if userLoginResponse.loginStatus == 3 {
                if let reqeustObject = userLoginResponse.requestObject as? UserLoginRequest {
                    self.showOTPViewForResponse(reqeustObject)
                }
            }else if userLoginResponse.message != nil {
                SCAlertViewHelper.showError("Authentication", subtitle: response.message!)
            }
        }else{
            super.responseReceived(response)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        return true
    }
    
    func checkSavingCredentials(response:UserLoginResponse) {
        
        var needToSave = false
        
        let nsuserdefaultsusername = nsuserdefaults.stringForKey(userDefaultsUserName)
        let nsuserdefaultspassword = nsuserdefaults.stringForKey(userDefaultsPassword)
        
        if nsuserdefaultsusername == nil || nsuserdefaultspassword == nil {
            needToSave = true
        }else{
            if nsuserdefaultsusername != response.user?.username || nsuserdefaultspassword != response.user?.password {
                needToSave = true
            }
        }
        
        if needToSave {
            var SCalert = SCAlertViewHelper.getSCAlert()
            SCalert.addButton("Yes", action: {
                self.nsuserdefaults.setObject(response.user?.username, forKey: self.userDefaultsUserName)
                self.nsuserdefaults.setObject(response.user?.password, forKey: self.userDefaultsPassword)
            })
            SCalert.showNotice("Save Credentials", subTitle: "Do you need to save username and password", closeButtonTitle: "No")
        }
    }
    
    func showOTPViewForResponse(userLoginRequest: UserLoginRequest) {
        if let rootcontroller =  OTPVerificationViewController.instantiateFromStoryboard(self.storyboard) {
            rootcontroller.mobileNumber = (userLoginRequest.user?.username)!
            rootcontroller.view.backgroundColor = ApplicationColor.Grey
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: rootcontroller)
            
            if let formSheetControllerPresentationController = formSheetController.presentationController {
                formSheetControllerPresentationController.contentViewSize = CGSizeMake(300, 150)
                formSheetControllerPresentationController.shouldDismissOnBackgroundViewTap = true
                formSheetControllerPresentationController.shouldCenterVertically = true
                formSheetControllerPresentationController.shouldCenterHorizontally = true
                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
//                formSheetControllerPresentationController.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
//                    if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
//                        return CGRectMake((self.view.bounds.size.width - currentFrame.size.width)/2, self.view.bounds.size.height*0.14, currentFrame.size.width, currentFrame.size.height)
//                    }
//                    return currentFrame
//                };
            }
            
            self.presentViewController(formSheetController, animated: true, completion: nil)

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
