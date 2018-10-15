//
//  CardView.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class NamedImage: UIImage {
    var imageName: String!
    convenience init?(imageName: String) {
        guard let image = UIImage(named: imageName, in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            return nil
        }
        
        guard let cgimage = image.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgimage)
        self.imageName = imageName
    }
}

@IBDesignable
class CardView: UINibView {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    var openedImage:UIImage?
    let closedImage:UIImage = NamedImage(imageName: "card_bg")!
    
    func openCard(animated: Bool) {
        cardImageView.image = openedImage
        if (animated) {
            UIView.transition(with: cardImageView, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    func closeCard(animated: Bool) {
        cardImageView.image = closedImage
        if (animated) {
            UIView.transition(with: cardImageView, duration: 0.4, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
    func isOpened() -> Bool {
        guard let image = cardImageView.image  else {
            return false
        }
        
        guard let namedImage = image as? NamedImage else {
            return true
        }
        
        guard namedImage.imageName == "card_bg" else {
            return true
        }
        
        return false
    }
    
}

