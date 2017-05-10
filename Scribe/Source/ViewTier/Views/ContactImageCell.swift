//
//  ContactImageCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public class ContactImageCell: UITableViewCell {

    @IBOutlet weak var contactAvatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
