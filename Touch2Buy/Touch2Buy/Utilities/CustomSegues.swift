//
//  CustomSegues.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 1/11/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import UIKit

class CustomSegue1: UIStoryboardSegue {
    var originatingPoint:CGPoint!
    
    override func perform() {
        let sourceViewController=self.sourceViewController
        let destinationViewController=self.destinationViewController
        
        sourceViewController.view.addSubview(destinationViewController.view)
        
        destinationViewController.view.transform=CGAffineTransformMakeScale(0.05, 0.05)
        let originalCenter:CGPoint=destinationViewController.view.center
        destinationViewController.view.center = self.originatingPoint
        UIView .animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            destinationViewController.view.center = originalCenter
            }) { (finished) -> Void in
                destinationViewController.view.removeFromSuperview()
                sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
        }
    }
}
