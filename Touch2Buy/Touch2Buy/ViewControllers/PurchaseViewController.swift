//
//  PurchaseViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/26/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit
import RMDateSelectionViewController
import ActionSheetPicker_3_0
import MZFormSheetPresentationController
import Google
import SCLAlertView

class AddressTextField: DefaultTextField {
    var isVisible = false
}

class AddressDropDown: GeneralDropDown {
    var isVisible = false
    var selectedItem:Address?
}

class CitiesTextField: TextFieldDropDown {
    var isVisible = false
    var selectedItem:City?
}

class AreasTextField: TextFieldDropDown {
    var isVisible = false
    var selectedItem:Area?
}

class PurchaseViewController: BaseTableViewController, UITextFieldDelegate {
    @IBOutlet weak var shopingItemsContainerView: UIView!
    
    @IBOutlet weak var paymentMethodsDropDown: GeneralDropDown!
    @IBOutlet weak var deliveryOptionSegment: UISegmentedControl!
    
    @IBOutlet weak var addressSelectionSegment: UISegmentedControl!
    @IBOutlet weak var addressDropDown: AddressDropDown!
    @IBOutlet weak var addressText: AddressTextField!
    @IBOutlet weak var areasTextField: AreasTextField!
    @IBOutlet weak var citiesTextField: CitiesTextField!
    
    @IBOutlet weak var branchesDropDown: GeneralDropDown!
    @IBOutlet weak var pickupTimeDropDown: DefaultButton!
    @IBOutlet weak var lblDisclaimer: UILabel!
    
    @IBOutlet weak var btnConfirm: DefaultButton!
    
    @IBAction func deliveryOptionValueChanged(sender: UISegmentedControl) {
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
    }
    
    @IBAction func addressSelectionValueChanged(sender: UISegmentedControl) {
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
    }
    
    @IBAction func btnSubmitClicked(sender: UIButton) {
        
        if cart.cartIsEmpty {
            SCAlertViewHelper.showInfo("", subtitle: "Cart is empty")
            return
        }else if pickupBranch?.branchOpenClosedState == BranchOpenCloseStates.BranchStateClosed {
            SCAlertViewHelper.showInfo("", subtitle: "Sorry Branch is Closed")
            return
        }else if pickupTime == nil {
            SCAlertViewHelper.showInfo("", subtitle: "Select a pickup time")
            return
        }
        
        orderRequest.branchId = pickupBranch?.branchId
        orderRequest.expectedTime = pickupTime
        
        orderRequest.paymentMethod = paymentMethod?.id
        
        if self.deliveryOptionSegment.selectedSegmentIndex == 0 {
            orderRequest.deliveryOption = "1"

            OrdersDataManager.sharedInstance.sendNewOrder(orderRequest)
        }
        else {
            orderRequest.deliveryOption = "2"
            
            if addressDropDown.isVisible {
                if let selectedAddress = addressDropDown.selectedItem {
                    address.addressLine = selectedAddress.addressLine
                    address.areaId = selectedAddress.areaId
                    address.areaName = selectedAddress.areaName
                    address.city = selectedAddress.city
                }
            }else{
                if addressText.isVisible {
                    address.addressLine = addressText.text
                }
                if areasTextField.isVisible {
                    address.areaName = areasTextField.selectedItem?.areaName
                    address.areaId = areasTextField.selectedItem?.areaId
                }
                if citiesTextField.isVisible {
                    address.city = citiesTextField.selectedItem?.cityName
                }
            }
            
            
            
            if ((address.addressLine == nil || address.addressLine?.characters.count == 0)) {
                SCAlertViewHelper.showInfo("", subtitle: "Please provide an address for delivery")
                addressText.becomeFirstResponder()
                return
            }else if address.city == nil {
                SCAlertViewHelper.showInfo("", subtitle: "Please select a city")
                return
            }
            
            orderRequest.address = address
            
            OrdersDataManager.sharedInstance.requestDeliveryCharge(address, order: orderRequest)
        }
        self.btnConfirm.enabled = false
    }
    
