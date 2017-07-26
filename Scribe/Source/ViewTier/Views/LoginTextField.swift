//
//  LoginTextField.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

final class LoginTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateAttributes()
    }
        
    private func updateAttributes() {
//        self.layer.cornerRadius = 25
        self.tintColor = UIColor.scribeDesignTwoBlue
//        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0));
        self.leftViewMode = .always

        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
//            let templateImage =  clearButton.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            // Finally, set the image color
            clearButton.tintColor = UIColor.white
            
            self.drawBottomLine()
        }
    }
    
    private func drawBottomLine() {
        let border = CALayer()
        let borderWidth: CGFloat = 1
        border.borderColor = UIColor.scribeDesignTwoBlue.cgColor
        print("-------width check -------  \(self.frame.width)")
        border.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width+200, height: 1)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
