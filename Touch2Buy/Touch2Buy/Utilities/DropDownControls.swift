//
//  GeneralDropDown.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 12/30/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import UIKit
import DropDown

class TextFieldDropDown: DefaultTextField {
    let dropDown = DropDown()
    
    var dataSource = [String](){
        didSet {
            dropDown.dataSource = dataSource
            dropDown.selectRowAtIndex(nil)
        }
    }
    
    var textFieldDropDownSelectionAction:((index:Index)->())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        dropDown.anchorView = self
        dropDown.direction = .Top
        dropDown.topOffset = CGPoint(x: 0, y:-50)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.text = self.dataSource[index]
            self.textFieldDropDownSelectionAction?(index: index)
        }
    }
    
    func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    func showDropDown() {
        if dropDown.hidden {
            dropDown.show()
        }
    }
    
    func dismissDropDown() {
        dropDown.hide()
    }
    
    override func textFieldDidBeginEditing(textField: UITextField)
    {
        if dropDown.hidden {
            dropDown.show()
        }
        super.textFieldDidBeginEditing(textField)
    }
    
    override func textFieldDidEndEditing(textField: UITextField)
    {
        dropDown.hide()
    }
}

@IBDesignable
class GeneralDropDown: UIView, UIGestureRecognizerDelegate {
    let dropDown = DropDown()
    let captionLabel = UILabel()
    let dropdownArrow = UIImageView(image: UIImage(named: "DropdownArrow"))
    var captionLabelText = "" {
        didSet {
            captionLabel.text=captionLabelText
            setNeedsLayout()
        }
    }
    
    var dataSource = [String](){
        didSet {
            dropDown.dataSource = dataSource
            dropDown.selectRowAtIndex(nil)
        }
    }
    
    var dropDownSelectionAction:((index:Index)->())?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        dropDown.anchorView = self
        dropDown.bottomOffset = CGPoint(x: 0, y:self.bounds.height)
        dropDown.backgroundColor = ApplicationColor.Color1
        
        dropDown.selectionAction = { [unowned self] (index, item) in
            if self.dropDownSelectionAction != nil {
                self.dropDownSelectionAction!(index: index)
            }
        }
        
        self.backgroundColor = UIColor.clearColor()
        
        captionLabel.numberOfLines = 1
        captionLabel.font = UIFont(name: "CenturyGothic", size: 14)
        captionLabel.minimumScaleFactor = 0.1
        
        dropdownArrow.tintColor = ApplicationColor.Black
        dropdownArrow.contentMode = .ScaleAspectFit
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(TextFieldDropDown.showOrDismiss(_:)))
        self.addGestureRecognizer(recognizer)
        
        addSubview(dropdownArrow)
        addSubview(captionLabel)
        
        let bottomBorder = CALayer()
        let topBorder = CALayer()
        
        let width = CGFloat(1.0)
        
        bottomBorder.borderColor = ApplicationColor.Black.CGColor
        topBorder.borderColor = ApplicationColor.Black.CGColor
        
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.size.height - width, width:  self.bounds.size.width, height: self.bounds.size.height)
        topBorder.frame = CGRect(x: 0, y: 0, width:  self.bounds.size.width, height: width)
        
        bottomBorder.borderWidth = width
        topBorder.borderWidth = width
        
        self.layer.addSublayer(bottomBorder)
        self.layer.addSublayer(topBorder)
        
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captionLabel.frame = CGRectMake(5, 5, bounds.size.width-22, bounds.size.height-10);
        dropdownArrow.frame = CGRectMake(bounds.size.width-17, 0, 11, bounds.size.height)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return captionLabel.bounds.size
    }
    
    func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    
}

class QtyDropDown: GeneralDropDown {
    var currentQuantity:Int = 1 {
        didSet {
            captionLabelText = "\(currentQuantity)"
        }
    }
    
    var QtyDropDownValueChanged:((qty:Int)->())?
    
    var QtyArray:[Int] = []
    
    override func setup() {
        super.setup()
        
        for index in 1...50 {
            QtyArray.append(index)
        }
        
        dataSource = QtyArray.map{String($0)}
        
        currentQuantity = QtyArray[0]
        
        dropDownSelectionAction = {(index)->() in
            if let selectedQty:Int = self.QtyArray[index] {
                self.currentQuantity = selectedQty
                
                if self.QtyDropDownValueChanged != nil {
                    self.QtyDropDownValueChanged!(qty: self.currentQuantity)
                }
            }
        }
    }
}
