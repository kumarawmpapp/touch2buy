import UIKit

@IBDesignable class CollapseView: UIView {
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBInspectable var contentTitle: String = "Title goes here" {
        didSet {
            self.titleText?.text = contentTitle
        }
    }
    
    var expanded: Bool = true
    
    @IBOutlet weak var delegate: AnyObject?
    
    @IBOutlet weak var titleView:UIView?
    @IBOutlet weak var titleText:UILabel?
    
    @IBOutlet weak var contentView:UIView?
    
    @IBInspectable var expansionHeight:CGFloat = CGFloat(0)
    
    var contentViewFrame:CGRect?
    
    @IBOutlet weak var expansionConstraint: NSLayoutConstraint!
    @IBOutlet weak var collapseConstraint:NSLayoutConstraint!

    @IBOutlet weak var contentViewHeightConstraint:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        // when we are rendering in Interface builder, we draw a little box around
        // ourselves to make it a bit easier to see our expanded size. Note that this
        // code doesn't execute at runtime; only at development-time in IB
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        self.titleText?.backgroundColor = UIColor.redColor()
        self.titleView?.backgroundColor = UIColor.yellowColor()
        self.contentView?.backgroundColor = UIColor.orangeColor()
    }
    
    func collapseOrExpand(expand: Bool) {
        if expand {
            UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.contentViewHeightConstraint.constant = self.expansionHeight
                }, completion: nil)
            
        }
        else {
            UIView.animateWithDuration(1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.contentViewHeightConstraint.constant = 0
                }, completion: nil)
            
        }
        self.expanded = expand
        
        // call the delegate - if it is set, and if it implements the correct func
        self.delegate?.collapseView?(self, didExpand: self.expanded)
    }
    
    @IBAction func toggleExpand(sender: AnyObject?) {
        self.collapseOrExpand(!self.expanded)
    }
    
    func xibSetup() {
        view = loadViewFromNib()

        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CollapseView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
//    override func updateConstraints() {
//        if self.expanded {
//            self.collapseConstraint.active = false
//            self.expansionConstraint.active = true
//        }else
//        {
//            self.expansionConstraint.active = false
//            self.collapseConstraint.active = true
//        }
//        super.updateConstraints()
//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    
    // If you add custom drawing, it'll be behind any view loaded from XIB
    
    
    }
    */
    
}

@objc protocol CollapseViewDelegate {
    optional func collapseView(collapseView: CollapseView, didExpand expanded: Bool)
}