    @IBAction func btnPickupTimeClicked(sender: UIButton) {
        
        dateAndTimeClicked()
    }
    
    var currentUser = ApplicationSession.sharedInstance.currentUser!
    var cart = ApplicationSession.sharedInstance.cart!
    var currentOrganization = ApplicationSession.sharedInstance.currentOrganization!
    
    var paymentMethod:PaymentMethod?
    var pickupBranch:Branch?
    var pickupTime:String?
    var address:Address = Address()
    var citiesarray = [City]()
    var filteredCitiesArray = [City]()
    var areasarray = [Area]()
    var filteredAreasArray = [Area]()
    var delivaryDateTime:NSDate = NSDate()
    
    let tracker = GAI.sharedInstance().defaultTracker
    
    let orderRequest = OrderRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addCartViewController()
        
//        fillBranchPaymentMethods()
        requestCommonPaymentMethods()
        
        
        
        fillAddressesDropDown()
        
        fillCitiesDropDown()
        
        addressText.trueDelegate = self
        areasTextField.trueDelegate = self
        citiesTextField.trueDelegate = self
        citiesTextField.addTarget(self, action: #selector(PurchaseViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        areasTextField.addTarget(self, action: #selector(PurchaseViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        lblDisclaimer.text = "Minimum time to prepare an order is " + currentOrganization.minOrderTime + "min. Time to deliver will be decided based on your recieving location."
        
    }
    
    override func viewWillAppear(animated: Bool) {
        OrdersDataManager.sharedInstance.registerForData(self)
        super.viewWillAppear(animated)
        self.requestBranches()
    }
    
    override func viewWillDisappear(animated: Bool) {
        PublicDataManager.sharedInstance.unregisterForData(self)
        OrganizationDataManager.sharedInstance.unregisterForData(self)
        OrdersDataManager.sharedInstance.unregisterForData(self)
        super.viewWillDisappear(animated)
    }
    
