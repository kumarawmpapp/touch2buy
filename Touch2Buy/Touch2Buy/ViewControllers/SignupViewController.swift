//
//  SignupViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/15/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit
import PagingMenuController

enum RegistrationStatus {
    case NoRegistration
    case UserRegistrationComplete
    case OTPVerified
}

class UserRegistrationDetails {
    var registrationStatus:RegistrationStatus = .NoRegistration
    
    var customerName: String!
    var customerPassword: String!
    var customerMobile: String!
    
    static let sharedInstance = UserRegistrationDetails()
    private init(){}
    
    
}

class CustomizedCountryDropDown: GeneralDropDown {
    override func setup() {
        super.setup()
        self.captionLabel.textColor = ApplicationColor.White
    }
}

class RegisterViewController: BaseTableViewController {
    
    @IBOutlet weak var txtFirstname: DefaultTextField!
    @IBOutlet weak var txtPassword: DefaultTextField!
    @IBOutlet weak var txtMobile: DefaultTextField!
    @IBOutlet weak var contryDropDown: CustomizedCountryDropDown!
    @IBOutlet weak var btnRegister: DefaultButton!
    @IBOutlet weak var btnChkShowPwd: CheckBoxButton!
    
    @IBAction func btnRegisterClicked(sender: AnyObject) {
        guard let name = self.txtFirstname.text where self.txtFirstname.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count > 0 else {
            SCAlertViewHelper.showError("", subtitle: "Please Provide First Name")
            self.txtFirstname.layer.borderColor = ApplicationColor.DarkRed.CGColor
            return
        }
        
        guard let password = self.txtPassword.text where self.txtPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count > 6 else {
            SCAlertViewHelper.showError("", subtitle: "Password should be minimum seven characters")
            self.txtPassword.layer.borderColor = ApplicationColor.DarkRed.CGColor
            return
        }
        
        guard let mobile = self.txtMobile.text where txtMobile.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count == 10 else {
            SCAlertViewHelper.showError("", subtitle: "Provide Valid Mobile Number with 10 digits")
            self.txtMobile.layer.borderColor = ApplicationColor.DarkRed.CGColor
            return
        }
        
        UserDataManager.sharedInstance.createUser(name, password: password, mobile: mobile, country: RegisterViewController.country?.isoCode ?? "")
    }
    
