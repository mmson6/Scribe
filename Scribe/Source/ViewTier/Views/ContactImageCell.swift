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

    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var closeButton: UIButton!
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
    @IBAction func closeButtonTapped(_ sender: Any) {
        print("success")
    }
    
    private func commonInit() {
//        let contactImage = FAKIonIcons.iosContactIcon(withSize: 100 )
        self.backgroundColor = UIColor.scribeColorCDCellBackground
        self.contactAvatarView.backgroundColor = UIColor.black
        self.contactAvatarView.backgroundColor = UIColor.white
        self.contactAvatarView.layer.cornerRadius = 70
        self.contactAvatarView.layer.borderColor = UIColor.white.cgColor
        self.contactAvatarView.layer.borderWidth = 0.5
        
        self.selectionStyle = .none

        self.closeButton.setTitle("\u{f00d}", for: .normal)
        self.setShadowEffect()
    }
    
    public func setShadowEffect() {
        self.closeButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.closeButton.layer.shadowColor = UIColor.black.cgColor
        self.closeButton.layer.shadowRadius = 4
        self.closeButton.layer.shadowOpacity = 0.45
        self.closeButton.layer.masksToBounds = false
    }

    public func populate(with model: ContactInfoVOM) {
        self.nameLabel.text = model.value
    }
}
