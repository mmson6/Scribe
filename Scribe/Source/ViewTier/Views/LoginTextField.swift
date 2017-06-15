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
        self.layer.cornerRadius = 25
        self.tintColor = UIColor.white
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0));
        self.leftViewMode = .always
    }
}
