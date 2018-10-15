//
//  GameBarView.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

@IBDesignable
class GameBarView: UINibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rightActionBtn: UIButton!
    
    @IBInspectable open var rightActionBtnText:String? {
        didSet {
            self.rightActionBtn?.setTitle(self.rightActionBtnText ,for: UIControlState.normal)
        }
    }
    
    @IBInspectable open var titleLabelText:String? {
        didSet {
            self.titleLabel?.text = self.titleLabelText
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.rightActionBtn?.setTitle(self.rightActionBtnText, for: UIControlState.normal)
        self.titleLabel?.text = self.titleLabelText
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.rightActionBtn?.setTitle(self.rightActionBtnText, for: UIControlState.normal)
        self.titleLabel?.text = self.titleLabelText
    }
}

