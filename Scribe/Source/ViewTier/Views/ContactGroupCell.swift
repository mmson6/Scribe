//
//  ContactGroupCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public enum ContactGroups {
    case Fathers
    case Mothers
    case YoungAdults
    case Teachers
    case Choir
}

class ContactGroupCell: UICollectionViewCell {
    
    public var lookupKey: Any?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    public func commonInit() {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.scribeGrey1.cgColor
        
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}
