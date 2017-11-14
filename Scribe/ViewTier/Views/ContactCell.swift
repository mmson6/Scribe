//
//  ContactCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FontAwesomeKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
//    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    
    public var lookupKey: Any?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
//        let contactImage = FAKIonIcons.iosContactIcon(withSize: 100 )
//        self.avatarImageView.image = contactImage?.image(with: CGSize(width: 100, height: 100))
    }
    
    internal func commonInit() {
        self.avatarImageView.layer.cornerRadius = 22.5
        self.nameLabel.isHidden = false
        self.nameLabel.textColor = UIColor.scribeDesignTwoDarkBlue
//        self.avatarImageView.layer.cornerRadius = 25
        self.subNameLabel.isHidden = false
//        self.layer.backgroundColor = UIColor.scribePintNavBarColor.cgColor
        self.setNeedsLayout()
    }
//    
//    internal func setShadowEffect() {
//        self.cellLayoutView.layer.cornerRadius = 3
//        self.cellLayoutView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.cellLayoutView.layer.shadowColor = UIColor.black.cgColor
//        self.cellLayoutView.layer.shadowRadius = 3
//        self.cellLayoutView.layer.shadowOpacity = 0.15
//        self.cellLayoutView.layer.masksToBounds = false
//    }
    
}