    class func instantiateFromStoryboard(storyboard:UIStoryboard?) -> RegisterViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as? RegisterViewController
    }
    
    static var country: Country!
    var responseRecievedToParentCompletionHander: ((BaseResponse) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFirstname.attributedPlaceholder = NSAttributedString(string:"Name",
                                                               attributes:[NSForegroundColorAttributeName: ApplicationColor.White])
        txtMobile.attributedPlaceholder = NSAttributedString(string:"10 digit mobile number",
                                                               attributes:[NSForegroundColorAttributeName: ApplicationColor.White])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password (Minimum 7 characters)",
                                                             attributes:[NSForegroundColorAttributeName: ApplicationColor.White])
        
        fillCountriesDropDown()
        
        self.btnChkShowPwd.checkBoxClickedCompletionHandler = { (isChecked) -> Void in
            self.txtPassword.secureTextEntry = !isChecked
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        txtPassword.secureTextEntry = !self.btnChkShowPwd.isChecked
        
        UserDataManager.sharedInstance.registerForData(self)
        PublicDataManager.sharedInstance.registerForData(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UserDataManager.sharedInstance.unregisterForData(self)
        PublicDataManager.sharedInstance.unregisterForData(self)
    }
    
    override func responseReceived(response:BaseResponse){
        if let createUserResponse = response as? CreateUserResponse {
            if createUserResponse.statusCode == 0 &&  createUserResponse.userId != nil &&  createUserResponse.message != nil {
                
                if let userReqesut = createUserResponse.requestObject as? CreateUserRequest {
                    let userRegistrationDetails = UserRegistrationDetails.sharedInstance
                    
                    userRegistrationDetails.registrationStatus = .UserRegistrationComplete
                    userRegistrationDetails.customerName = userReqesut.user.firstName
                    userRegistrationDetails.customerPassword = userReqesut.user.password
                    userRegistrationDetails.customerMobile = userReqesut.user.mobile
                    
                    self.responseRecievedToParentCompletionHander?(response)
                }
                
                SCAlertViewHelper.showSuccess("", subtitle: "Please enter one time password received to your mobile")
                
            }else if createUserResponse.statusCode == 1 &&  createUserResponse.message != nil {
                SCAlertViewHelper.showError("", subtitle: "Customer Already Exist")
                
            }
        }else if let _ = response as? CountriesResponse {
            fillCountriesDropDown()
        }else{
            super.responseReceived(response)
        }
    }
    
    func fillCountriesDropDown() {
        if PublicDataManager.sharedInstance.getCountries().count == 0 {
            PublicDataManager.sharedInstance.registerForData(self)
            PublicDataManager.sharedInstance.requestCountries()
        }else{
            let countriesarray = PublicDataManager.sharedInstance.getCountries()
            contryDropDown.dataSource = countriesarray.map({ (element:Country) -> String in
                return element.countryName
            })
            
            func selectedCountryAtIndex(index:Int) {
                RegisterViewController.country = countriesarray[index]
                contryDropDown.captionLabelText = RegisterViewController.country.countryName
            }
            
            contryDropDown.dropDownSelectionAction = {(index)->() in
                selectedCountryAtIndex(index)
            }
            
            selectedCountryAtIndex(0)
            
        }
    }
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if SignupViewController.registrationStatus == .UserRegistrationComplete {
//            if indexPath.section == 0 {
//                return nil
//            }
//        }
//        
//        return super.tableView(tableView, willSelectRowAtIndexPath: indexPath)
//    }
//    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let headertitle =  super.tableView(tableView, titleForHeaderInSection: section){
//            if section == 0 {
//                if SignupViewController.registrationStatus == .UserRegistrationComplete {
//                    return headertitle + " " + ApplicationFontUnicodes.checkMark
//                }
//            }
//        }
//        
//        return super.tableView(tableView, titleForHeaderInSection: section)
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//        if indexPath.section == 0 {
//            if SignupViewController.registrationStatus == .UserRegistrationComplete {
//                cell.userInteractionEnabled = false
//            }
//        }
//        return cell
//    }
}

class OTPVerificationViewController: BaseViewController {
    
    @IBOutlet weak var txtOTP: DefaultTextField!
    
    @IBAction func btnOTPVerifyClicked(sender: AnyObject) {
        UserDataManager.sharedInstance.verifyOTP(mobileNumber,otp: self.txtOTP.text ?? "")
    }
    
    @IBAction func btnOTPResendClicked(sender: AnyObject) {
        UserDataManager.sharedInstance.resendOTP(mobileNumber)
    }
    
    var mobileNumber : String = UserRegistrationDetails.sharedInstance.customerMobile ?? ""
    
    override func viewWillAppear(animated: Bool) {
        UserDataManager.sharedInstance.registerForData(self)
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        UserDataManager.sharedInstance.unregisterForData(self)
        super.viewDidDisappear(animated)
    }
    
    override func responseReceived(response: BaseResponse) {
        if let verifyOTPResponse = response as? VerifyOTPResponse {
            if verifyOTPResponse.code != nil && verifyOTPResponse.code == 0 {
                UserRegistrationDetails.sharedInstance.registrationStatus = .OTPVerified
                
                SCAlertViewHelper.showSuccess("", subtitle: "Customer created Successfuly")
            }else if verifyOTPResponse.code != nil && verifyOTPResponse.code == 1 {
                SCAlertViewHelper.showError("", subtitle: "Invalid One Time Password (OTP)")
            }
        }
    }
    
    class func instantiateFromStoryboard(storyboard:UIStoryboard?) -> OTPVerificationViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("OTPVerificationViewController") as? OTPVerificationViewController
    }
}

