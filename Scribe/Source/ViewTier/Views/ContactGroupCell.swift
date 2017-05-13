//
//  ContactGroupCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    
    private func commonInit() {
        self.layer.cornerRadius = 10
        self.cellBackgroundImage.image = UIImage(named: "YA_Group_Image")
//        groupNameLabel.textColor = UIColor.scribeGrey1
//        let overlay = CALayer()
//        overlay.backgroundColor = UIColor(red: 10.0, green: 10.0, blue: 10.0, alpha: 1.0).cgColor
        //        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//        cellBackgroundImage.layer.addSublayer(overlay)
    }
    
    internal func populateCell(with model: contactGroupVO) {
        self.commonInit()
        self.groupNameLabel.text = model.name
    }
}
