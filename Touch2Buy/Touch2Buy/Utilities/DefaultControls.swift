//
//  DefaultControls.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/3/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class DefaultTextField: UITextField, UITextFieldDelegate {
    var trueDelegate:UITextFieldDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate=self
        
//        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 1
//        self.layer.borderColor = ApplicationColor.TextFieldBorderColor.CGColor
        
        self.spellCheckingType = .No
        self.autocorrectionType = .No
        self.autocapitalizationType = .None
        self.returnKeyType = .Done
        
        if [.NumberPad, .PhonePad].contains(self.keyboardType) {
//            let accessorytoolbar = UIToolbar()
//            accessorytoolbar.items = [UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DefaultTextField.numberPadAccossoryCloseButtonClicked))]
            
            let accessoryButton = DefaultButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
            accessoryButton.layer.cornerRadius = 0
            accessoryButton.setTitle("Dismiss", forState: .Normal)
            accessoryButton.titleLabel?.font = ApplicationFont.NormalButtonFont
            accessoryButton.addTarget(self, action: #selector(DefaultTextField.numberPadAccossoryCloseButtonClicked), forControlEvents: .TouchUpInside)

            
            self.inputAccessoryView = accessoryButton
        }
        
        let bottomBorder = CALayer()
        
        let width = CGFloat(1.0)
        
        bottomBorder.borderColor = ApplicationColor.Black.CGColor
        
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.size.height - width, width:  self.bounds.size.width, height: self.bounds.size.height)
        
        bottomBorder.borderWidth = width
        
        self.layer.addSublayer(bottomBorder)
        
        self.layer.masksToBounds = true
    }
    
    override weak internal var delegate: UITextFieldDelegate? {
        didSet {
            if delegate !== self {
                trueDelegate=delegate
                self.delegate=self
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if trueDelegate?.textFieldShouldBeginEditing?(textField) != nil {
            return (trueDelegate?.textFieldShouldBeginEditing?(textField))!
        }else{
            return true
        }
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        trueDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        if trueDelegate?.textFieldShouldEndEditing?(textField) != nil {
        return (trueDelegate?.textFieldShouldEndEditing?(textField))!
        }else {
            return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        trueDelegate?.textFieldDidEndEditing?(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if trueDelegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string) != nil {
        return (trueDelegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string))!
        }else
        {
            return true
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
        if trueDelegate?.textFieldShouldClear?(textField) != nil {
        return (trueDelegate?.textFieldShouldClear?(textField))!
        }else
        {return true}
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.resignFirstResponder()
        if trueDelegate?.textFieldShouldReturn?(textField) != nil {
        
        return (trueDelegate?.textFieldShouldReturn?(textField))!
        }else {
            return true
        }
    }
    
    func numberPadAccossoryCloseButtonClicked() {
        self.resignFirstResponder()
    }
}

class DefaultButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.backgroundColor = ApplicationColor.Color2
        self.setTitleColor(ApplicationColor.White, forState: .Normal)
        self.titleLabel?.font = ApplicationFont.NormalButtonFont
    }
}

class CheckBoxButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setTitle(ApplicationFontUnicodes.checkMark, forState: .Normal)
            }else{
                self.setTitle("", forState: .Normal)
            }
        }
    }
    
    var checkBoxClickedCompletionHandler : ((checkBoxChecked:Bool)->(Void))?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = ApplicationFont.NormalCheckBoxFont
        
        self.layer.borderColor = ApplicationColor.Orange.CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.backgroundColor = ApplicationColor.White
        self.titleLabel?.textColor = ApplicationColor.Black
        self.addTarget(self, action: #selector(CheckBoxButton.checkBoxClicked(_:)), forControlEvents: .TouchUpInside)
    }
    
    func checkBoxClicked(sender: CheckBoxButton) {
        isChecked = !isChecked
        
        checkBoxClickedCompletionHandler?(checkBoxChecked: isChecked)
    }
}

class TextFieldView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = ApplicationColor.White.CGColor
        border.frame = CGRect(x: 0, y: self.bounds.size.height - width, width:  self.bounds.size.width, height: self.bounds.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class ProductItemsAddButton: DefaultButton {
    override func setup() {
        super.setup()
        
        self.setTitleColor(ApplicationColor.Color1, forState: .Normal)
        self.setTitleColor(ApplicationColor.White, forState: .Disabled)
        
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                self.backgroundColor = UIColor.clearColor()
                self.layer.borderColor = ApplicationColor.Color1.CGColor
                self.layer.borderWidth = 1
            }else{
                self.backgroundColor = ApplicationColor.Color3
                self.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }
}

class CartViewPriceQtyView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = ApplicationColor.Color1.CGColor
        self.layer.borderWidth = 1
    }
}