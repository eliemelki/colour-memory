//
//  UINibView.swift
//  UIModule
//
//  Created by Elie Melki on 16/04/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit


public extension UIView {
    
    private static let CONTENT_VIEW_TAG = 123490
    
    func applyNib() {
        let clazz = type(of: self)
        let nibname = String(describing: clazz)
        let bundle = Bundle(for: clazz)
        applyNib(bundle, nibname)
    }
    
    func applyNib(_ nibname: String?) {
        let clazz = type(of: self)
        let bundle = Bundle(for: clazz)
        applyNib(bundle, nibname)
    }
    
    func applyNib(_ bundle: Bundle?, _ nibname: String?) {
        
        if let contentView = self.viewWithTag(UIView.CONTENT_VIEW_TAG) {
            contentView.removeFromSuperview()
        }
        
        if let nibname = nibname {
            let nib = UINib(nibName: nibname, bundle: bundle)
            let views = nib.instantiate(withOwner: self, options: nil)
            
            if (views.count > 0) {
                let any = views[0]
                if let contentView = any as? UIView {
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.tag = UIView.CONTENT_VIEW_TAG
                    self.addSubview(contentView)
                    let viewDictionary = ["_contentView": contentView ]
                    let horizantalLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[_contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:viewDictionary)
                    let verticalLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[_contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:viewDictionary)
                    self.addConstraints(horizantalLayoutConstraint)
                    self.addConstraints(verticalLayoutConstraint)
                }
            }
        }
    }
}


open class UINibView : UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyNib()
    }
    
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    @IBInspectable
    open var nibname: String? {
        didSet {
            if (nibname != oldValue) {
                self.applyNib(nibname)
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if (self.nibname == nil) {
            self.applyNib()
        }
        
    }
    
    open override  func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
