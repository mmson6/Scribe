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
    @IBOutlet weak var userBackgroundView: UIView!
    @IBOutlet weak var smallNameLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    public override func prepareForReuse() {
        self.smallNameLabel.isHidden = true
    }
    
    private func commonInit() {
//        let contactImage = FAKIonIcons.iosContactIcon(withSize: 100 )
        self.backgroundColor = UIColor.scribeColorCDCellBackground
        
//        self.nameLabel.textColor = UIColor.white
        self.contactAvatarView.backgroundColor = UIColor.black
        
//        self.userBackgroundView.backgroundColor = UIColor.scribeColorImageBackground
        self.contactAvatarView.backgroundColor = UIColor.white
        self.contactAvatarView.layer.cornerRadius = 55
        self.contactAvatarView.layer.borderColor = UIColor.scribeColorDarkGray.cgColor
        self.contactAvatarView.layer.borderWidth = 2

        //        self.contactAvatarView.image = contactImage?.image(with: CGSize(width: 100, height: 100))
    }

    public func populate(with model: ContactInfoVOM) {
        self.nameLabel.text = model.value
    }
}
