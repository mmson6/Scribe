//
//  AddressInfoCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class AddressInfoCell: UITableViewCell {

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.commonInit()
    }
//
//    private func commonInit() {
//        
//    }
}
