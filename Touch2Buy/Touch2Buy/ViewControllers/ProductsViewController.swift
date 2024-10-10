//
//  ProductsViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/7/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import MZFormSheetPresentationController

class ProductCategoryDropDown: GeneralDropDown {
    var selectedItem:ProductCategory?
    
    override func setup() {
        super.setup()
        let font = UIFont(name: (captionLabel.font?.fontName)! + "-bold", size: captionLabel.font.pointSize)
        captionLabel.font = font
        
        captionLabel.textColor = ApplicationColor.Color1
    }
}

class ProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var productItemName: UILabel!
    @IBOutlet weak var productItemPrice: UILabel!
    @IBOutlet weak var productItemQty: QtyDropDown!
    @IBOutlet weak var productItemImage: UIImageView!
    @IBOutlet weak var productItemDescription: UILabel!
    @IBOutlet weak var productItemDiscountedPrice: UILabel!
    @IBOutlet weak var sizeDropDown: GeneralDropDown!
    @IBOutlet weak var addButton: ProductItemsAddButton! {
        didSet {
//            addButton.setImage(UIImage(named: "addItem_active"), forState: .Normal)
//            addButton.setImage(UIImage(named: "addItem_disabled"), forState: .Disabled)
        }
    }
    
    @IBAction func addButtonClicked(sender: UIButton?) {
        currentCart.addItem(self.showingSubProductItem, qty: self.showingQty)
        self.addButton.enabled = false
        self.addClicked()
    }
    
    var showingQty:Int = 1
    var showingSubProductItem:ProductItem!
    var currentCart = ApplicationSession.sharedInstance.cart!
    var productItem:ProductItem! {
        didSet {
            productItemName.text = productItem.itemName
            productItemDescription.text=productItem.description
            sizeDropDown.dataSource = [String]()
            
            
            
            if productItem.products.count>0 {
                sizeDropDown.dataSource = productItem.products.map({ (element) -> String in
                    return element.sizeName
                })
                
                sizeDropDown.dropDownSelectionAction = {(index)->() in
                    self.showingSubProductItem = self.productItem.products[index]
                    self.setValuesForSubItem()
                }
                
                showingSubProductItem = productItem.products[0]
                self.setValuesForSubItem()
                
                productItemQty.QtyDropDownValueChanged = {(qty) in
                    self.showingQty = qty
                    self.addButton.enabled = true
                }
            } else if productItem.products.count==0 {
                productItemDiscountedPrice.text = "Not Available"
                if let urlString = (productItem.imageUrl?.urlString()) {
                    productItemImage.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
                }
            }
            
            sizeDropDown.hidden = (productItem.products.count==0)
            productItemQty.hidden = (productItem.products.count==0)
            addButton.hidden = (productItem.products.count==0)
            productItemPrice.hidden = (productItem.products.count==0)
        }
    }
    var addClicked:(()->())!
    
    func setValuesForSubItem(){
        let item = showingSubProductItem
        
        if let urlString = (item.imageUrl?.urlString()) {
            productItemImage.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
        
        productItemPrice.text = ""
        
        if item.originalPrice != item.finalPrice {
            let priceString: NSMutableAttributedString =  NSMutableAttributedString(string: item.originalPrice.priceString)
            priceString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, priceString.length))
            priceString.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans-Italic", size: 15)!, range: NSMakeRange(0, priceString.length))
            productItemPrice.attributedText = priceString
        }
        
        productItemDiscountedPrice.text = item.finalPrice.priceString
        
        sizeDropDown.captionLabelText = item.sizeName
        
        self.addButton.enabled = true
        
        for cartItem:CartItem in currentCart.getCartItems() {
            if cartItem.cartItemProduct.foodProductId == item.foodProductId && cartItem.cartItemProduct.sizeId == item.sizeId {
                self.addButton.enabled = false
                break
            }
        }
    }
}

class ProductsViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productItemsView: UICollectionView!
    @IBOutlet weak var productsCategoryDropDown: ProductCategoryDropDown!
    @IBOutlet weak var viewCartButton: DefaultButton!
    
    @IBAction func cartClicked(sender: AnyObject) {
        performSegueWithIdentifier("cartToPurchase4", sender: self)
    }
 
    var organizationID:Int!
    var productsDictionary = Dictionary<Int, Array<ProductItem>>()
    
    var collectionItemsCount:Int {
        return getArrayForSelectedCategory().count
    }
    var currentCart = ApplicationSession.sharedInstance.cart!
    var productCategoriesArray = [ProductCategory]()
    var loadMore = false
    let DefaultCategoryID = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrganizationDataManager.sharedInstance.requestOrganizationItemsCategories(organizationID)
        self.requestItemsForSelectedCategory()
        
        
        fillProductCateoriesDropDown(nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        OrganizationDataManager.sharedInstance.registerForData(self)
        
        self.setTitleForViewCartButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        OrganizationDataManager.sharedInstance.unregisterForData(self)
    }
    
    class func instantiateFromStoryboard(storyboard:UIStoryboard?) -> ProductsViewController? {
        return storyboard?.instantiateViewControllerWithIdentifier("ProductsViewController") as? ProductsViewController
    }
    
    override func responseReceived(response:BaseResponse){
        if let categoriesResponse = response as? OrganizationItemsCategoriesResponse {
            fillProductCateoriesDropDown(categoriesResponse.organizationItemsCategories)
        }else if let itemsbycategoryResponse = response as? OrganizationItemsByPublishedCategoriesResponse {
            if let requestobject = itemsbycategoryResponse.requestObject as? OrganizationItemsByPublishedCategoriesRequest {
                updateDataForCategoryID(requestobject.catId, pitems: itemsbycategoryResponse.organizationItems)
            }
            fillProductItems()
            if itemsbycategoryResponse.recordCount > collectionItemsCount {
                loadMore = true
            }else{
                loadMore = false
            }
        }else if let itemsResponse = response as? OrganizationItemsResponse {
            updateDataForCategoryID(DefaultCategoryID, pitems: itemsResponse.organizationItems)
            fillProductItems()
            if itemsResponse.recordCount > collectionItemsCount {
                loadMore = true
            }else{
                loadMore = false
            }
        }
        super.responseReceived(response)
    }
    
    private func fillProductItems(){
        productItemsView.reloadData()
    }
    
    private func updateDataForCategoryID(category_id:Int, pitems:Array<ProductItem>?){
        guard let parray = pitems where parray.count > 0 else {
            return
        }
        
        if var existingitemsarray = productsDictionary[category_id] {
            existingitemsarray.appendContentsOf(parray)
            productsDictionary.updateValue(existingitemsarray, forKey: category_id)
        }else{
            productsDictionary.updateValue(parray, forKey: category_id)
        }
    }
   
    func fillProductCateoriesDropDown(cateogriesArray:Array<ProductCategory>?) {
        productCategoriesArray.removeAll()
        productCategoriesArray.append(ProductCategory(categoryId: DefaultCategoryID, categoryName: "Show Me All"))
        
        if cateogriesArray != nil {
            productCategoriesArray.appendContentsOf(cateogriesArray!)
        }
        
        productsCategoryDropDown.dataSource = productCategoriesArray.map({ (element) -> String in
            element.categoryName
        })
        
        func selectedCategoryAtIndex(index:Int){
            self.productsCategoryDropDown.selectedItem = productCategoriesArray[index]
            self.productsCategoryDropDown.captionLabelText = self.productsCategoryDropDown.selectedItem?.categoryName ?? ""
            self.requestItemsForSelectedCategory()
            
            fillProductItems()
        }
        
        productsCategoryDropDown.dropDownSelectionAction = {(index)->() in
            selectedCategoryAtIndex(index)
        }
        
        self.productsCategoryDropDown.captionLabelText = "Show Me All"
        self.productsCategoryDropDown.selectedItem = productCategoriesArray[0]
    }
    
    func requestItemsForSelectedCategory() {
        guard let categoryid = self.productsCategoryDropDown.selectedItem?.categoryId where categoryid != DefaultCategoryID else {
            OrganizationDataManager.sharedInstance.requestOrganizationItems(organizationID, offset: collectionItemsCount)
            return
        }
        
        OrganizationDataManager.sharedInstance.requestOrganizationItemsByCategories(organizationID, category_id: (self.productsCategoryDropDown.selectedItem?.categoryId)!, offset: collectionItemsCount)
    }
    
    func getArrayForSelectedCategory() -> Array<ProductItem> {
        guard let productskey = productsCategoryDropDown.selectedItem?.categoryId, let productarray = productsDictionary[productskey] else {
            return Array<ProductItem>()
        }
        return productarray
    }
    
    func setTitleForViewCartButton() {
        self.viewCartButton.setTitle("View Cart (\(currentCart.getCartItems().count) Items)", forState: .Normal)
    }
    
    /*
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProductItemCell = tableView.dequeueReusableCellWithIdentifier("ProductItemCell") as! ProductItemCell
        if let pitem:ProductItem = productsArray[indexPath.row] {
            cell.productItem=pitem
            cell.addToCart = { (item, qty) in
                ShopingCart.sharedInstance.addItem(item, qty: qty)
            }
        }
        return cell
    }
    */
    
    func showProductDetailsView(productItem:ProductItem) {
        if let rootcontroller =  self.storyboard?.instantiateViewControllerWithIdentifier("ProductDetailsViewController") as? ProductDetailsViewController{
            rootcontroller.productItem = productItem
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: rootcontroller)
            
            if let formSheetControllerPresentationController = formSheetController.presentationController {
                formSheetControllerPresentationController.contentViewSize = rootcontroller.sizeofFormSheetInDeviceUnderBounds(UIScreen.mainScreen().bounds.size)
                formSheetControllerPresentationController.shouldDismissOnBackgroundViewTap = true
                formSheetControllerPresentationController.backgroundColor = ApplicationColor.Color1.colorWithAlphaComponent(0.9)
                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
//                formSheetControllerPresentationController.frameConfigurationHandler = { [weak formSheetController] view, currentFrame, isKeyboardVisible in
//                    if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
//                        return CGRectMake(currentFrame.origin.x, 200
//                            , currentFrame.size.width, currentFrame.size.height)
//                    }
//                    return currentFrame
//                };
            }
            
            self.presentViewController(formSheetController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == (collectionItemsCount-1) && loadMore {
            self.requestItemsForSelectedCategory()
        }
        
        let cell:ProductItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductItemCell", forIndexPath: indexPath) as! ProductItemCell
        if let pitem:ProductItem = getArrayForSelectedCategory()[indexPath.row] {
            cell.productItem=pitem
        }
        cell.addClicked = {() in
            self.setTitleForViewCartButton()
        }
        cell.layer.cornerRadius = 3
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 3).CGPath
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height:CGFloat = 0.0
        if let pitem:ProductItem = getArrayForSelectedCategory()[indexPath.row] {
            height = CGFloat((((pitem.description.characters.count)/40)-2)*20)
            if height<0 {
                height = 0.0
            }
        }
        return CGSizeMake(280.0, (120.0 + height))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if let pitem:ProductItem = getArrayForSelectedCategory()[indexPath.row] {
//            showProductDetailsView(pitem)
//        }
    }
    
}