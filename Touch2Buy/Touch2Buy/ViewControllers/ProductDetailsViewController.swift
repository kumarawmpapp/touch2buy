//
//  ProductDetailsViewController.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 8/17/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class ProductDetailsViewController: BaseViewController {
    @IBOutlet weak var txtProductDetails: UITextView!
    @IBOutlet weak var imgProductImage: UIImageView!
    
    var productItem:ProductItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = (productItem.imageUrl?.urlString()) {
            imgProductImage.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
        
        var details = productItem.itemName + "\n\n" + productItem.description + "\n\n"
        
        for pitem in productItem.products {
            details.appendContentsOf(pitem.sizeName + "\t" + pitem.finalPrice.priceString + "\n")
        }
        
        txtProductDetails.text = details
    }
}