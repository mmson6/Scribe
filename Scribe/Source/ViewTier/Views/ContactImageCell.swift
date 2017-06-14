//
//  ContactImageCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FontAwesomeKit

public class ContactImageCell: UITableViewCell {

    @IBOutlet weak var contactAvatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let contactImage = FAKIonIcons.iosContactIcon(withSize: 100 )
        self.contactAvatarView.image = contactImage?.image(with: CGSize(width: 100, height: 100))
    }

    public func populate(with model: ContactInfoVOM) {
        self.nameLabel.text = model.value
    }
}