class SignupViewController: BaseViewController {
    @IBOutlet weak var lblCustomerCare: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBAction func customerCareClicked() {
        if let url = NSURL(string: "tel://" + ApplicationCommonValues.customerCareNumber) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    @IBAction func btnCloseClicked() {
        self.closeClicked()
    }
    
    var pagingMenuController : PagingMenuController!
    
    class PagingMenuOptions: PagingMenuControllerCustomizable {
        var storyBoard : UIStoryboard?
        var signupViewController : SignupViewController
        
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        
        var componentType: ComponentType {
            return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        }
        
        var pagingControllers: [UIViewController] {
            var controllers : Array = [UIViewController]()
            
            
            if let registerViewController = RegisterViewController.instantiateFromStoryboard(storyBoard) {
                registerViewController.responseRecievedToParentCompletionHander = {(response: BaseResponse) in
                    if let _ = response as? CreateUserResponse {
                        if UserRegistrationDetails.sharedInstance.registrationStatus == .UserRegistrationComplete {
                            self.signupViewController.pagingMenuController.moveToMenuPage(1, animated: true)
                        }
                    }
                    
                }
                controllers.append(registerViewController)
            }
            if let otpVerificationViewController = OTPVerificationViewController.instantiateFromStoryboard(storyBoard) {
                controllers.append(otpVerificationViewController)
            }
            
            return controllers
        }
        
        init(storyBoard : UIStoryboard?, signupController : SignupViewController){
            self.storyBoard = storyBoard
            self.signupViewController = signupController
        }
        
         class MenuOptions: MenuViewCustomizable {
            var height: CGFloat = 30
            
            var backgroundColor: UIColor {
                return UIColor.clearColor()
            }
            
            var selectedBackgroundColor: UIColor {
                return UIColor.clearColor()
            }
            
            var displayMode: MenuDisplayMode {
//                return .Standard(widthMode: .Flexible, centerItem: false, scrollingMode: .PagingEnabled)
                return .SegmentedControl
//                return .Infinite(widthMode: .Flexible, scrollingMode: .PagingEnabled)
            }
            var focusMode: MenuFocusMode {
                return .Underline(height: 1, color: ApplicationColor.Color1, horizontalPadding: 0, verticalPadding: 0)
            }
            var menuControllerSet: MenuControllerSet {
                return .Single
            }
            var itemsOptions: [MenuItemViewCustomizable] {
                return [RegisterMenuItem(), VerifyOTPMenuItem()]
            }
        }
        
         class RegisterMenuItem: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "ACCOUNT CREATION", color:ApplicationColor.White, selectedColor:ApplicationColor.White, font: ApplicationFont.NormalTabFont!))
            }
        }
         class VerifyOTPMenuItem: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "OTP VERFICATION", color:ApplicationColor.White, selectedColor:ApplicationColor.White, font: ApplicationFont.NormalTabFont!))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customerCareLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.customerCareClicked))
        lblCustomerCare.userInteractionEnabled = true
        lblCustomerCare.addGestureRecognizer(customerCareLabelTapGesture)
        
        let imgBackgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.closeClicked))
        self.imgBackground.userInteractionEnabled = true
        self.imgBackground.addGestureRecognizer(imgBackgroundTapGesture)
        
        pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(PagingMenuOptions(storyBoard:self.storyboard, signupController: self))
    }

    func closeClicked(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SignupViewController: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        guard let previousController = previousMenuController as? RegisterViewController,  let currentController = menuController as? OTPVerificationViewController else {
            return
        }
        currentController.mobileNumber = UserRegistrationDetails.sharedInstance.customerMobile ?? ""
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}