    override func responseReceived(response:BaseResponse){
        if let _ = response as? PaymentMethodsResponse {
//            fillBranchPaymentMethods()
        }else if let _ = response as? OrganizationBranchesResponse {
            fillBranchesDropDown()
        }else if let _ = response as? CitiesResponse {
            fillCitiesDropDown()
        }else if let areasResposne = response as? AreasResponse {
            areasarray = areasResposne.areas
            fillAreasDropDown()
        }else if let availablePayMethodsResponse = response as? AvailableChannelPayMethodsResponse {
            fillChannelPaymentMethods(availablePayMethodsResponse.paymentMethods)
        }else if let orderResponse = response as? OrderResponse {
            self.btnConfirm.enabled = true
            if let status = orderResponse.status {
                if status == 1 {
                    
                    if orderResponse.deliveryOption == "2" {
                        if !(addressDropDown.isVisible) {
                            UserDataManager.sharedInstance.saveAddress(address)
                            currentUser.addresses.append(address)
                        }
                    }
                    
                    showConfirmationView(orderResponse)
                    
                    cart.clearAll()
                    self.tableView.reloadData()
                    
                    sendToGoogleAnalytics(orderResponse)
                }
            }
            
            
            
        }else if let _ = response as? SaveAddressResponse {
            currentUser.addresses.append(address)
        }else if let deliveryresponse = response as? DeliveryChargeResponse {
            if deliveryresponse.status == -1 {
                SCAlertViewHelper.showError("", subtitle: deliveryresponse.rejectReason ?? "")
                self.btnConfirm.enabled = true
            }else{
                let deliverychargesdetails = "Delivery Charge : " + deliveryresponse.discountedValue.priceString
                
                var SCalert = SCAlertViewHelper.getSCAlert()
                
                SCalert.addButton("Confirm", action: {
                    self.orderRequest.deliveryCharges = deliveryresponse.discountedValue
                    OrdersDataManager.sharedInstance.sendNewOrder(self.orderRequest)
                })
                SCalert.showInfo("Delivery Charges", subTitle: deliverychargesdetails, closeButtonTitle: "Cancel")
                self.btnConfirm.enabled = true
            }
        }
        super.responseReceived(response)
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        if textField == citiesTextField {
            let filteredString:String = citiesTextField.text!
            
            if filteredString.characters.count > 0 {
                filteredCitiesArray = citiesarray.filter({ (element) -> Bool in
                    return element.cityName.lowercaseString.containsString(filteredString.lowercaseString)
                })
            }
            
            citiesTextField.dataSource = filteredCitiesArray.map({ (element) -> String in
                element.cityName
            })
            if filteredCitiesArray.count > 0 {
                citiesTextField.showDropDown()
            }
            
            
        }else if textField == areasTextField {
            let filteredString:String = areasTextField.text!
            
            
            if filteredString.characters.count > 0 {
                filteredAreasArray = areasarray.filter({ (element) -> Bool in
                    return element.areaName.lowercaseString.containsString(filteredString.lowercaseString)
                })
            }
            
            areasTextField.dataSource = filteredAreasArray.map({ (element) -> String in
                return element.areaName ?? ""
            })
            if filteredAreasArray.count > 0 {
                areasTextField.showDropDown()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == citiesTextField {
            filteredCitiesArray.removeAll()
            filteredCitiesArray.appendContentsOf(citiesarray)
            citiesTextField.selectedItem = nil
        }else if textField == areasTextField {
            filteredAreasArray.removeAll()
            filteredAreasArray.appendContentsOf(areasarray)
            areasTextField.selectedItem = nil
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField == citiesTextField {
            
        }else if textField == areasTextField {
            
        }
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
    
    func dateAndTimeClicked() {
        addressText.resignFirstResponder()
        
        if let branch = pickupBranch {
            if branch.branchOpenClosedState == BranchOpenCloseStates.BranchStateClosed {
                SCAlertViewHelper.showInfo("", subtitle: "Sorry Branch is Closed")
            }else if branch.branchOpenClosedState == BranchOpenCloseStates.BranchStateOpen {
                var pickuptimesavailable = false
                
                let dateformatter = NSDateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd"
                
                let datetimeformatter = NSDateFormatter()
                datetimeformatter.dateFormat = "yyyy-MM-ddHH:mm"
                
                let timeformatter = NSDateFormatter()
                timeformatter.dateFormat = "HH:mm"
                
                let displayabletimeformatter = NSDateFormatter()
                displayabletimeformatter.dateFormat = "hh:mm a"
                
                let currentTime = NSDate()
                
                
                    if let mininterval:Double = Double(currentOrganization.minOrderTime) {
                            let firstTimeItem = NSDate(timeInterval: mininterval*60, sinceDate: currentTime)
                            
                                let datePicker = ActionSheetDatePicker(title:"", datePickerMode: UIDatePickerMode.Time, selectedDate: firstTimeItem, doneBlock: {
                                    picker, value, index in
                                    if let date = value as? NSDate {
                                        self.pickupTime = dateformatter.stringFromDate(currentTime)+" "+timeformatter.stringFromDate(date)
                                        self.pickupTimeDropDown.setTitle("Pick at "+displayabletimeformatter.stringFromDate(date), forState: .Normal)
                                    }
                                    }, cancelBlock: { ActionStringCancelBlock in return }, origin: pickupTimeDropDown.superview!.superview)
                                
                                //        datePicker.timeZone = NSTimeZone(name: "UTC")
                                
                                
                                datePicker.minuteInterval = 1
                                
                                datePicker.minimumDate = firstTimeItem
                                
                                datePicker.showActionSheetPicker()
                                pickuptimesavailable = true
                        }
                        if !pickuptimesavailable {
                    SCAlertViewHelper.showInfo("", subtitle: "No Valid Picup Time.")
                }

            }
            
        }else{
            SCAlertViewHelper.showInfo("No open branches", subtitle: "Branch is not selected or selected branch is closed")
        }
    }
    
    func getBranches()->[Branch]{
        if let org = ApplicationSession.sharedInstance.currentOrganization {
            return org.organizationBranches
        }
        return [Branch]()
        
    }
    
    func requestCommonPaymentMethods() {
        if PublicDataManager.sharedInstance.getPaymentMethods().count == 0 {
            PublicDataManager.sharedInstance.registerForData(self)
            PublicDataManager.sharedInstance.requestPaymentMethods()
        }
    }
    
    func requestChanelPaymentMethods() {
        if let branch = pickupBranch {
            OrganizationDataManager.sharedInstance.registerForData(self)
            OrganizationDataManager.sharedInstance.requestAvailablePayMethods(branch.branchId)
        }
    }
    
    func requestBranches() {
        OrganizationDataManager.sharedInstance.registerForData(self)
        OrganizationDataManager.sharedInstance.requestOrganizationBranches((ApplicationSession.sharedInstance.currentOrganization?.orgId)!)
    }
    
    func fillBranchesDropDown() {
            let brancharray = self.getBranches()
            
            if brancharray.count > 0 {
                branchesDropDown.dataSource = brancharray.map({ (element:Branch) -> String in
                    return element.branchName + {
                        if element.branchOpenClosedState == .BranchStateClosed {
                            return " (closed now)"
                        }
                        return ""
                        }()
                })
                
                func selectedBranchAtIndex(index:Int){
                    self.pickupBranch = brancharray[index]
                    self.branchesDropDown.captionLabelText = (self.pickupBranch?.branchName)!
                    self.requestChanelPaymentMethods()
                    
                    if let mininterval:Double = Double(currentOrganization.minOrderTime) {
                        let currentTime = NSDate()
                        let firstTimeItem = NSDate(timeInterval: mininterval*60, sinceDate: currentTime)
                        let dateformatter = NSDateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd"
                        
                        let datetimeformatter = NSDateFormatter()
                        datetimeformatter.dateFormat = "yyyy-MM-ddHH:mm"
                        
                        let timeformatter = NSDateFormatter()
                        timeformatter.dateFormat = "HH:mm"
                        
                        let displayabletimeformatter = NSDateFormatter()
                        displayabletimeformatter.dateFormat = "hh:mm a"
                        
                        self.pickupTime = dateformatter.stringFromDate(currentTime)+" "+timeformatter.stringFromDate(firstTimeItem)
                        self.pickupTimeDropDown.setTitle("Pick at "+displayabletimeformatter.stringFromDate(firstTimeItem), forState: .Normal)
                    }
                    
                    
                }
                
                branchesDropDown.dropDownSelectionAction = {(index)->() in
                    if let selectedbranch:Branch = brancharray[index] as? Branch {
                        if selectedbranch.branchOpenClosedState == BranchOpenCloseStates.BranchStateOpen {
                            selectedBranchAtIndex(index)
                        }else{
                            SCAlertViewHelper.showInfo("Branch closed", subtitle: "Sorry Branch is Closed.")
                        }
                    }
                }
                
                var allbranchesareclosed = true
                for (index, element) in brancharray.enumerate() {
                    if element.branchOpenClosedState == .BranchStateOpen {
                        selectedBranchAtIndex(index)
                        allbranchesareclosed = false
                        break
                    }
                }
                if allbranchesareclosed {
                    var SCalert = SCAlertViewHelper.getSCAlert()
                    SCalert.addButton("Go Back", action: { 
                        self.parentViewController?.performSegueWithIdentifier("purchasetocompanies", sender: nil)
                    })
                    SCalert.showCloseButton = false
                    SCalert.showInfo("No Open Branches", subTitle: "Sorry Branch is Closed. Please try later.")
                }
            }
    }
    
    func fillBranchPaymentMethods() {
        var paymentmethodsarray:Array<PaymentMethod>!
        
        if pickupBranch?.paymentMethods.count > 0 {
            paymentmethodsarray = (pickupBranch?.paymentMethods)!
            
        }else if PublicDataManager.sharedInstance.getPaymentMethods().count == 0 {
            PublicDataManager.sharedInstance.registerForData(self)
            PublicDataManager.sharedInstance.requestPaymentMethods()
        }else{
            paymentmethodsarray = PublicDataManager.sharedInstance.getPaymentMethods()
        }
        
        if paymentmethodsarray?.count > 0 {
            self.fillPaymentMethodsDropDown(paymentmethodsarray)
        }
    }
    
    func fillChannelPaymentMethods(payarray:Array<PaymentMethod>?) {
        if let paymentmethodsarray = payarray {
            self.fillPaymentMethodsDropDown(paymentmethodsarray)
        }
    }
    
    func fillPaymentMethodsDropDown(paymentmethodsarray:Array<PaymentMethod>) {
        paymentMethodsDropDown.dataSource = paymentmethodsarray.map({ (element) -> String in
            element.description
        })
        
        func selectedPaymentMethodAtIndex(index:Int){
            self.paymentMethod = paymentmethodsarray[index]
            self.paymentMethodsDropDown.captionLabelText=(self.paymentMethod?.description)!
        }
        
        paymentMethodsDropDown.dropDownSelectionAction = {(index)->() in
            selectedPaymentMethodAtIndex(index)
        }
        if paymentmethodsarray.count>0 {
            selectedPaymentMethodAtIndex(0)
        }else{
            self.paymentMethod = nil
            self.paymentMethodsDropDown.captionLabelText=""
        }
    }
    
    func fillCitiesDropDown() {
        if PublicDataManager.sharedInstance.getCities().count == 0 {
            PublicDataManager.sharedInstance.registerForData(self)
            PublicDataManager.sharedInstance.requestCities()
        }else{
            citiesarray = PublicDataManager.sharedInstance.getCities()
            
            citiesTextField.dataSource = citiesarray.map({ (element) -> String in
                element.cityName
            })
            
            func selectedCityAtIndex(index:Int){
                citiesTextField.selectedItem = filteredCitiesArray[index]
                self.citiesTextField.text = citiesTextField.selectedItem?.cityName ?? ""
                self.requestAreasForCity(citiesTextField.selectedItem)
            }
            
            citiesTextField.textFieldDropDownSelectionAction = {(index)->() in
                selectedCityAtIndex(index)
            }
//            self.citiesDropDown.captionLabelText = "City"
        }
        
        
    }
    
    func requestAreasForCity(city:City?) {
        PublicDataManager.sharedInstance.registerForData(self)
        PublicDataManager.sharedInstance.requestAreas(citiesTextField.selectedItem?.cityId)
    }
    
    func fillAreasDropDown() {
        
            areasTextField.dataSource = areasarray.map({ (element) -> String in
                element.areaName
            })
            
            func selectedAreaAtIndex(index:Int){
                areasTextField.selectedItem = filteredAreasArray[index]
                self.areasTextField.text = areasTextField.selectedItem?.areaName ?? ""
            }
            
            areasTextField.textFieldDropDownSelectionAction = {(index)->() in
                selectedAreaAtIndex(index)
            }
            //            self.citiesDropDown.captionLabelText = "City"
    }
    
    func fillAddressesDropDown() {
        if currentUser.addresses.count > 0 {
            addressDropDown.dataSource = currentUser.addresses.map({ (element) -> String in
                return element.apendedAddress
            })
            
            func selectedAddressAtIndex(index:Int){
                self.addressDropDown.selectedItem = self.currentUser.addresses[index]
                self.addressDropDown.captionLabelText = self.addressDropDown.selectedItem?.apendedAddress ?? ""
            }
            
            addressDropDown.dropDownSelectionAction = {(index)->() in
                selectedAddressAtIndex(index)
            }
            selectedAddressAtIndex(0)
        }
    }
    
    func showConfirmationView(response:OrderResponse) {
        var storyboard = self.storyboard
        if (storyboard == nil) {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        if let confirmationview = storyboard?.instantiateViewControllerWithIdentifier("OrderConfirmationViewController") as? OrderConfirmationViewController {
            confirmationview.orderResponse = response
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: confirmationview)
        formSheetController.presentationController?.contentViewSize = CGSizeMake(300, 400)
        formSheetController.presentationController?.shouldCenterVertically = true
        self.presentViewController(formSheetController, animated: true, completion: nil)
        }
    }
    
    func sendToGoogleAnalytics(orderResponse:OrderResponse) {
//        tracker.send(GAIDictionaryBuilder.createTransactionWithId(String(orderResponse.cartId), affiliation: orderResponse.customerName, revenue: orderResponse.totalValue, tax: 0, shipping: 0, currencyCode: "LKR").build() as [NSObject : AnyObject])
        
        let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-76808708-1")
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("Ecommerce", action: "Purchase", label: nil, value: nil)
        
        
        let product = GAIEcommerceProduct()
        
        
//        [product setId:@"P12345"];
//        [product setName:@"Android Warhol T-Shirt"];
//        [product setCategory:@"Apparel/T-Shirts"];
//        [product setBrand:@"Google"];
//        [product setVariant:@"Black"];
//        [product setPrice:@29.20];
//        [product setCouponCode:@"APPARELSALE"];
//        [product setQuantity:@1];
        
        let action = GAIEcommerceProductAction()
        action.setAction(kGAIPAPurchase)
        action.setTransactionId(String(orderResponse.cartId))
        action.setAffiliation(OrganizationDataManager.sharedInstance.getOrganizationById(orderResponse.organizationId)?.displayName)
        action.setRevenue(orderResponse.totalNetValue)
        
        builder.setProductAction(action)
        
        tracker.send(builder.build() as [NSObject : AnyObject])
       
//        [builder addProduct:product];
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            if deliveryOptionSegment.selectedSegmentIndex == 0 {
                return "Pickup Details"
            }else if deliveryOptionSegment.selectedSegmentIndex == 1 {
                return "Delivery Details"
            }
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if deliveryOptionSegment.selectedSegmentIndex == 0 {
                return 1
            }else if deliveryOptionSegment.selectedSegmentIndex == 1 {
                if addressSelectionSegment.selectedSegmentIndex == 0 {
                    return 3
                }else if addressSelectionSegment.selectedSegmentIndex == 1 {
                    return 3
                }
            }
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if deliveryOptionSegment.selectedSegmentIndex == 0 {
                return 134
            }else if deliveryOptionSegment.selectedSegmentIndex == 1 {
                if indexPath.row == 1 {
                    if addressSelectionSegment.selectedSegmentIndex == 0 {
                        return 50
                    }else if addressSelectionSegment.selectedSegmentIndex == 1 {
                        return 134
                    }
                }
            }
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            if deliveryOptionSegment.selectedSegmentIndex == 0 {
                return super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: indexPath.section))
            }else if deliveryOptionSegment.selectedSegmentIndex == 1 {
                if addressSelectionSegment.selectedSegmentIndex == 0 {
                    addressText.isVisible = false
                    areasTextField.isVisible = false
                    citiesTextField.isVisible = false
                    addressDropDown.isVisible = true
                    if indexPath.row == 2 {
                        return super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: indexPath.section))
                    }
                }else if addressSelectionSegment.selectedSegmentIndex == 1 {
                    addressText.isVisible = true
                    areasTextField.isVisible = true
                    citiesTextField.isVisible = true
                    addressDropDown.isVisible = false
                    if indexPath.row > 0 {
                        return super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: (indexPath.row+1), inSection: indexPath.section))
                    }
                }
            }
        }
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}
