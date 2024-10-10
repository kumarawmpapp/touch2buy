//
//  CollapsibleView.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 1/26/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

@IBDesignable class CollapsibleView : UIView {
    
    @IBInspectable var contentTitle: String = "Title goes here" {
        didSet {
            self.titleText.text = contentTitle
            updateConstraintsIfNeeded()
        }
    }

    var expanded: Bool = true

    @IBOutlet weak var delegate: AnyObject?
    
    var titleView = UIView(frame: CGRectZero)
    
    var titleDisclosureButton = UIButton(frame: CGRectZero)
    
    var titleText = UILabel(frame: CGRectZero)

    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.replaceContentView(oldValue, with:contentView)
        }
    }
    
    var expansionView = UIView(frame: CGRectZero)
    
    
    private var expansionHeight = CGFloat(0)
    
    private var expansionConstraint: NSLayoutConstraint!
    
    override func prepareForInterfaceBuilder() {
        // when we are rendering in Interface builder, we draw a little box around
        // ourselves to make it a bit easier to see our expanded size. Note that this
        // code doesn't execute at runtime; only at development-time in IB

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        self.titleDisclosureButton.backgroundColor = UIColor.blueColor()
        self.titleText.backgroundColor = UIColor.redColor()
        self.titleView.backgroundColor = UIColor.yellowColor()
        self.expansionView.backgroundColor = UIColor.orangeColor()
        
        self.updateConstraints()
    }
    
    override func updateConstraints() {
//        self.translatesAutoresizingMaskIntoConstraints = false
            self.titleView.translatesAutoresizingMaskIntoConstraints = false
                self.titleDisclosureButton.translatesAutoresizingMaskIntoConstraints = false
                self.titleText.translatesAutoresizingMaskIntoConstraints = false
            self.expansionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.titleDisclosureButton.setTitle(self.titleDisclosureButtonText(), forState: .Normal)
        self.titleDisclosureButton.addTarget(self, action: "toggleExpand:", forControlEvents: .TouchUpInside)
        
        
        self.titleText.numberOfLines=0
        self.titleText.lineBreakMode = .ByCharWrapping;
        self.titleText.text = self.contentTitle
        
        self.titleView.addSubview(self.titleDisclosureButton)
        self.titleView.addSubview(self.titleText)
   
        self.addSubview(self.expansionView)
        self.addSubview(self.titleView)
        
        self.addConstraint(NSLayoutConstraint(item: self.titleDisclosureButton,attribute: .Width,relatedBy: .Equal,toItem: nil,attribute: .NotAnAttribute,multiplier: 1,constant: 50))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleDisclosureButton,attribute: .Height,relatedBy: .Equal,toItem: nil,attribute: .NotAnAttribute,multiplier: 1,constant: 50))
        
        self.titleView.addConstraint(NSLayoutConstraint(
            item: self.titleDisclosureButton,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: .Equal,
            toItem: self.titleView,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: 5))
        
        self.titleView.addConstraint(NSLayoutConstraint(
            item: self.titleText,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self.titleDisclosureButton,
            attribute: .Trailing,
            multiplier: 1,
            constant: 5))
        
        self.titleView.addConstraint(NSLayoutConstraint(
            item: self.titleText,
            attribute: .Trailing,
            relatedBy: .LessThanOrEqual,
            toItem: self.titleView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 5))
        
        self.titleView.addConstraint(NSLayoutConstraint(item: self.titleDisclosureButton, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self.titleView, attribute: .CenterY, multiplier: 1, constant: 0))
        self.titleView.addConstraint(NSLayoutConstraint(item: self.titleText, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self.titleView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        self.titleView.addConstraint(NSLayoutConstraint(item: self.titleView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self.titleDisclosureButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5))
        self.titleView.addConstraint(NSLayoutConstraint(item: self.titleView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self.titleText, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        
       self.addConstraint(NSLayoutConstraint(item: self.titleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.expansionView, attribute: .Top, relatedBy: .Equal, toItem: self.titleView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.expansionView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.expansionView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.expansionView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.expansionView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        let initialHeight = self.expanded ? self.expansionHeight : 0
        self.expansionConstraint = NSLayoutConstraint(item: self.expansionView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: initialHeight)
        self.expansionView.addConstraint(self.expansionConstraint)
        
        // and hand off to the superclass
        super.updateConstraints()
    }
    
    func replaceContentView(oldContentView: UIView?, with newView: UIView) {
        // if we already have an contentView, then we remove it now
        if let oldContentView = oldContentView {
            oldContentView.removeFromSuperview()
        }
        
        // add this view to the expansionView and hang on to whatever its height is
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.expansionView.addSubview(newView)
        self.expansionHeight = self.contentView.frame.height
        
        // make sure that this view fills the expansionView
        let views : [String: UIView] = ["view": newView]
        self.expansionView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.expansionView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }
    
   func collapseOrExpand(expand: Bool) {
        if expand {
            UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.expansionConstraint.constant = self.expansionHeight
                }, completion: nil)
            
        }
        else {
            UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.expansionConstraint.constant = 0
                }, completion: nil)
            
        }
        self.expanded = expand
        self.titleDisclosureButton.setTitle(self.titleDisclosureButtonText(), forState: .Normal)
        
        // call the delegate - if it is set, and if it implements the correct func
        self.delegate?.collapsibleView?(self, didExpand: self.expanded)
    }
    
    func toggleExpand(sender: AnyObject?) {
        self.collapseOrExpand(!self.expanded)
    }
    
    
    func titleDisclosureButtonText() -> String {
        return self.expanded ? "▼" : "►"
    }
}


@objc protocol CollapsibleViewDelegate {
    optional func collapsibleView(collapsibleView: CollapsibleView, didExpand expanded: Bool)
}